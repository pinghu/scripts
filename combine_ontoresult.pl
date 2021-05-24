#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;

my ($file) = @ARGV;
open (B, "<$file")|| die "could not open $file\n";
my %number;
my %score;
my %GENE;
my %good;
my @ff;
my $CUT=0.05;
while (my $line =<B>){
    chomp $line;
    push (@ff, $line);
    open (C, "<$line")|| die "could not open $line\n";
########we can use this to creat a gene page then I do not need to maintain the overall heatmap page, but just create one using the raw result file#####################   
    my $statfile=$line;
    if ($line=~/(\S+)\_p05.result/){
	$statfile=$1;
    }
    print STDERR "../stat/$statfile\n";
##################################################
    while (my $M =<C>){
	chomp $M;
	my @tmp=split /\t/, $M;
	if (@tmp<5){next;}
	my $id=$tmp[0]."\t".$tmp[5];
	my $p=$tmp[4];
	my $n=$tmp[1];
	my @genes=split /\#/, $tmp[6];
	if ($p<= $CUT){
	    if (!defined $good{$id}){
		$good{$id}=1;
	    }else{
		$good{$id}++;
	    }
	}
	    $score{$id}{$line}=$p;
	    $number{$id}{$line}=$n;
	    foreach my $i (@genes){
		$GENE{$id}{$i}=1;
	    }
	
    }
    close C;
    
}
close B;

print "CombineName\tGO\tGO_Name\tGOOD_FILE_NUMBER\tTOTAL_GENE_NUMBER";
foreach my $j (@ff){
    print "\tPvalue $j\tGeneNum $j\tLog10(p) $j";
}
print "\tGENES_NAME\n";

foreach my $i (sort keys %good){
    my $good_number=0;
    if (defined $good{$i}){
	$good_number=$good{$i};
    }
    
    my $gn=0;
    my $gstring="";
    foreach my $gg(keys %{$GENE{$i}}){
	$gn++;
	$gstring.=$gg."#";
    }
    my $com=$i;
    for($com){s/\tnull//gi; s/\t/ /gi;}
    print $com, "\t", $i, "\t", $good_number, "\t", $gn;
    
    foreach my $j (@ff){
	my $SCORE=1;
	my $NNN=0;
	if ((defined $score{$i}{$j})&&($score{$i}{$j}<=$CUT)){
	    $SCORE=$score{$i}{$j};
	    $NNN=$number{$i}{$j};
	}
	print "\t", $SCORE, "\t", $NNN, "\t", log10($SCORE);
    }
    print "\t", $gstring, "\n";
}

sub log10 {
my $n = shift;
return log($n)/log(10);
}
