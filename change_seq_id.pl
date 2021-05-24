#!/usr/bin/perl -w
use strict;
my $usage = "usage: $0 <fastafile> <fastaid>\n";
###########################################################
#sudo perl change_seq_id.pl pynast_aligned_seqs/otu_merge_aligned_pfiltered.fasta merge_otus.mapping 
#############################################################
die $usage unless @ARGV == 2;
my ($seqfile, $idfile) = @ARGV;
my %id;
open(BLAST, $idfile) or die "Could not open $idfile\n";
while (my $line =<BLAST>){
    chomp $line;
    my @tmp=split /\t/, $line;
    for ($tmp[1]){s/Root;//gi;}
    $id{$tmp[0]}=$tmp[1];
}
close BLAST;

open(BLAST, $seqfile) or die "Could not open $seqfile\n";
while (my $line =<BLAST>){
    chomp $line;
    if ($line=~/>(\S+)/){
	my $iid=$1;
	if (defined $id{$iid}){
	    my $nnn=$id{$iid};
	    print ">$nnn $iid", "\n";
	    my $ff=<BLAST>;
	    print $ff;
	}else{
	    print STDERR "could not find $iid\n";
	    print "$line\n";
	    my $ff=<BLAST>;
	    print $ff;
	}
    }
    
}
close BLAST;


