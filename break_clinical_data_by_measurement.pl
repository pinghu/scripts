#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [file][col] first line is title\n"; 
die $usage unless @ARGV ==2;
my ($file, $col) = @ARGV;

open (A, "<$file")||die "could not open $file\n";

my $x=<A>;
my %BB;
while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    $BB{$tmp[$col-1]}{$a}=1;
}
close A;

foreach my $i (keys %BB){
    open (A, ">$file.$i")||die "could not open $file.$i\n";
    print A $x;
    foreach my $j (keys %{$BB{$i}}){
	print A $j, "\n";
    }
    close A;
}
