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
open (B, ">$file.clean")||die "could not open $file.less\n";

my $x=<A>;
print B $x;

while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    
    for(my $i=0; $i<@tmp; $i++){
	for($tmp[$i]){
	    s/\'//gi;
	    s/\"//gi;
	}
	if ($tmp[$i] =~/\/\/\//){
	    my @xxx =split /\/\/\//, $tmp[$i];
	    $tmp[$i]=$xxx[0];
	}else{
	    for($tmp[$i]){s/\// /gi;}
	}
        print B join("\t", @tmp), "\n";
    }
}
close A;
close B;

