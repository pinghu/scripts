#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0 [file] [p][col] first line is title\n"; 
die $usage unless @ARGV >=1;
my ($file, $p, $col) = @ARGV;
if (! defined $p){$p=0.05;}
if (! defined $col){$col=2;}

open (A, "<$file")||die "could not open $file\n";

my $x=<A>;
my $count=0;
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//g;}
    my @tmp=split /\t/, $a;
    my $x=$tmp[$col-1];
    if ($x =~ /(-?\d.\d+)[eE](.\d+)/){
	my ($const, $expon) = ($1, $2);
	my $result = ($const * 10 ** $expon);
	#print STDERR $x, "\t", $result, "\n";
	$x=$result;
    }
    
    if ($x <=$p){
	$count++;
    }
}
print $file, "\tColumn:$col P<=$p\t",$count, "\n"; 
close A;
