#!/usr/bin/perl -w
use strict;
use Data::Dumper;


die "perl $0 <file.list><rand_num><flag><out>\n" unless(@ARGV==4);

my ($file, $Num_for_cal_uniq, $flag_out, $out) = @ARGV;
#my $Num_for_cal_uniq = 100000;

my $Bin = "/ldfssz1/ST_HEALTH/Immune_And_Health_Lab/Pan-IR_F14ZQSYJSY1696/zhangwei/Lupus/Bin/Overal_stat";
my $Rscript = "/hwfssz1/ST_HEALTH/Immune_And_Health_Lab/Public_Software/R/R-3.4.1/bin/Rscript";

my %list;

open O, ">$out" or die;
print O "sample\tflag\tuniq_clone\tclone_shannon\tclone_Pielou\tclone_Gini\tclone_CR4\ttop100\thigh_clone_num\tVJ_Gini\tVJ_Pielou\tVJ_CR4\n";

open I, "$file" or die;
while(<I>)
{
	chomp;
	my @line = split;
	my $id = $line[0];
	my $id_vj = $line[1];
	$list{$line[2]} = [($id, $id_vj)];
}
close I;


for my $id (keys %list)
{
	my ($cdr3_f, $vj_f) = @{$list{$id}};
        my $top100 = 0;
        my $high_clone_num = 0;
        open I, "gzip -dc $cdr3_f|" or die;
#       my $num = 0;
        my $sum = 0;
#---------	read Clones' file
        my %all_new;
        while(<I>)
        {
                chomp;
                my @line = split;
                $sum += $line[1];
                $all_new{$line[0]} = $line[1];
#                $top_num++ if($line[2] >= 0.1);
        }
        close I;
	
	if($sum<$Num_for_cal_uniq)# the total sequence number is less than $Num_for_cal_uniq
	{
#		print O "$id\t$flag_out\t-\t-\t-\t-\t-\t-\t-\t-\t-\t-\t\n";
#		next;
		$Num_for_cal_uniq = $sum;
	}
	
        # get random sequence for calculating unique clone sequence number
        my %rand = &Rand_num($sum);
        my $flag_num = 0;
        my %new_uniq;
	my $clone_CR4 = 0;
        my $flag_sum = 0;
	open T, ">$out.tmp" or die;
        for my $cdr3 (sort {$all_new{$b}<=>$all_new{$a}} keys %all_new)
        {
                $flag_num++;
                for(1..$all_new{$cdr3}){
                        my $n = $flag_sum + $_;
                        if(exists $rand{$n}){
                                $new_uniq{$cdr3}++;
                        }
                }

		if(exists $new_uniq{$cdr3}){
			my $rate = $new_uniq{$cdr3}/$Num_for_cal_uniq*100;
			print T "$cdr3\t$new_uniq{$cdr3}\t$rate\n";
			$high_clone_num++ if($rate >=0.1);	
			if($flag_num<=100){
				$clone_CR4 += $new_uniq{$cdr3} if($flag_num<=4);
				$top100 += $new_uniq{$cdr3};
			}
		}
                $flag_sum += $all_new{$cdr3};
        }
	close T;
#print Dumper(\%new_uniq);
        $top100 = $top100/$Num_for_cal_uniq*100;
	$clone_CR4 = $clone_CR4/$Num_for_cal_uniq*100;
        my $uniq_num = scalar(keys %new_uniq);
	my $shannon = `perl /$Bin/Shannon_entropy_index.diversity.pl $out.tmp 1`;
	chomp($shannon);
	my $clone_gini = `$Rscript $Bin/Gini.R $out.tmp`;
	chomp($clone_gini);
	$clone_gini = (split /\s+/,$clone_gini)[1];
	my $clone_eveness = $shannon/(log($uniq_num)/log(2));
	print O "$id\t$flag_out\t$uniq_num\t$shannon\t$clone_eveness\t$clone_gini\t$clone_CR4\t$top100\t$high_clone_num";


#---------------------------		VJ Pairing		----------------
	my $sum_vj = `awk '{a+=\$3}END{print a}' $vj_f`;
	chomp($sum_vj);
	my %rand_vj = &Rand_num($sum_vj);
	open I, "$vj_f" or die;
	open T, ">$out.tmp.vj" or die;
	my $flag_num_vj = 0;
	my %new_uniq_vj;
	my $flag_sum_vj = 0;

	my $VJ_CR4 = 0;

	while(<I>)
	{
		chomp;
		my @line = split;
		my $com = "$line[0]\t$line[1]";
		$flag_num_vj++;
		for(1..$line[2]){
			my $n = $flag_sum_vj + $_;
			if(exists $rand_vj{$n}){
				$new_uniq_vj{$com}++;
			}
		}
		if(exists $new_uniq_vj{$com}){
			my $rate = $new_uniq_vj{$com}/$Num_for_cal_uniq*100;
			print T "$line[0]\t$line[1]\t$new_uniq_vj{$com}\t$rate\n";
		}
		$flag_sum_vj += $line[2];
	}
	close I;
	my @Rank = sort {$new_uniq_vj{$b}<=>$new_uniq_vj{$a}} keys %new_uniq_vj;
	$VJ_CR4 = $new_uniq_vj{$Rank[0]} + $new_uniq_vj{$Rank[1]} + $new_uniq_vj{$Rank[2]} + $new_uniq_vj{$Rank[3]};
	$VJ_CR4 = $VJ_CR4/$Num_for_cal_uniq*100;
	my $VJ_Gini = `$Rscript $Bin/Gini.R $out.tmp.vj`;
	chomp($VJ_Gini);
	$VJ_Gini = (split /\s+/,$VJ_Gini)[1];
	my $VJ_eveness =`perl $Bin/Shannon_entropy_index.diversity.pl $out.tmp.vj 1`;
	chomp($VJ_eveness);
	my $uniq_vj = scalar(keys %new_uniq_vj);
	$VJ_eveness = $VJ_eveness/(log($uniq_vj)/log(2));
	print O "\t$VJ_Gini\t$VJ_eveness\t$VJ_CR4\n";
}

sub Rand_num
{
	my ($sum) = @_;
	my %rand;
	while(1){
		if($sum<=$Num_for_cal_uniq){
			$rand{$_} = 1 for(1..$sum);
			last;
		}
		my $N = int(rand($sum))+1;
		$rand{$N} = 1;
		last if(scalar(keys %rand)==$Num_for_cal_uniq);
	}
	return (%rand)
}

close O;
unlink "$out.tmp";
unlink "$out.tmp.vj";

