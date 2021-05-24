#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
#my $usage="$0  <file>  <file2>\n"; 
#die $usage unless @ARGV == 2;
my ($file) = @ARGV;



open (A, "<$file")||die "could not open $file\n";
while (my $a=<A>){
    chomp $a;
    if ($a =~ /\>(\S+)/){
	my $id=$1;
	my $conseq=<A>;
	chomp $conseq;
	for ($conseq){
	    s/^N*//gi;
	    s/N*$//gi;
	    s/N{5,}/NNNNN/gi;
	}
	my $tmp=$conseq;
	for ($tmp){s/N//gi;}
	if (length($tmp)>50){
	    print $a, "\n", $conseq, "\n";
	}
    }
    
}
close A;
