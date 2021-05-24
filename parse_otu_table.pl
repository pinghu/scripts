#!/usr/bin/perl -w
use strict;
my $usage = "usage: $0 <ann file> \n";

#die $usage unless @ARGV == 1;
#my ($file) = @ARGV;
my %otu;
my %cat;
open(BLAST, "<merge_otus.txt") or die "Could not open seqs_otus.txt\n";
while (my $line =<BLAST>){
    chomp $line;
    my @tmp =split /\t/, $line;
    for(my $i=1; $i<@tmp; $i++){
	my $bbid=0;
	my $siteid="NA";
	if ($tmp[$i] =~ /Baby(\d+)\.(\S+)\_\d+/){
	    $bbid="BB".$1;
	    $siteid=$2;
	    my $aid=$siteid.".BB".$bbid;
	    $cat{$bbid}=1;
	    $cat{$siteid}=1;
	     $cat{$aid}=1;
	    if (! defined $otu{$tmp[0]}{$bbid}){
		$otu{$tmp[0]}{$bbid}=1;
	    }else{
		$otu{$tmp[0]}{$bbid}++;
	    }

	    if (! defined $otu{$tmp[0]}{$siteid}){
		$otu{$tmp[0]}{$siteid}=1;
	    }else{
		$otu{$tmp[0]}{$siteid}++;
	    }

	    if (! defined $otu{$tmp[0]}{$aid}){
		$otu{$tmp[0]}{$aid}=1;
	    }else{
		$otu{$tmp[0]}{$aid}++;
	    }

	}elsif($tmp[$i] =~ /(Control\d+)\./) {
	    my $cid=$1;
	    $cat{$cid}=1;
	    if (! defined $otu{$tmp[0]}{$cid}){
		$otu{$tmp[0]}{$cid}=1;
	    }else{
		$otu{$tmp[0]}{$cid}++;
	    }

	}else{
	    print STDERR $tmp[0], "\t$i\t", $tmp[$i], "\n";
	}
    }
}
close BLAST;
my %map;
open(BLAST, "<otu_merge.tax") or die "Could not open otu_merge.tax\n";
while (my $line =<BLAST>){
    chomp $line;
    my @tmp =split /\t/, $line;
    my $id=0;
    if ($tmp[0] =~/^(\d+)/){
	$id=$1;
    }
    $map{$id}=$tmp[1];
}
close BLAST;
print "otu_id\ttaxon";
foreach my $j (sort keys %cat){
    print "\t", $j;
    print STDERR $j, "\n";
}
print "\n";
foreach my $otuid (keys %otu){
    print $otuid, "\t";
    my $taxon="";
    if (defined $map{$otuid}){
	print $map{$otuid};
    }
    foreach my $j (sort keys %cat){
	if (defined $otu{$otuid}{$j}){
	    print "\t", $otu{$otuid}{$j};
	}else{
	    print "\t0"; 
	}
    }
    print "\n";
}
