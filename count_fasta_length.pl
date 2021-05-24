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
my $total=0;
my $totalN=0;
my %LLL;
open (A, "<$file")||die "could not open $file\n";
while (my $a=<A>){
    chomp $a;
    
    if ($a =~ /\>\S+/){
	$totalN++;
	if ($name ne ""){
	    for($seq){s/\r//gi; s/\s+//gi;}
	    my $beforelen=length($seq);
	    print STDERR $name, "\t", $beforelen, "\n";
	    
	    if (! defined $LLL{$beforelen}){
		$LLL{$beforelen}=1;
	    }else{
		$LLL{$beforelen}++;
	    }
	    $total+=$beforelen;
	} 
	$name=$a;
	$seq="";
    }else{
	$seq.=$a;
    }
    
}
close A;

if ($name ne ""){
    for($seq){s/\r//gi; s/\s+//gi;}
    my $beforelen=length($seq);
    print STDERR $name, "\t", $beforelen, "\n";
    $total+=$beforelen;
    if (! defined $LLL{$beforelen}){
	$LLL{$beforelen}=1;
    }else{
	$LLL{$beforelen}++;
    }
    $totalN++;
}
#print "======SeqLength\tSeqNumber=====\n";
foreach my $i(keys %LLL){
    print $i, "\t", $LLL{$i}, "\n";
}
print "$file\tTotal \t$totalN\t fragments; Total \t$total\t bp; Average", int($total/$totalN) , "bases\n";
