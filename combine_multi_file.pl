#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [file] first line is title\n"; 
die $usage unless @ARGV ==1;
my ($list) = @ARGV;

open (A, "<$list")||die "could not open $list\n";
while (my $file=<A>){
    chomp $file;
    for($file){s/\r//gi;}
    open (B, "<$file")||die "could not open $file\n";
    while (my $a=<B>){
	chomp $a;
	for($a){s/\r//gi;}
	print $file, "\t", $a, "\n";
	
    }
    close B;
}
close A;
