#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [obofile] first line is title\n"; 
die $usage unless @ARGV ==1;
my ($obofile) = @ARGV;
my $id="";
my $name="";
my $namespace="";
my $def="";
open (A, "<$obofile")||die "could not open $obofile\n";
open (B, ">$obofile.term")||die "could not open $obofile.term\n";
open (C, ">$obofile.edge")||die "could not open $obofile.edge\n";
while (my $a=<A>){
    chomp $a;
   
    if ($a =~ /^[Term]/){
	if($id ne ""){
	    print B $id, "\t", $name, "\t",$namespace, "\t", $def, "\n";
	    $id=""; $name="";$namespace=""; $def="";
        }
    }elsif($a =~ /^id:\s+(\S+.*)$/){
	$id=$1;
    }elsif($a =~ /^name:\s+(\S+.*)$/){
	$name=$1;
    }elsif($a =~ /^namespace:\s+(\S+.*)$/){
	$namespace=$1;
    }elsif($a =~ /^def:\s+(\S+.*)$/){
	$def=$1;
    }elsif($a =~ /is_a:\s+(\S+.*)$/){
	print C $id, "\t",$1, "\n" 
    }
}
if($id ne ""){
    print B $id, "\t", $name, "\t",$namespace, "\t", $def, "\n";
    $id=""; $name="";$namespace=""; $def="";
}
close A;
close B;
close C;
