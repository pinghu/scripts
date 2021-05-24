#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;

my (@files) = @ARGV;

my %data;
my %title;
my %genes;

    open (C, "<$files[0]")|| die "could not open $files[0]\n";
    my $t=<C>;
    chomp $t;for($t){s/\r//g;}
    my @ss=split /\t/, $t;
    for(my $j=0; $j<@ss; $j++){
	$ss[$j]=$ss[$j];
    }
    $t=join("\t", @ss);
    $title{$files[0]}=$t;
    while (my $M =<C>){
	chomp $M;
	for($M){s/\r//g;}
	my @tmp=split /\t/, $M;	
	if ($tmp[0] =~/^\s*$/){next;}
	$data{lc($tmp[0])}{$files[0]}=$M;
	$genes{lc($tmp[0])}=$tmp[0];
    }
    close C;

for (my $i =1; $i<@files; $i++){
    open (C, "<$files[$i]")|| die "could not open $files[$i]\n";
    my $t=<C>;
    chomp $t;for($t){s/\r//g;}
    my @ss=split /\t/, $t;
    for(my $j=0; $j<@ss; $j++){
	$ss[$j]=$ss[$j];
    }
    $t=join("\t", @ss);
    $title{$files[$i]}=$t;
    while (my $M =<C>){
	chomp $M;
	for($M){s/\r//g;}
	my @tmp=split /\t/, $M;	
	if ($tmp[0] =~/^\s*$/){next;}
	if(defined $data{lc($tmp[0])}){
	    $data{lc($tmp[0])}{$files[$i]}=$M;
	}
    }
    close C;
}

print "gene";
for (my $i =0; $i<@files; $i++){
    print "\t",$title{$files[$i]};
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
