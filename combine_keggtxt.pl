#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;

my ($file, $CUT) = @ARGV;
open (B, "<$file")|| die "could not open $file\n";
my %number;
my %updown;
my @ff;
while (my $line =<B>){
    chomp $line;
    push (@ff, $line);
    open (C, "<$line")|| die "could not open $line\n";

    while (my $M =<C>){
	chomp $M;
	my @tmp=split /\t/, $M;
	if (@tmp<5){next;}
	my $id=$tmp[0];
	my $up=$tmp[5];
	my $down=$tmp[6];
	my $n=$tmp[4];
	$number{$id}{$line}=$n;
        if ($up>$down){
	    $updown{$id}{$line}="UP";
	}elsif($up<$down){
	    $updown{$id}{$line}="DOWN";
	}else{
	    $updown{$id}{$line}="NA";
	}	
    }
    close C;
    
}
close B;

print "KEGGName";
foreach my $j (@ff){
    print "\t",$j
}
print "TotalN\n";

foreach my $i (sort keys %number){
    my $xx=$i;
    my $pp=0;
    foreach my $j (@ff){
	if (defined $number{$i}{$j}){
	    my $x=$number{$i}{$j};
	    my $y=$updown{$i}{$j};
	    $xx.="\t$x:$y";
	    $pp++;
	   
	}else{
	    $xx.="\tNA";
	}
    }
    if ($pp>0){
	print $xx, "\t$pp\n";
    }
}
