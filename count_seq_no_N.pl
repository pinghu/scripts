#!/usr/bin/perl -w
use strict;
my $usage = "usage: $0 <dir>\n";
die $usage unless @ARGV == 1;
my ($file) = @ARGV;


chomp $file;
my	$A=0;
my	$C=0;
my	$G=0;
my	$T=0;
my	$N=0;
my	$totalA=0;
my	$totalC=0;
my	$totalG=0;
my	$totalT=0;
my	$totalN=0;
my $contig=0;
my $name="";
open(NN,"<$file") or die "Cannot open $file to read.\n";
while(my $line =<NN>){
    chomp $line;
    if ($line=~ />/){
	if ($name ne ""){
	    $contig++;
	    print $file,"\t",$name, "\tcount(A)=$A\tcount(C)=$C\tcount(G)=$G\tcount(T)=$T\tcount(N)=$N\n";
	    $totalA += $A;
	    $totalC += $C;
	    $totalG += $G;
	    $totalT += $T;
	    $totalN += $N;
	}
	$name= $line;
	$A=0;
	$C=0;
	$G=0;
	$T=0;
	$N=0;
    }else{
	my $len=length($line);
	for($line){s/[Aa]//gi;}
	my $len2=length($line);
	$A += $len-$len2;
	for($line){s/[Tt]//gi;}
	my $len3=length($line);
	$T += $len2-$len3;
	for($line){s/[Gg]//gi;}
	my $len4=length($line);
	$G += $len3-$len4;
	for($line){s/[Cc]//gi;}
	my $len5=length($line);
	$C += $len4-$len5;
	for($line){s/[Nn]//gi;}
	my $len6=length($line);
	$N += $len5-$len6;
	if ($len6 !=0){print STDERR  $line, "\n";}
	
    }
}
close NN;
print $file,"\t",$name, "\tcount(A)=$A\tcount(C)=$C\tcount(G)=$G\tcount(T)=$T\tcount(N)=$N\n";
$totalA += $A;
$totalC += $C;
$totalG += $G;
$totalT += $T;
$totalN += $N;
$contig++;
my $total=$totalA+$totalG+$totalC+$totalT;
my $GC=100*($totalG +$totalC)/$total;
print $file,"\tTotal Length $total\tcount(A)=$totalA\tcount(C)=$totalC\tcount(G)=$totalG\tcount(T)=$totalT\tcount(N)=$totalN\tContig Number $contig\tGC percentage $GC %\n";
