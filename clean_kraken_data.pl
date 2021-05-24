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
open (B, ">$file.clean")||die "could not open $file.clean\n";
my $count=0;
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    my @tmp=split /\t/, $a;
    for($tmp[0]){
	s/[^a-zA-Z0-9|]/_/gi;
    }
    print STDERR (scalar @tmp), "\n";
    print B $tmp[0];
    for(my $i=1; $i<@tmp; $i++){
	print B "\t", $tmp[$i];
    }
    print B "\n";
	
}
close A;
close B;
