#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### for blastp result
##########################################################################
use strict;
my $usage="$0  [blast_tbl_file][col_for match 8 or 9] \n"; 
die $usage unless @ARGV ==1;
my ($blast_file) = @ARGV;
my $col=2;
my $KEGG_file="/home/ping/db/affy/COG_KOG_KEGG/ko_genes.list";
my %KEGG;
open (A, "<$KEGG_file")||die "could not open $KEGG_file\n";
while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    $KEGG{$tmp[1]}{$tmp[0]}=1;

}
close A;

my %result;
open (A, "<$blast_file")||die "could not open $blast_file\n";
open (B, ">$blast_file.ko")||die "could not open $blast_file.ko\n";
while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    my $check=$tmp[$col-1];
    if ($tmp[$col-1] =~ /lcl\|(\S+)/){
	$check=$1;
    }
    my $gene_id=$tmp[0];
   
    if (! defined $result{$gene_id}){
	if (defined $KEGG{$check}){
	 
	    foreach my $i (keys %{$KEGG{$check}}){
		print B $tmp[0], "\t", $check, "\t", $i,"\t", $a, "\n";
	    }
	     $result{$gene_id}=1;
	 
	}else{
	    print STDERR $check, "\n";
	}
    }
}
close A;
close B;
