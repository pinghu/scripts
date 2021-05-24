#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;

my ($filelist) = @ARGV;
my %data;
my %COG;
my @files;
open (A, "<$filelist")||die "could not open $filelist\n";
while (my $a=<A>){
    chomp $a;
    push (@files, $a);
}
close A;

foreach my $file (@files){

    open (B, "<$file")|| die "could not open $file\n";

    while (my $line =<B>){
	chomp $line;
	my @tmp=split /\t/, $line;
	$COG{$tmp[0]}=$tmp[2]. "\t". $tmp[3];
	$data{$file}{$tmp[0]}=$tmp[1];
       
    }
    close B;
	
}
print "COG_CODE\tCOG\tCategory";
foreach my $k(@files){
    print "\t", $k;
}
print "\n";

foreach my $i (sort keys %COG){
    print $i, "\t", $COG{$i};
    foreach my $j (@files){
	if (defined $data{$j}{$i}){
	    print "\t",  $data{$j}{$i};
	}else{
	    print "\t0";
	}
    }
    print "\n";
} 

