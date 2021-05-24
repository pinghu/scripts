#!/usr/bin/perl -w
use strict;

my $usage="$0 fcSymbol pSymbol stat files\n";
die $usage unless @ARGV >=1;
my ($mapfile, @stats) = @ARGV;

my %data;
foreach my $file(@stats){

    open (X, "<$file")||die "could not open $file\n";
    my $title=<X>;
    chomp $title;
    my @tt=split /\t/, $title;
    while (my $line = <X>){
	chomp $line;
	my @tmp=split /\t/, $line;
	
	for (my $i=1; $i<@tmp; $i++){
	    $data{$tmp[0]}{$tt[$i]}=$tmp[$i];
	    
	}
	
    }
    close X;
}


open (X, "<$mapfile")||die "could not open $mapfile\n";
while (my $line = <X>){
    chomp $line;
    my @tmp=split /\t/, $line;
    my $name=$tmp[0];
    my $fcCol=$tmp[1];
    my $pCol=$tmp[2];
    open (Y, ">$name.stat")||die "could not open $name.stat\n";
    print Y "gene\tFC.$name\tPt.$name\n";
    foreach my $i (keys %data){
	if ($fcCol eq "---"){
	   print Y $i, "\t1\t", $data{$i}{$pCol}, "\n"; 
	}else{
	    print Y $i, "\t", $data{$i}{$fcCol}, "\t", $data{$i}{$pCol}, "\n";
	}
    }
    close Y;
}
close X;
