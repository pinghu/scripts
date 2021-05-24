#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0 [file] [KO column]first line is title\n"; 
die $usage unless @ARGV ==2;
my ($file, $col) = @ARGV;




open (B, "<$file")||die "could not open $file\n";
my $tt=<B>;
chomp $tt;
for($tt){s/\r//gi;}
my %match;
while (my $a=<B>){
    chomp $a;
    for($a){s/\r//gi;}
    my @tmp=split /\t/, $a;
    if($tmp[$col-1] =~ /ko:(K\d+)/){
	$tmp[$col-1]=$1;
    }
    $match{$tmp[$col-1]}=$a;
}
close B;

open (A, "</media/ping/_media_G6D/db/ko/kegg_tool_2017/pathway_ko.list")||die "could not open $file\n";
my %data;
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    my @tmp=split /\t/, $a;
    open(C , ">$tmp[0].xls")||die "could not open $tmp[0].data\n";
    print C $tt, "\n";
    for(my $i=1; $i<@tmp; $i++){
	$data{$tmp[0]}{$tmp[$i]}=1;
	if(defined $match{$tmp[$i]}){
	    print C $match{$tmp[$i]}, "\n";
	    
	}
    }
    close C;
}
close A;
