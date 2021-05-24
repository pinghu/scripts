#!/usr/bin/perl -w
use strict;
my $usage = "usage: $0 <fastafile> <fastaid> <seqfile>\n";
#default score 0.8#
die $usage unless @ARGV == 3;
my ($rdpfile, $CUT,, $seqfile) = @ARGV;
my %map;
open(BLAST, $seqfile) or die "Could not open $rdpfile\n";
while (my $line =<BLAST>){
    chomp $line;
    my $x="";
    my $y="";
    if ($line=~/>(\S+)/){
	$x=$1;
	$y=$line;
	for ($y){s/\>//gi;}
	$map{$x}=$y;
    }
}
close BLAST;
open(BLAST, $rdpfile) or die "Could not open $rdpfile\n";
while (my $line =<BLAST>){
    chomp $line;
    for ($line){s/\"//gi;}
    my @tmp=split /\t/, $line;
    my $name=$tmp[0];
    my $SS=0;
    print $map{$tmp[0]}, "\tRoot;";
    for (my $i=5; $i<@tmp; $i=$i+3){
	my $name=$tmp[$i];
	my $type=$tmp[$i+1];
	my $score=$tmp[$i+2];
	if ($score >=$CUT){
	    $SS=$score;
	    if ($type eq "domain"){
		print "k_",$name,";";
	    }elsif($type eq "phylum"){
		print "p_",$name,";";
	    }elsif($type eq "class"){
		print "c_",$name,";";
	    }elsif($type eq "order"){
		print "o_",$name,";";
	    }elsif($type eq "genus"){
		print "g_",$name,";";
	    }

	}
    }
    print "\t", $SS, "\n";
  #  my $k=$tmp[5];
  #  my $k_score=$tmp[7];
  #  my $p=$tmp[8];
  #  my $p_score=$tmp[10];
  #  my $c=$tmp[11];
  #  my $c_score=$tmp[13];
  #  my $o=$tmp[14];
  #  my $o_score=$tmp[16];
  #  my $g=$tmp[17];
  #  my $g_score=$tmp[19];    
}
close BLAST;

