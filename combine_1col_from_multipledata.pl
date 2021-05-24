#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;

my ($list, $COL) = @ARGV;

my $RCOL=$COL-1;
open (A, "<$list")|| die "could not open $list\n";
my @files;
while (my $x =<A>){
    chomp $x;
    push (@files, $x);
}
close A;

my %data;
my %title;
my %genes;

for (my $i =0; $i<@files; $i++){
    open (C, "<$files[$i]")|| die "could not open $files[$i]\n";
    my $t=<C>;
    chomp $t;
    my @ss=split /\t/, $t;
    $title{$files[$i]}=$ss[$RCOL];
    while (my $M =<C>){
	chomp $M;
	my @tmp=split /\t/, $M;
	$data{$tmp[0]}{$files[$i]}=$tmp[$RCOL];
	$genes{$tmp[0]}=1;
    }
    close C;
}

print "gene";
for (my $i =0; $i<@files; $i++){
    print "\t",$files[$i], ".", $title{$files[$i]};
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
	    my @x=split /\t/,  $title{$files[$i]};
	    for (my $i=0; $i<@x; $i++){
		if ($i == @x-1){
		    print "NA";
		}else{
		    print "NA", "\t";
		}
	    }
	}
    }
    print "\n";
}
