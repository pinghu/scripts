#!/usr/bin/perl -w
###########################################
# need to fix header about the genelink
# Ping Hu
############################################
use strict;
use GD;
my $usage = "usage: $0 <Map_coord_file, list> \n";

die $usage unless @ARGV >= 2;
###list is a data file
my ($kegg_map_file, $list, $StartLine) = @ARGV;
if(! defined $StartLine){
    $StartLine=1;
}
my %mapcat;
open(IN,"</home/ping/db/KEGG/kegg_pathway_structure") or die "Cannot open kegg_pathway_structure to read.\n";
while(my $line =<IN>){
    chomp $line;
    my @tmp=split /\t/, $line;
    $mapcat{$tmp[2]}=$tmp[1];
}
close IN;

my %PPP; ###gene list for mapping
open(IN,"<$list") or die "Cannot open $list to read.\n";
my $PPPTitle="";
for(my $i=0; $i<$StartLine; $i++){
    my $TT=<IN>;
    chomp $TT;
    $PPPTitle.=$TT."\n";
}
while(my $line =<IN>){
    chomp $line;
    for($line){s/\r//gi;}
    my @tmp= split /\t/, $line;
    $PPP{$tmp[0]}=$line;
}
close IN;


############################
#Step 1. get genome mapping
#        
#############################
my %ko2affy;
my %affy2ko;
open(IN,"<$kegg_map_file") or die "Cannot open $kegg_map_file to read.\n";

while(my $line =<IN>){
    chomp $line;
    my @tmp= split /\t/, $line;
    my $kk=$tmp[1];
    if ($tmp[1] =~ /ko:(\S+)/){
	$kk=$1;
    }
    $ko2affy{$kk}{$tmp[0]}=1;
    $affy2ko{$tmp[0]}=$kk;
}
close IN;

#########################################################
#step2 go into all map to create png file and html file
#
#########################################################
my %genes_in_map;
my %MID;
open(IN, "/home/ping/db/KEGG/map_1_10_2012/pathway.list")||die "could not open the map_title.tab\n";
 

while (my $line = <IN>){
   chomp $line;
 
   my @tmp=split /\t/, $line;
   my $mapid=$tmp[0];
 
   my $mapname=$tmp[1];
   my $html_file="/home/ping/db/KEGG/map_1_10_2012_change/map$mapid.html";
  
   if (-e $html_file){
       open (F, $html_file)||die "could not open $html_file\n";
      
       while (my $ff=<F>){
	   if ($ff =~ /www_bget\?(\S+)\"/){
	       my @check=split/\+/, $1;
	       
	       foreach my $i ( @check){
		   for ($i){s/\"//gi};
		   if ($i =~ /&/){
		       my @x=split /\&/, $i;
		       $i=$x[0];
		   }
		   
		   for($i){s/ko\://gi;}
		   #print STDERR "GeneID:\t", $i, "\n";
		   foreach my $j (keys %{$ko2affy{$i}}){
		       #print STDERR "Match $j\n";
		       if (defined $PPP{$j}){
			   $genes_in_map{$mapid}{$j}=1;
			   #print STDERR $mapid, "\t", $j, "\t", $i, "\n";
			   $MID{$mapid}=1;
		       }
		   }
	       }
	   } 
       }

   }
   
}

close IN;

my %cat2gene;
foreach my $i (keys %genes_in_map){
    foreach my $j (keys %{$genes_in_map{$i}}){
	$cat2gene{$mapcat{$i}}{$j}=1;
    }
}

foreach my $i (keys %cat2gene){
    my $nn=$i;
    for($nn){s/\s+//gi;}
    open(B,">tmp.$nn.data\n")||die "could not open tmp.$nn.data\n";
    print B $PPPTitle;
    foreach my $j (keys %{$cat2gene{$i}}){
	print B $PPP{$j}, "\n";	
    }
    close B;
}

