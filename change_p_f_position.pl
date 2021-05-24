#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [p][col][file] first line is title\n"; 
die $usage unless @ARGV ==1;
my ($file) = @ARGV;
system("cut -f1,3 $file > tt.1\n");
system("cut -f2 $file > tt.2\n");
system("mv $file $file.old\n");
system("paste tt.1 tt.2 > $file\n");
system ("rm tt.*\n");
