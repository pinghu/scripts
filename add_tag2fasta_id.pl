#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  <file>  <seq_length>\n"; 
die $usage unless @ARGV == 2;
my ($file, $tag) = @ARGV;
my $name="";
my $seq="";
my $count=0;
open (A, "<$file")||die "could not open $file\n";
while (my $a=<A>){
    chomp $a;
    
    if ($a =~ /\>(\S+.+$)/){
      if($count>0){
	print ">",$tag,".",$name, "\n", $seq, "\n";
	print STDERR length($seq), "\t",$tag, ".",  $name,"\n";
      }
	$name=$1;
	$seq="";
        $count++;
    }else{
	$seq.=$a;
    }
    
}
close A;

print ">", $tag, ".", $name, "\n", $seq, "\n";
print STDERR length($seq), "\t",$tag, ".",  $name,"\n";

