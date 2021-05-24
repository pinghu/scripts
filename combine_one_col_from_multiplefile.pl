#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### perl combine_one_col_from_multiplefile.pl 13 select.list >BC3.AB.select.xls
##########################################################################
use strict;
my $usage="$0  <col> <filelist> \n"; 
die $usage unless @ARGV >=2;
my ($col, $filelist) = @ARGV;
my %data;
my %gid;
my %fid;
open (A, "<$filelist")||die "could not open $filelist\n";
while (my $a=<A>){
    chomp $a;
    open (B, "<$a")||die "could not open $a\n";
    while (my $b=<B>){
	chomp $b;
	for($b){s/\r//gi;}
	my @tmp=split /\t/, $b;	
	
	$data{$tmp[0]}{$a}=$tmp[$col-1];
	$gid{$tmp[0]}=1;
	$fid{$a}=1;
    }
    close B;
}
close A;
print "probe";
foreach my $ff(sort keys %fid){
    print "\t", $ff;
}
print "\tSUM\tDirectionSum\tTotalCount\tMaxAbsoluteValue\n";

foreach my $i (keys %gid){
    print $i;	
    my $sum=0;
    my $dsum=0;
    my $absum=0;
    my $maxabs=0;
    foreach my $ff(sort keys %fid){

	if(defined $data{$i}{$ff}){
	    print "\t", $data{$i}{$ff};
	    $sum+=$data{$i}{$ff};
	    if(abs($data{$i}{$ff})> $maxabs){
		$maxabs=abs($data{$i}{$ff});
	    }
	    if ($data{$i}{$ff}>0){
		$dsum++;
		$absum++;
	    } elsif ($data{$i}{$ff}<0){
		$dsum--;
		$absum++;
	    }
	}else{
	    print "\tNA";
	}
    }
    print "\t", $sum, "\t", $dsum,"\t", $absum,"\t", $maxabs, "\n";

}
