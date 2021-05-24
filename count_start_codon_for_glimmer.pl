#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 8-18-2010 developed for a quick way to get the start codon count 
##########################################################################
use strict;
my $usage="$0  list_file \n"; 
die $usage unless @ARGV ==1;
my ($file) = @ARGV;
my %data;
my $total=0;
open (A, "<$file")||die "could not open $file\n";
while (my $a=<A>){
    chomp $a;
    if ($a =~/^>/){
	my $b=<A>;
	my $sCodon=uc(substr($b, 0, 3));
	#print $sCodon, "\n";
	if (defined $data{$sCodon}){
	    $data{$sCodon}++;
	}else{
	    $data{$sCodon}=1;
	}
	$total++;
    }
}
close A;

my %startus;
foreach my $i (sort keys %data){
    
    my $m= sprintf("%.3f",$data{$i}/$total);
    $startus{$i}=$m;
    #print STDERR $i, "\t", $m, "\n";
}

#print join(",", @startus), "\n";
print $startus{"ATG"}, ",", $startus{"GTG"},",",  $startus{"TTG"}, "\n"; 
