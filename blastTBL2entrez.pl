#!/usr/bin/perl -w
use strict;
my $usage = "usage: $0 <blast file> <col of matching  accession> \n";

die $usage unless @ARGV == 2;
my ($blast_file, $col) = @ARGV;
my %check;
open(BLAST, $blast_file) or die "Could not open $blast_file\n";
while (my $line =<BLAST>){
    chomp $line;
    my @tmp =split /\t/, $line;
    my $mm=$tmp[$col-1];
    my @cc=split /\|/, $mm;
    if (defined $cc[1]){
	$mm=$cc[1];	
    }
   #print STDERR $mm, "\t HHHH \n";
    $check{$mm}=1;
}
close BLAST;

my %id;
my %ezcheck;
open(IN,"</home/ping/db/Entrez/gene2accession") or die "Cannot open gene2accession to read.\n";
my $ttmp=<IN>;
while(my $line =<IN>){
    chomp $line;
    
    my @tmp= split /\t/, $line;
    
    if ($tmp[4] ne "-"){
	if (defined $check{$tmp[4]}){
	     #print STDERR $tmp[4], "\t4NUC\t", $tmp[1], "\n"; 
	    $id{$tmp[4]}{$tmp[0]."\t".$tmp[1]}="NUC";
	    $ezcheck{$tmp[0]."\t".$tmp[1]}=1;
	}
    }
    if ($tmp[6] ne "-"){	
	if (defined $check{$tmp[6]}){
	    # print STDERR $tmp[6], "\t6PROTEIN\t", $tmp[1], "\n"; 
	    $id{$tmp[6]}{$tmp[0]."\t".$tmp[1]}="PROTEIN"; 
	    $ezcheck{$tmp[0]."\t".$tmp[1]}=1;
	}
    }
   
    if ($tmp[3] ne "-"){
	if (defined $check{$tmp[3]}){
	    #print STDERR $tmp[3], "\t3NUC\t", $tmp[1], "\n"; 
	    $id{$tmp[3]}{$tmp[0]."\t".$tmp[1]}="NUC"; 
	    $ezcheck{$tmp[0]."\t".$tmp[1]}=1;
	}
    }
    if ($tmp[5] ne "-"){
	if (defined $check{$tmp[5]}){
	    #print STDERR $tmp[5], "\t5PROTEIN\t", $tmp[1], "\n";
	    $id{$tmp[5]}{$tmp[0]."\t".$tmp[1]}="PROTEIN";
	    $ezcheck{$tmp[0]."\t".$tmp[1]}=1;
	}
    }
=pod
    if ($tmp[7] ne "-"){
	if (defined $check{$tmp[7]}){
	    $id{$tmp[7]}{$tmp[0]."\t".$tmp[1]}="GENOME"; 
	    $ezcheck{$tmp[0]."\t".$tmp[1]}=1;
	}
    }
     if ($tmp[8] ne "-"){
	if (defined $check{$tmp[8]}){
	    $id{$tmp[8]}{$tmp[0]."\t".$tmp[1]}="GENOME";
	     $ezcheck{$tmp[0]."\t".$tmp[1]}=1;
	}
    }    
=cut
}
close IN;

my %entrez;

open(IN,"</home/ping/db/Entrez/gene2go") or die "Cannot open gene2go to read.\n";
my $xttm=<IN>;
while(my $line =<IN>){
    chomp $line;
    my @tmp= split /\t/, $line;
    if (@tmp <3){next;}
    if (! defined $ezcheck{$tmp[0]."\t".$tmp[1]}){next;}
    if (! defined $entrez{$tmp[0]."\t".$tmp[1]}){
	$entrez{$tmp[0]."\t".$tmp[1]}=$tmp[2];
    }else{
	$entrez{$tmp[0]."\t".$tmp[1]}.=" ".$tmp[2];
    }
}
close IN;

my %ez_info;
open(IN,"</home/ping/db/Entrez/gene_info") or die "Cannot open gene_info to read.\n";
my $ttm=<IN>;
while(my $line =<IN>){
    chomp $line;
    my @tmp= split /\t/, $line;
    if (@tmp <3){next;}
    if (! defined $ezcheck{$tmp[0]."\t".$tmp[1]}){next;}
    else{
	$ez_info{$tmp[0]."\t".$tmp[1]}=$tmp[2]."\t".$tmp[8];
    }
}
close IN;






open(BLAST, $blast_file) or die "Could not open $blast_file\n";
while (my $line =<BLAST>){
    chomp $line;
    my @tmp =split /\t/, $line;
    my $name=$tmp[0];
    my $mm=$tmp[$col-1];
   

    my @cc=split /\|/, $mm;
    if (defined $cc[1]){
	$mm=$cc[1];
       # print STDERR $mm, "\n";
    }
    foreach my $ez(keys %{$id{$mm}}){  	
	my $type=$id{$mm}{$ez};
	my $go="";
	if (defined $entrez{$ez}){
	    $go=$entrez{$ez};
	   
	}
	my $info="\t";
	if (defined $ez_info{$ez}){
	    $info=$ez_info{$ez};
	   
	}	
	print $line, "\t", $type, "\t", $ez, "\t",$info, "\t",  $go, "\n";
	print STDERR $ez, "\t", $info, "\t", $go, "\n";
    }
      
  
}
close BLAST;
