#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [p][col][file] first line is title\n"; 
#die $usage unless @ARGV ==3;
#my ($p, $col,$file) = @ARGV;
my $file="compound";
open (A, "<$file")||die "could not open $file\n";

my $entry="";
my $name="";

my $cas="";
while (my $a=<A>){
    chomp $a;
    if($a =~ /ENTRY\s+(\S+)/){
	$entry=$1;
    }
    if($a =~ /NAME\s+(\S+)/){
	$name=$1;
	do{
	    $a=<A>;
	    chomp $a;
	    if ($a =~ /^\s+(\S+)/){
		$name.=$1;
	    }else{
	       
	    }
	}while($a =~ /^\s+(\S+)/)
    }
    if($a =~ /CAS\:\s+(\S+)/){
	$cas=$1;
    }
    if($a=~ /\/\/\//){
	print $entry, "\t", $name, "\t", $cas, "\n";
	$entry="";
	$name="";
	$cas="";
    }

}
close A;
