#!/usr/bin/perl -w
use strict;
my $usage = "usage: $0 <file><tag>\n";
die $usage unless @ARGV == 2;
my ($file, $tag) = @ARGV;
open(IN,"<$file") or die "Cannot open $file to read.\n";
my %data;
while(my $gb =<IN>){
    chomp $gb;
    my @tmp=split /\t/, $gb;
    $data{$tmp[0]}{$tmp[8]}=$gb;
}

close IN;

foreach my $i (sort keys %data){
    open(OUT,">$tag.$i.gff") or die "Cannot open $tag.$i.gff to read.\n";
    foreach my $j (sort keys %{$data{$i}}){
	print OUT $data{$i}{$j}, "\n"; 
    }
    close OUT;
}
