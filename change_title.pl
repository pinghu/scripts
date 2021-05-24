#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  <file> <mapfile>\n"; 
die $usage unless @ARGV >= 2;
my ($file, $mapfile) = @ARGV;
my %Nmap;
open (A, "<$mapfile")||die "could not open $file\n";
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    my @tmp=split /\t/, $a;
    if(defined $tmp[1]){
	$Nmap{$tmp[0]}=$tmp[1];
    }
}
close A;

open (A, "<$file")||die "could not open $file\n";
my $a=<A>;
chomp $a;
for($a){s/\r//g;}
my @tmp=split /\t/, $a;
my @new;
for (my $i=0; $i<@tmp; $i++){
    my $nn=$tmp[$i];
    if(defined $Nmap{$tmp[$i]}){
	$nn =$Nmap{$tmp[$i]};
    }
    push(@new, $nn);
}
print join("\t", @new), "\n";
while (my $a=<A>){
   chomp $a;
   for($a){s/\r//g;}
   print $a, "\n";
}
close A;

