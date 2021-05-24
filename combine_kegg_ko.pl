#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;

my (@files) = @ARGV;
my %data;
my %genedata;
my %KEGG;
foreach my $file (@files){

    open (B, "<$file")|| die "could not open $file\n";

    while (my $line =<B>){
	chomp $line;
	my @tmp=split /\t/, $line;
	my $id= $tmp[1];
	my $geneid=$tmp[2];
#	####if too long, you can use the following to shrink id###
#	if ($tmp[2] =~ /^(\S+)\s+/){
#	    $geneid=$1;
#	}
#################################
	$KEGG{$id}=1;
	if (! defined 	$data{$file}{$id}){
	    $data{$file}{$id}=1;
	}else{
	    $data{$file}{$id}++;
	}
	$genedata{$file}{$id}{$geneid}=1;
	
    }
    close B;
	
}
print "KEGG_KO_ID";
foreach my $k(@files){
    print "\tNumber:", $k;
}

foreach my $k(@files){
    print "\tGenes:", $k;
}
print "\n";

foreach my $i (sort keys %KEGG){
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
	foreach my $k (keys %{$genedata{$j}{$i}}){
	    $genes.=$k."#";
	}
	print "\t", $genes;
    }




    print "\n";
} 

