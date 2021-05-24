#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [listfile][head][path] first line is title\n"; 
die $usage unless @ARGV ==3;
my ($file, $head, $path) = @ARGV;

open (A, "<$file")||die "could not open $file\n";
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    my @tmp=split /\./, $a;
    $tmp[0]=$path."/".$head;
    my $new=join("\.", @tmp);
    system("cp $a $new\n");
    print("cp $a $new\n");
}
close A;
