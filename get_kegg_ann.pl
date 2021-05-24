#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### for blastp result
##########################################################################
use strict;
my $usage="$0  [blast_tbl_file][col_for match 8 or 9] \n"; 
die $usage unless @ARGV ==2;
my ($blast_file, $col) = @ARGV;
my $KEGG_file="/mnt/disk4/database/kegg_pathway.ko_ann_coord";
my %KEGG;
open (A, "<$KEGG_file")||die "could not open $KEGG_file\n";
while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    my $part=$tmp[0]. "\t". $tmp[1]. "\t". $tmp[2]. "\t". $tmp[3];
    if (defined $tmp[4]){
	if ($tmp[4] =~ /\+/){
	    my @DDD=split /\+/, $tmp[4];
	    foreach my $id (@DDD){
		if ($id =~/^\s*$/){next}else{
		    $KEGG{$id}{$part}=1;
		}
	    }
	}else{
	    $KEGG{$tmp[4]}{$part}=1;
	}
    }elsif(defined $tmp[3]){
	$part=$tmp[0]. "\t". $tmp[1]. "\t".$tmp[2]. "\t";
	if ($tmp[3] =~ /\+/){
	    my @DDD=split /\+/, $tmp[3];
	    foreach my $id (@DDD){
		if ($id =~/^\s*$/){next}else{
		    $KEGG{$id}{$part}=1;
		}
	    }
	}else{
	    $KEGG{$tmp[3]}{$part}=1;
	}
    }else{
	print STDERR $a, "\n";
    }
}
close A;

my %result;
open (A, "<$blast_file")||die "could not open $blast_file\n";
while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    my $check=$tmp[$col-1];
    if ($tmp[$col-1] =~ />(\S+)/){
	$check=$1;
    }
    my $gene_id=$tmp[0];
   
    if (! defined $result{$gene_id}){
	if (defined $KEGG{$check}){
	 
	    foreach my $i (keys %{$KEGG{$check}}){
		print $a, "\t", $i, "\n";
	    }
	     $result{$gene_id}=1;
	 
	}else{
	    print STDERR $check, "\n";
	}
    }
}
close A;
