#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
use File::Basename;
my (@files) = @ARGV;

my %data;
my %title;
my %genes;

for (my $i =0; $i<@files; $i++){
    open (C, "<$files[$i]")|| die "could not open $files[$i]\n";
    while (my $M =<C>){
	chomp $M;
	if ($M =~/^\s*$/){next;}
	for($M){s/\r//g;}
	if($M =~ /(\S+)\s+(\d+)/){
	    my $count=$2;
	    my $name=$1;
	    $data{$name}{$files[$i]}=$count;
	    $genes{$name}=1;
	}
	
    }
    close C;
}

print "gene\tTaxonLevel\tKingdom\tLastLevelAnn";
for (my $i =0; $i<@files; $i++){
    print "\t",$files[$i];
}
print "\n";
foreach my $j (keys %genes){
    print $j;
    my @tmp=split /\|/, $j;
    my $level=(scalar @tmp);
    print "\t", "Level$level", "\t", $tmp[0], "\t", $tmp[$level-1];
    for (my $i =0; $i<@files; $i++){
	print "\t";
	if (defined $data{$j}{$files[$i]}){
	    my $xx= $data{$j}{$files[$i]};
	    print $xx;
	    
	}else{
	    print "0";
	}
    }
    print "\n";
}
