#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### MBS346.merge.fastq.gz	31417827
#### MBS347.merge.fastq.gz	27827945
#### MBS348.merge.fastq.gz	38533917
##########################################################################
use strict;
my $usage="$0  [fastq.gz file list] first line is title\n"; 
die $usage unless @ARGV ==1;
my ($file) = @ARGV;

open (A, "<$file")||die "could not open $file\n";
print "file_name\tfastq_reads_count\n";
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    print $a, "\t";
    system("echo \$(zcat $a |wc -l) /4 |bc\n");
}
close A;
