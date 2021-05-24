#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [p][col][file] first line is title\n"; 
die $usage unless @ARGV ==3;
my ($file, $uplist, $downlist) = @ARGV;
my $markerTotal=0;
my %up;
open (A, "<$uplist")||die "could not open $file\n";
while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    $up{$tmp[0]}=1;
    $markerTotal++;
}
close A;

my %down;
open (A, "<$downlist")||die "could not open $file\n";
while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    $down{$tmp[0]}=1;
    $markerTotal++;
}
close A;



open (A, "<$file")||die "could not open $file\n";
my $x=<A>;
chomp $x;
for($x){s/\r//gi;}
my @tt=split /\t/, $x;
print $x, "\n";
my %score;
my $total=0;
while (my $a=<A>){
    chomp $a;
    $total++;
    my @tmp=split /\t/, $a;
    for(my $i=1; $i<@tmp; $i++){
	my $TT=$tmp[$i];
	my $SS=0;
	if ((defined $down{$tmp[0]})&& ($TT<0)){
		$SS++;
	}
	if ((defined $up{$tmp[0]})&& ($TT>0)){
		$SS++;
	}

	if(! defined $score{$i}){
	    $score{$i}=$SS;
	}else{
	    $score{$i} += $SS;
	}
    }
}
close A;
print "SAMEDirection total=$total";
for (my $i=1; $i <@tt; $i++){
    print "\t", $score{$i};
    
}
print "\n";
print "SAMEDirection% MarkerTotal=$markerTotal";
for (my $i=1; $i <@tt; $i++){
    print "\t", int(100*$score{$i}/$markerTotal);
    
}
print "\n";
