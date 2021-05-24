#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
#my $usage="$0  [p][col][file] first line is title\n"; 
#die $usage unless @ARGV ==3;
#my ($p, $col,$file) = @ARGV;
my $KO="";
my $name="";
my $def="";
open (A, "<ko")||die "could not open ko\n";
while (my $a=<A>){
    chomp $a;
   
    if ($a =~ /ENTRY\s+(\S+)/){
	if($KO ne ""){
	    print $KO, "\t", $name, "\t", $def, "\n";
	    $KO=""; $name=""; $def="";
        }
	$KO=$1;
    }elsif($a =~ /NAME\s+(\S+.*)$/){
	$name=$1;
    }elsif($a =~ /DEFINITION\s+(\S+.*)$/){
	$def=$1;
    }

}
close A;
