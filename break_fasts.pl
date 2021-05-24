#!/usr/bin/perl -w
use strict;
my $usage = "usage: $0 <file><tag>\n";
die $usage unless @ARGV == 2;
my ($file, $tag) = @ARGV;
open(IN,"<$file") or die "Cannot open $file to read.\n";
my $start=0;
my $num=0;
while(my $gb =<IN>){
    chomp $gb;
    if ($gb =~ />(\S+)/){
	my $name=$1;
	if ($start == 1){
	    close OUT;
	}else{
	    $start=1;
	}
	open(OUT,">$tag.$name") or die "Cannot open $tag.$name to read.\n";
	$num++;
    }
    print OUT $gb,"\n";
}
close OUT;
close IN;
