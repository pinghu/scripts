#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
use List::Util qw[min max];
my $usage="$0  [file] first line is title\n"; 
die $usage unless @ARGV ==1;
my ($datafile) = @ARGV;


open (A, "<$datafile")||die "could not open $datafile \n";
open (B, ">$datafile.fc")||die "could not open $datafile.real \n";
open (C, ">$datafile.real")||die "could not open $datafile.real \n";
my $tt=<A>;
chomp $tt;
for($tt){s/\r//gi;}
my @tmp=split /\t/, $tt;
print B "gene";
print C "gene";
for(my $i=4; $i<@tmp; $i++){
    print B "\tfc.", $tmp[$i];
    print C "\tsignal.", $tmp[$i];
}
print B "\n";
print C "\n";

while (my $a=<A>){
    chomp $a;for($a){s/\r//gi;}
    my @tmp=split /\t/, $a;
    my $MM=2**$tmp[2];
    print B $tmp[0];
    print C $tmp[0];
    for(my $i=4; $i<@tmp; $i++){
	my $value=2**$tmp[$i];
	print C "\t", $value;
	my $fc=$value/$MM;
	if($fc<1){
	    $fc=-1/$fc;
	}
	print B "\t", $fc;
    }
    print B "\n";
    print C "\n";
 
}
close A;
close B;
close C;
