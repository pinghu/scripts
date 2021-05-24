#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### perl combine_one_col_from_multiplefile.pl 13 select.list >BC3.AB.select.xls
##########################################################################
use strict;
my $usage="$0  col4,5,6,7 <filelist> \n"; 
die $usage unless @ARGV ==1;
my ( $filelist) = @ARGV;
my %data;
my %gid;
my %fid;
open (A, "<$filelist")||die "could not open $filelist\n";
while (my $a=<A>){
    chomp $a;
    $fid{$a}=1;
    open (B, "<$a")||die "could not open $a\n";
    while (my $b=<B>){
	chomp $b;
	for($b){s/\r//gi;}
	my @tmp=split /\t/, $b;
        if(defined $tmp[6]){
          my $ann=$tmp[6]."\t".$tmp[5]."\t".$tmp[4]."\t".$tmp[3];	
	  if(! defined $data{$a}{$ann}){
	    $data{$a}{$ann}=1;
          }else{
	    $data{$a}{$ann}++;
          }	
	  $gid{$ann}=1;
        }
    }
    close B;
}
close A;
print "Line\tSymbol\tCOG\tEC\tGeneName";
foreach my $ff(sort keys %fid){
    print "\t", $ff;
}
print "\n";
my $count=0;
foreach my $i (keys %gid){
    $count++;
    print $count, "\t", $i;	
    foreach my $ff(sort keys %fid){
	if(defined $data{$ff}{$i}){
	    print "\t", $data{$ff}{$i};
	}else{	    
	    print "\t0";
	}
    }
    print "\n";

}
