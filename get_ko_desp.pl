#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [file][ko_id_col] first line is title\n"; 
die $usage unless @ARGV ==2;
my ($file, $col) = @ARGV;
my %ko_ann;

open (A, "</home/ping/db/affy/COG_KOG_KEGG/kegg_ko_gene.ann")||die "could not open kegg_ko_gene.ann\n";

while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    if (defined $tmp[2]){
	$ko_ann{$tmp[0]}=$tmp[1]. "\t". $tmp[2];
    }else{
	$ko_ann{$tmp[0]}=$tmp[1]. "\t";
    }
}
close A;

open (A, "<$file")||die "could not open $file\n";

while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    my $ko_id=$tmp[$col-1];
    if ($tmp[$col-1] =~ /ko\:(\S+)/){
	$ko_id=$1;
    }
    my $des="\t";
    if (defined $ko_ann{$ko_id}){
	$des= $ko_ann{$ko_id};
    }else{
	print STDERR $ko_id, "\n";
    }
    print $a, "\t", $des, "\n";
}
close A;
