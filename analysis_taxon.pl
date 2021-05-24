#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### give rdp taxon infor to calculate eaxh level how many diversity
##########################################################################
use strict;
my $usage="$0  [p][col][file] first line is title\n"; 
die $usage unless @ARGV ==2;
my ($col,$file) = @ARGV;

open (A, "<$file")||die "could not open $file\n";
my %data;
while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    my $taxons=$tmp[$col-1];
    my @xx=split /\;/, $taxons;
    for(my $i =0; $i<@xx; $i++){
	my $check=$xx[$i];
	if ($check=~/(\S)(\_)+(\S+)/){
	    
	    my $type=$1;
	    my $name=$3;
	    $data{$type}{$name}=1;
	}
    }
}
close A;

foreach my $i (keys %data){
    my $count=0;
    foreach my $j (keys %{$data{$i}}){
	$count++;
    }
    print $i, "\t", $count, "\n";
}
