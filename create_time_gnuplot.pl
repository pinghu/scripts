###################################################################
# v1: working for k-means
# add in the variance calculation and the probability calculation
###################################################################
#!/usr/bin/perl -w
use strict;
open (AA, "<test")||die "could not open GSE11186_series_matrix.txt\n";
my $tics=<AA>;
chomp $tics;
my @tt=split /\t/, $tics;

while (my $line=<AA>){
    chomp $line;
	my @tmp=split /\t/, $line;
	my $gene=$tmp[0]." ".$tmp[1]. " ".$tmp[2];
	for ($gene){
		s/\"//gi;
		s/\'//gi;
	}
	my $aff=$tmp[0];
	my $tic_string="";
	open (BB,  ">$aff.dat")||die "could not open $aff.dat\n";
    for (my $i=3; $i<@tmp; $i++){
	 print BB "# $gene Lin's Circadian Study GSE11186\n";
	 print BB $tt[$i], "\t", ($i-1)*2, "\t", $tmp[$i], "\n";
	 $tic_string.="\"".$tt[$i]."\" ".(($i-1)*2).",";
	}
	close BB;
	for ($tic_string){
		s/\,$//;
	}
	open (BB,  ">$aff.plot")|| die "could not open $aff.plot\n";
    print BB "set terminal jpeg\n";
	print BB "set output \"$aff.jpeg\"\n";
	print BB "set title \"$gene Lin GSE11186\"\n"; 
	print BB "set xtics ($tic_string)\n";
	print BB "plot \"$aff.dat\" using 2:3 with linespoints\n";	
	close BB;
	
	system ("gnuplot $aff.plot");
}
close AA;
