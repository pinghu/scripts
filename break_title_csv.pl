#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  <file> <row>\n"; 
die $usage unless @ARGV >= 1;
my ($file, $row) = @ARGV;
if (! defined $row){
    $row=1;
}
open (A, "<$file")||die "could not open $file\n";
my $n=0;
while (my $a=<A>){
    $n++;
    if ($n == $row){
	chomp $a;
	for($a){s/\r//g;s/\"//gi;}
	my @tmp=split /\,/, $a;
	for (my $i=0; $i<@tmp; $i++){
	    print $i+1, "\t", $tmp[$i], "\n";
	}
	last;
    }
}
close A;

