#!/usr/bin/perl -w
use strict;
my $usage = "usage: $0 <dir>\n";
die $usage unless @ARGV == 1;
my ($file) = @ARGV;


chomp $file;
my $T0=0;
my $T1=0;
my $T2=0;

my $name="";
my $N0=0;
my $N1=0;
my $N2=0;
open(NN,"<$file") or die "Cannot open $file to read.\n";
while(my $line =<NN>){
    chomp $line;
    if ($line=~ />/){
	if ($name ne ""){
	    print $file,"\t",$name, "\tcount(0)\t$N0\tcount(1)\t$N1\tcount(2)\t$N2\n";
	    $T0+=$N0;
	    $T1+=$N1;
	    $T2+=$N2;  
	}
	$name= $line;
	$N0=0;
	$N1=0;
	$N2=0;
    }else{
	my $len=length($line);
	for($line){s/0//gi;}
	my $len2=length($line);
	$N0=$N0+($len-$len2);
	for($line){s/1//gi;}
	my $len3=length($line);
	$N1=$N1+($len2-$len3);
	for($line){s/2//gi;}
	my $len4=length($line);
	$N2=$N2+($len3-$len4); 
    }
	
}
close NN;
print $file,"\t",$name, "\tcount(0)\t$N0\tcount(1)\t$N1\tcount(2)\t$N2\n";
$T0+=$N0;
$T1+=$N1;
$T2+=$N2; 
print $file, "\tall match(1)\t$T1\tall gap(0)\t$T0\tall nomatch(2)\t$T2\n";
