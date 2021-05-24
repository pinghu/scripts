#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [file] first line is title\n"; 
die $usage unless @ARGV ==1;
my ($file) = @ARGV;

open (A, "<$file")||die "could not open $file\n";
open (B, ">$file.xls")||die "could not open $file.xls\n";
while (my $a=<A>){
    chomp $a;
    for($a){
	s/^\[\d+\]\s+\"//gi;
	s/^\s+\[\d+\]\s+\"//gi;
	s/\"//gi;
    }
    my @tmp=split /\,/, $a;
    print B $tmp[0];
    for(my $i=1; $i<@tmp; $i++){
	print B "\t", $tmp[$i];
    }
    
    print B  "\n";
}
close A;
close B;
