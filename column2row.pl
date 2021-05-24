#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [p][col][file] first line is title\n"; 
die $usage unless @ARGV ==1;
my ($file) = @ARGV;

open (A, "<$file")||die "could not open $file\n";

while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    print ",", $tmp[0];
}
close A;
print "\n";
