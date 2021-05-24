#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0 [file] [p][col] first line is title\n"; 
die $usage unless @ARGV >=1;
my ($file, $p, @cols) = @ARGV;
if (! defined $p){$p=0.05;}

open (A, "<$file")||die "could not open $file\n";

my $x=<A>;
chomp $x;
for($x){s/\r//g;}
my @tt=split /\t/, $x;
my %count;
for(my $i=0; $i<@cols; $i++){
    my $col=$cols[$i];
    $count{$col}=0;
}
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//g;}
    my @tmp=split /\t/, $a;
    for(my $i=0; $i<@cols; $i++){
	my $col=$cols[$i];
	my $x=$tmp[$col];
	if ($x =~ /(-?\d.\d+)[eE](.\d+)/){
	    my ($const, $expon) = ($1, $2);
	    my $result = ($const * 10 ** $expon);
	    #print STDERR $x, "\t", $result, "\n";
	    $x=$result;
	}
    
	if ($x <=$p){
	    $count{$col}++;
	}
    }
}

close A;
for(my $i=0; $i<@cols; $i++){
    my $col=$cols[$i];
    print $file, "\tColumn:",$col,"ColName:",$tt[$col],  "; P<=$p\t",$count{$col}, "\n"; 
}
