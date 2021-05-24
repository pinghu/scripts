#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;

my ($file1, $file2) = @ARGV;

my %data;
open (C, "<$file1")|| die "could not open $file1\n";

while (my $M =<C>){
    chomp $M;
    my @tmp=split /\t/, $M;
    $data{$tmp[0]}=$M;
}
close C;
    
open (C, "<$file2")|| die "could not open $file2\n";

while (my $M =<C>){
    chomp $M;
    my @tmp=split /\t/, $M;
    print $M, "\t";
    if (defined $data{$tmp[0]}){
	print $data{$tmp[0]};
    }
    print "\n";
}
close C;
    
