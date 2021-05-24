#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  <file>  \n"; 
die $usage unless @ARGV == 1;
my ($file) = @ARGV;
my $name="";
my $seq="";
open (A, "<$file")||die "could not open $file\n";
while (my $a=<A>){
    chomp $a;
    
    if ($a =~ /\>\S+/){
	if ($name ne ""){
	    my $beforelen=length($seq);
	    for ($seq){s/[^ACGTacgt]//gi;}
	    print $name, "\n", $seq, "\n";
	    print STDERR $beforelen, "\t", length($seq), "\t", $name,"\n";
	}
	$name=$a;
	$seq="";
    }else{
	$seq.=$a;
    }
    
}
close A;
 my $beforelen=length($seq);
for ($seq){s/[^ACGTacgt]//gi;}
print $name, "\n", $seq, "\n";
print STDERR $beforelen, "\t", length($seq), "\t", $name,"\n";

