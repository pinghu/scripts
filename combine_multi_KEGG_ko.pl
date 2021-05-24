#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;

my ($filelist) = @ARGV;
my $col=3;
my %data;
my %COG;
my %COG_gene;
my @files;
open (A, "<$filelist")||die "could not open $filelist\n";
while (my $a=<A>){
    chomp $a;
    push (@files, $a);
}
close A;


foreach my $file (@files){

    open (B, "<$file")|| die "could not open $file\n";

    while (my $line =<B>){
	chomp $line;
	my @tmp=split /\t/, $line;
	$COG{$tmp[$col-1]}=1;
	if (! defined 	$data{$file}{$tmp[$col-1]}){
	    $data{$file}{$tmp[$col-1]}=1;
	}else{
	    $data{$file}{$tmp[$col-1]}++;
	}
	$COG_gene{$file}{$tmp[$col-1]}{$tmp[0]}=1;
	
    }
    close B;
	
}
print "COG";
foreach my $k(@files){
    print "\t counts", $k;
}
foreach my $k(@files){
    print "\t genes ", $k;
}

print "\n";

foreach my $i (sort keys %COG){
    print $i;
    foreach my $j (@files){
	if (defined $data{$j}{$i}){
	    print "\t",  $data{$j}{$i};
	}else{
	    print "\t0";
	}
    }
   
    foreach my $j (@files){
	 my $genes="";
	foreach my $k (sort keys %{$COG_gene{$j}{$i}}){
	    $genes.=$k."#";
	}
	print "\t$genes";
    }
    print "\n";
} 

