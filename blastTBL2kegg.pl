#!/usr/bin/perl -w
use strict;
my $usage = "usage: $0 <blast file> \n";

die $usage unless @ARGV == 1;
my ($blast_file) = @ARGV;
my %check;
open(BLAST, $blast_file) or die "Could not open $blast_file\n";
while (my $line =<BLAST>){
    chomp $line;
    my @tmp =split /\t/, $line;
    my $mm=$tmp[1];
    
    $check{$mm}=1;
}
close BLAST;

my %gene2kegg;
my %kegg2path;

open(IN,"</home/ping/db/KEGG/Kegg_gene_cpd_path.list") or die "Cannot open Kegg_gene_cpd_path.list to read.\n";
while(my $line =<IN>){
    chomp $line;
    my @tmp= split /\t/, $line;
    if (defined $check{$tmp[1]}){
       $gene2kegg{$tmp[1]}{$tmp[2]}=1;
       my $pp=$tmp[0];
       if ($pp =~ /path\:\S\S\S(\d+)/){
       	$pp="path:$1";
       }
       $kegg2path{$tmp[2]}{$pp}=1;
    }

}
close IN;



open(BLAST, $blast_file) or die "Could not open $blast_file\n";
while (my $line =<BLAST>){
    chomp $line;
    my @tmp =split /\t/, $line;
    my $name=$tmp[0];
    my $mm=$tmp[1];
    my $gg="";
    my %pp;
    foreach my $i(keys %{$gene2kegg{$mm}}){
    	$gg.=$i.";";
    	foreach my $k (keys %{$kegg2path{$i}}){
    		$pp{$k}=1;
    	}
    }
    my $xx="";
    foreach my $i (keys %pp){
    	$xx.=$i.";";
    }
    print $line, "\t", $gg,"\t", $xx, "\n";
}
close BLAST;
