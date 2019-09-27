#/usr/bin/perl -w
use strict;
use POSIX;

# "***"代表不可见路径

my $list = shift;
my $outdir = shift;

my $config = "***/Configure"; 
my $datadir = "***"; 
my $htm2pdf_py = "***/pipeline/bin/htm2pdf.py";
open L,"$list" or die $!;
while (<L>){
	chomp;
    my @a = split;
    my $sam = $a[0];
	my $samdir = "$outdir/$sam";
	my $tmp = "$samdir/tmp";
	my $info = "$samdir/info"; 
	my $code = "$config/tmp/code2000.ttf";
	if (-d $samdir and -d $tmp and -d $info and -f "$tmp/code2000.ttf"){
      
    }else{
		`mkdir $samdir`;
        `mkdir $tmp`;
        `mkdir $info`;
       	`ln -s $code $tmp`;
	}
	open S2,">$tmp/step2.prepare.sh" or die $!;		
	open S3,">$tmp/step3.python.sh" or die $!;
    my $fm = "$config/tmp/fm.pdf";
    my $head = "$config/tmp/head.html";
    my $page1 = "$config/tmp/page1.pdf";
	print S2 "cp $fm $page1 $tmp\n";
	my $stat = "$datadir/$sam/stat/$sam.stat";
	my $pheno = "***/sampleinfo/pheno.info";
	#page2-- 检测说明
	my ($vip,$age,$gender,$date);
	open P,"$pheno" or die $!;
	while (<P>){
		chomp; # ******
		my @b = split;
		if ($b[-4] eq $sam){
			$vip = $b[0];
			$age = $b[-1];
			$gender = $b[-2];
			$date = $b[-3];
		}
	}
	close P;
#	print "$sam\t$age\t$gender\t$date\n";	
	my ($real_age,$immune_score,$defeat_population,$defeat_same_age);
	my ($vj_div,$immune_div,$immune_num,$immune_eve,$immune_age);
	my ($vj_div_range,$immune_div_range,$immune_num_range,$immune_eve_range,$immune_age_range);
	my ($vj_div_ass,$immune_div_ass,$immune_num_ass,$immune_eve_ass,$immune_age_ass);
	my $Immune_score_ass;
	open ST,"$stat" or die $!;
	while (<ST>){
		chomp;
		my @c = split /\t/;
		$real_age = $1 if (/Real_age:\s+(\d+)/);
		$immune_score = $1 if (/Immune_score:\s+(\d+)/);
		$defeat_population = $1 if (/Defeat_population:\s+(\d+)/);
		$defeat_same_age = $1 if (/Defeat_same_age:\s+(\d+)/);
		if (/"***"/){
			$vj_div = $c[1];
			$vj_div_range = $c[2];		
			$vj_div_ass = &Ass($c[3]);
		}elsif (/"***"/){
			$immune_div = $c[1];
			$immune_div_range = $c[2];
			$immune_div_ass = &Ass($c[3]);
		}elsif (/"***"/){
			$immune_num = $c[1];
			$immune_num_range = $c[2];
			$immune_num_ass = &Ass($c[3]);
		}elsif (/"***"/){
			$immune_eve = $c[1];
			$immune_eve_range = $c[2];
			$immune_eve_ass = &Ass($c[3]);
		}elsif (/"***"/){
			$immune_age = $c[1];
			$immune_age_range = $c[2];
			$immune_age_ass = &Ass($c[3]);
		}elsif (/>="***"/){
			$Immune_score_ass = &Ass($c[3]);		
		}
	}
	close ST;
#	print "$real_age\t$immune_score\t$defeat_population\t$defeat_same_age\n";
	open P2,"$config/tmp/page2.tmp" or die $!;
	open S_P2,">$tmp/page2.tmp" or die $!;
	while (<P2>){
		chomp;
		if (/Sample/){
			print S_P2 "    <td style=\"background:white\">$vip</td>    <td style=\"background:white\">$age</td>    <td style=\"background:white\">$gender</td>    <td style=\"background:white\">***</td>    <td style=\"background:white\">$sam</td>    <td style=\"background:white\">$date</td>  </tr>\n";
		}else{
			print S_P2 "$_\n";
		}
	}
	close P2;
	close S_P2;		
	print S3 "python $htm2pdf_py -i $tmp/page2.tmp -o $tmp/page2.pdf\n";
	#page3,page4,page5,page6,page7
	print S2 "cp $config/tmp/page3.pdf $config/tmp/page4.pdf $config/tmp/page5.pdf $config/tmp/page6.pdf $config/tmp/page7.pdf $tmp\n";
	#page8-------检测结果---***
	open P8,"$config/tmp/page8.tmp" or die $!;
	open S_P8,">$tmp/page8.tmp" or die $!;
	while (<P8>){
		chomp;
		if (/VIP/){
			print S2 "***/bin/Rscript ***/pipeline/bin/gauge3.R $immune_score *** $real_age $defeat_same_age $defeat_population $info/$sam.gauge.jpg ***/bin/simsun.ttc\n";
			print S_P8 "<p align=\"center\"><img id=\"test_img\" width=\"600\" src=\"$info/$sam.gauge.jpg\"></p>\n";
		}elsif(/***/){
			print S_P8 "<p>&nbsp;&nbsp;&nbsp;&nbsp;&nbsp;***：<font color=\"#2DB450\">$Immune_score_ass</font></p>\n";
		}else{
			print S_P8 "$_\n"; 
		}
	}
	close P8;
	close S_P8;
	print S3 "python $htm2pdf_py -i $tmp/page8.tmp -o $tmp/page8.pdf\n";
	#page9 ------检测结果--***
	open P9,"$config/tmp/page9.tmp" or die $!;
	open S_P9,">$tmp/page9.tmp" or die $!;
	while (<P9>){
		chomp;
		if (/VIP/){
			print S_P9 "<p align=\"center\"><img id=\"test_img\" src=\"$config/jpg/$sam.jpg\"width=\"540\" height=\"430\"></p>\n";
		}elsif (/***/){
			print S_P9 "<td style=\"background:white\">***</td>    <td style=\"background:white\">$vj_div</td>    <td style=\"background:white\">$vj_div_range</td>    <td style=\"background:white\">$vj_div_ass</td>  </tr>\n";
		}elsif (/***/){
			print S_P9 "<td style=\"background:white\">***</td>    <td style=\"background:white\">$immune_div</td>    <td style=\"background:white\">$immune_div_range</td>    <td style=\"background:white\">$immune_div_ass</td>  </tr>\n";
		}elsif (/***/){
			print S_P9 "<td style=\"background:white\">***</td>    <td style=\"background:white\">$immune_num</td>    <td style=\"background:white\">$immune_num_range</td>    <td style=\"background:white\">$immune_num_ass</td>  </tr>\n";
		}elsif (/***/){
			print S_P9 "<td style=\"background:white\">***</td>    <td style=\"background:white\">$immune_eve</td>    <td style=\"background:white\">$immune_eve_range</td>    <td style=\"background:white\">$immune_eve_ass</td>  </tr>\n";
		}elsif (/***/){
			print S_P9 "<td style=\"background:white\">***</td>    <td style=\"background:white\">$immune_age</td>     <td style=\"background:white\">$immune_age_range</td>   <td style=\"background:white\">$immune_age_ass</td>  </tr>\n";
		}else{
			print S_P9 "$_\n";
		}
	}
	close P9;
	close S_P9;		
	print S3 "python $htm2pdf_py -i $tmp/page9.tmp -o $tmp/page9.pdf\n";		
	#page10 --------检测结果---***
	open P10,"$config/tmp/page10.tmp" or die $!;
	open S_P10,">$tmp/page10.tmp" or die $!;
	while (<P10>){
		chomp;
		if (/VIP/){
			my $R = "$config/tmp/VJ_pairing_3d.R";
			my $out3d = "$info/$sam.3d";
			print S2 "***/bin/Rscript $R $datadir/$sam/***/$sam\_VJ_pairing.usage $out3d NA ***/simsun.ttc\n";
			my $pdf_3d = "$info/$sam.3d.pdf";
			my $jpg_3d = "$info/$sam.3d.jpg";
			print S2 "convert  $pdf_3d $jpg_3d\n";
			print S_P10 "<p align=\"center\" ><img id=\"test_img\" width=\"500\" src=\"$info/$sam.3d.jpg\"></p>\n";
		}else{
			print S_P10 "$_\n";
		}
	}
	close P10;
	close S_P10;
	print S3 "python $htm2pdf_py -i $tmp/page10.tmp -o $tmp/page10.pdf\n";
	#page11---***
	open P11,"$config/tmp/page11.tmp" or die $!;
	open S_P11,">$tmp/page11.tmp" or die $!;
	while (<P11>){
		chomp;
		if (/VIP/){
			print S2 "perl $config/tmp/getDisease.info.pl $stat $info/$sam.disease.info\n";
			print S2 "***/bin/Rscript $config/tmp/disease.plot.R $info/$sam.disease.info $info/$sam.disease.pdf ***/simsun.ttc\n";
			print S2 "convert $info/$sam.disease.pdf $info/$sam.disease.jpg\n";
			print S_P11 "<p align=\"center\"><img id=\"test_img\"  src=\"$info/$sam.disease.jpg\"></p>\n";
		}else{
			print S_P11 "$_\n";
		}
	}
	close P11;
	close S_P11;
	print S3 "python $htm2pdf_py -i $tmp/page11.tmp -o $tmp/page11.pdf\n";
	#page12---***
	print S2 "cp $config/tmp/page12.pdf $tmp\n";
	#page VJ list
	my $vj_stat = "$tmp/$sam\_VJ.stat";
	print S2 "*** > $vj_stat\n";
	print S2 "cat $stat|grep TRBV|grep TRBJ >> $vj_stat\n";
	print S2 "perl $config/tmp/split.VJTable.pl $vj_stat $config/tmp/background.0424.htm\n";
	for (my $i=1;$i<35;$i++){
		my $out = "$tmp/pageVJ.$i.pdf";
		print S3 "python $htm2pdf_py -i $vj_stat.$i -o $out\n";
	}
	#page disease list
	my $disease_stat = "$tmp/$sam\_disease.stat";
	print S2 "echo *** > $disease_stat\n";
	print S2 "perl $config/tmp/Find_known_disease_clone.VIP.pl $datadir/$sam/***/$sam\_CDR3_AA.frequency.gz ***/all.new.tcr.disease.clone ***/Filter/Known_disease.cutoff >> $disease_stat\n";
	print S2 "perl $config/tmp/split.DiseaseTable.pl $disease_stat $config/tmp/background.0424.htm\n";
	for (my $j=1;$j<14;$j++){
		my $out = "$tmp/pagedisease.$j.pdf";
		print S3 "python $htm2pdf_py -i $disease_stat.$j -o $out\n";
	}
	print S2 "cp $config/tmp/page13.pdf $tmp\n";
	my $year_month_day = strftime("%Y%m%d",localtime());
}
close L;

sub Ass{
	my $file = shift;
	my $ass;
	if ($file eq "Normal"){
		$ass = "***";
	}elsif($file eq "Down" or $file eq "Bad" or $file eq "Older"){
		$ass = "***";	
	}elsif($file eq "Up" or $file eq "Excellent" or $file eq "Younger"){
		$ass = "***";
	}elsif($file eq "Good"){
		$ass = "***";
	}else{
		print "ERROR in assessment:$file\n";
	}
	return $ass;
}
