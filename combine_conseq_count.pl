#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;

my ($list) = @ARGV;
my %data;
my %genes;
my @files;
open (A, "<$list")|| die "could not open $list\n";
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    push(@files, $a);
    open (C, "<$a")|| die "could not open $a\n";
    while (my $M =<C>){
	chomp $M;
	for($M){s/\r//g;}
	my @tmp=split /\t/, $M;	
	if ($tmp[0] =~/>(\S+)/){
	    $data{$1}{$a}=$tmp[7];
	    $genes{$1}=1;
	}
	
    }
    close C;
}
close A;

print "gene";
for (my $i =0; $i<@files; $i++){
    print "\t",$files[$i], ".match%";
}
print "\n";
foreach my $j (keys %genes){
    print $j;
    for (my $i =0; $i<@files; $i++){
	print "\t";
	if (defined $data{$j}{$files[$i]}){
	    my $xx= $data{$j}{$files[$i]};
	    print $xx;
	}else{
	    print "NA";
	}
    }
    print "\n";
}
