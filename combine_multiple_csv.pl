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

for (my $i =0; $i<@files; $i++){
    open (C, "<$files[$i]")|| die "could not open $files[$i]\n";
    my $t=<C>;
    chomp $t;for($t){s/\r//g;}
    my @ss=split /\,/, $t;
    for(my $j=0; $j<@ss; $j++){
	$ss[$j]=$ss[$j];
    }
    $t=join("\,", @ss);
    $title{$files[$i]}=$t;
    while (my $M =<C>){
	chomp $M;
	for($M){s/\r//g;}
	my @tmp=split /\,/, $M;	
	if ($tmp[0] =~/^\s*$/){next;}
	$data{$tmp[0]}{$files[$i]}=$M;
	$genes{$tmp[0]}=1;
    }
    close C;
}

print "gene";
for (my $i =0; $i<@files; $i++){
    print "\,",$title{$files[$i]};
}
print "\n";
foreach my $j (keys %genes){
    print $j;
    for (my $i =0; $i<@files; $i++){
	print "\,";
	if (defined $data{$j}{$files[$i]}){
	    my $xx= $data{$j}{$files[$i]};
	    print $xx;
	    
	}else{
	    my @x=split /\,/,  $title{$files[$i]};
	    for (my $i=0; $i<@x; $i++){
		if ($i == @x-1){
		    print "NA";
		}else{
		    print "NA", "\,";
		}
	    }
	}
    }
    print "\n";
}
