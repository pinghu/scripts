#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [pfam_file] first line is title\n"; 
die $usage unless @ARGV ==1;
my ($file) = @ARGV;
my %ann;
open (A, "</media/oem/_media_G6D/db/Pfam/pfam2go")||die "could not open pfam2go\n";

while (my $a=<A>){
    chomp $a;
    if ($a =~ /^!/){
	next;
    }elsif($a =~ /^Pfam\:(\S+)\s+(\S+)\s*>\s*(GO.*)\s*\;\s*(GO\:\d+)/){
	my $id=$1;
	my $syn=$2;
	my $goname=$3;
	my $goid=$4;
	#print $id, "\t", $syn, "\t", $goname,"\t", $goid, "\n";
	$ann{$id}{$goname." ". $goid}=1;
    }
}
close A;

open (B, "<$file")||die "could not open $file\n";
#print "seq_id\talignment_start\talignment_end\tenvelope start\tenvelope end\thmm acc\thmm name\ttype\thmm start\thmm end\thmm length\tbit score\tE-value\tsignificance>\tclan\tGO_name_id\n";
print "seq_id\thmm acc\thmm name\tE-value\tGO_name_id\n";
while (my $a=<B>){
    chomp $a;
    if (($a =~ /^#/)||($a =~ /^\s*$/)){
	next;
    }else{
	my @tmp = split /\s+/, $a;
	my $pid=$tmp[5];
	if($pid=~ /(\S+)\.\d+/){
	    $pid=$1;
	}
	my $E=$tmp[12];
#	print STDERR $pid, "\n";
	my $ann="";
	foreach my $i (keys %{$ann{$pid}}){
	    $ann.=$i.";"
	}
	print $tmp[0], "\t",$tmp[5], "\t", $tmp[6], "\t",$tmp[12] , "\t", $ann, "\n";
    }
}
close B;
