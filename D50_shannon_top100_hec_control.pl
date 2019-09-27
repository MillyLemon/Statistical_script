#!/usr/bin/perl -w
use strict;
die "perl $0 <in.directory> <part name> <D50 or shannon or perc  or top1 or hec> \n"
  if ( @ARGV != 3 );
my @in = glob("$ARGV[0]/*$ARGV[1]*/Cut_seq1");

foreach my $in (@in) {
	my $name = ( split /\//, $in )[-2];
	unless ( -e "$in/$name\_CDR3_AA.frequency.gz" ) {
		print "no $in/$name\_CDR3_AA.frequency.gz\n";
		next;
	}
	if ( $ARGV[2] =~ /D50/i ) {
		&cal_d50( "$in/$name\_CDR3_AA.frequency.gz", $name );
	}
	elsif ( $ARGV[2] =~ /shan/i ) {
		&sha( "$in/$name\_CDR3_AA.frequency.gz", $name );
	}
	elsif ( $ARGV[2] =~ /perc/i ) {  #top100
		&perc( "$in/$name\_CDR3_AA.frequency.gz", $name );
	}
	elsif ( $ARGV[2] =~ /top1/i){
		&top1( "$in/$name\_CDR3_AA.frequency.gz", $name );
	}
	elsif ($ARGV[2] =~ /hec/i){
		&hec( "$in/$name\_CDR3_AA.frequency.gz",$name );
	}
}

sub cal_d50 {
	my ( $file, $flag ) = @_;
	my $all_num = 0;
	my @abundance;

	open I, "zcat $file|" or die;
	while (<I>) {
		chomp;
		push @abundance, (split)[1];
		$all_num = $all_num + (split)[1];
	}
	close I;
	
	@abundance = sort { $b <=> $a } @abundance;
	my $half_abundance = 0;
	for ( my $i = 0 ; $i <= $#abundance ; $i++ ) {
		if (   $half_abundance < $all_num / 2
			&& $half_abundance + $abundance[$i] >= $all_num / 2 )
		{
			print "$flag\t", $i + 1, "\t",
			  ( $i + 1 ) * 100 / ( $#abundance + 1 ), "\n";
			last;
		}
		$half_abundance += $abundance[$i];
	}
}

sub sha {
	my $in   = shift @_;
	my $name = shift @_;
	my $num  = 1000;
	if ( -e $in ) {
		if ( $in =~ /\.gz$/ ) {
			open IN, "gzip -cd $in|" or die "can't open the file $in\n";
		}
		else {
			open IN, "$in" or die "can't open the file $in\n$!\n";
		}
		my $count = 0;
		my $sum   = 0;
		while (<IN>) {
			chomp;
			my @line = split;
			$count++;
			$sum += $line[-2];
			last if ( $count == $num );
		}
		close IN;
		if ( $in =~ /\.gz$/ ) {
			open IN, "gzip -cd $in|" or die "can't open the file $in\n";
		}
		else {
			open IN, "$in" or die "can't open the file $in\n$!\n";
		}
		my $H    = 0;
		my $mark = 0;
		while (<IN>) {
			chomp;
			my @aa   = split;
			my $freq = $aa[-2] / $sum;
			$mark++;
			$H += -$freq * ( log($freq) / log(2) );
			last if ( $mark == $num );
		}
		close IN;
		print "$name\t$H\n";
	}
	else {
		print "$name\tNA\n";
	}
}

sub perc {
	my $in   = shift @_;
	my $name = shift @_;
	my $num  = 100;
	if ( -e $in ) {
		if ( $in =~ /\.gz$/ ) {
			open IN, "gzip -cd $in|" or die "can't open the file $in\n";
		}
		else {
			open IN, "$in" or die "can't open the file $in\n$!\n";
		}
		my $count = 0;
		my $sum   = 0;
		while (<IN>) {
			chomp;
			my @line = split;
			$count++;
			$sum += $line[-1];
			last if ( $count == $num );
		}
		close IN;
		print "$name\t$sum\n";
	}
	else {
		print "$name\tNA\n";
	}
}

sub top1{
	my $in = shift;
	my $name = shift;
	if (-e $in){
		if ($in =~ /\.gz$/){
			open IN,"gzip -cd $in |" or die $!;
		}
		else{
			open IN,"$in" or die $!;
		}
		chomp(my $head = <IN>);
		my $rate = (split /\t/,$head)[-1];
		print "$name\t$rate\n";
	}
	else{
		print "$name\tNA\n";
	}
}

sub hec{
	my $in = shift;
	my $name = shift;
	my $hec = 0.1;
	if (-e $in) {
		if ( $in =~ /\.gz$/){
			open IN,"gzip -cd $in |" or die $!;
		}
		else{
			open IN,"$in" or die $!;
		}
		my $count = 0;
		my $sum   = `zcat $in|wc -l `;
		chomp $sum;
		while (<IN>){
			chomp;
			my @line = split;
			last if ($line[-1] < $hec);
			$count++;
		}
		close IN;
		my $hecrate = ($count/$sum) * 100;
		print "$name\t$hecrate\t$count\n";
	}
	else{
		print "$name\tNA\tNA\n";
	}
}	
