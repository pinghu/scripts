#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [file][factor estimateCount=1; RelativeAbundant=10000] first line is title\n"; 
die $usage unless @ARGV ==2;
my ($file, $factor) = @ARGV;

open (A, "<$file")||die "could not open $file\n";
open (B, ">$file.phy")||die "could not open $file.phy\n";

my $x=<A>;
chomp $x;
for ($x){s/\r//gi;}
my @tmp=split /\t/, $x;

print B "# QIIME v1.2.1-dev OTU table\n#OTU ID";
for(my $i=1; $i<@tmp; $i++){
    print B "\t", $tmp[$i];
}
print B "\tConsensus Lineage\n";


my $count=1;
#my $factor=100000;
while (my $a=<A>){
    chomp $a;
    for ($a){s/\r//gi;}
    my @tmp=split /\t/, $a;
    print B $count;
    $count++;
    for(my $i=1; $i<@tmp; $i++){
	print B "\t", $tmp[$i]*$factor;
    }
    my $xx=$tmp[0];
    for($xx){s/\|/\; /gi}
    print B "\t$xx\n";
 
    
}
close A;
close B;
