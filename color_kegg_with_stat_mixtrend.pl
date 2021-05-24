#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
####July-28-2011 example below
####cut -f10  burk.glimmer.pep.kegg |cut -f2 -d"?" >burk.glimmer.id
####perl generate_kegg_xml.pl burk.glimmer.id burk.glimmer
####red #FF0000 Blue #0000FF Green #008000 Purple #800080
##########################################################################
use strict;
my $usage="$0  [statfile][annfile][outputname][p_cutoff] first line is title\n"; 
die $usage unless @ARGV >=3;
my ($file,$annfile, $outputname, $p_cut) = @ARGV;
if (! defined $p_cut){
    $p_cut=0.05;
}
my %ann;
my %ko2affy;
open (A, "<$annfile")||die "could not open $annfile\n";
while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    $ann{$tmp[0]}=$tmp[1];
    if (defined $tmp[3]){
	$ko2affy{$tmp[1]}{$tmp[0]}=$tmp[2]."\t". $tmp[3];
    }elsif(defined $tmp[2]){
	$ko2affy{$tmp[1]}{$tmp[0]}=$tmp[2]."\t";	
    }else{
	$ko2affy{$tmp[1]}{$tmp[0]}="\t";
    }
}
close A;

my %KO_p;
my %KO_f;
my %id;
my %stat;
my %bad_ko;
open (A, "<$file")||die "could not open $file\n";
while (my $a=<A>){
    chomp $a;
    my @tmp=split /\t/, $a;
    if (defined $ann{$tmp[0]}){
	my $koid= $ann{$tmp[0]};
	 if ($ann{$tmp[0]} =~ /ko\:(\S+)/){
	     $koid=$1;
	 }
	$stat{$tmp[0]}=$tmp[1]."\t". $tmp[2];
	my $p=$tmp[1];
	my $f=$tmp[2];
	if ($p> $p_cut){next;}
	if (! defined $id{$koid}){
	    $KO_p{$koid}=$p;
	    $KO_f{$koid}=$f;
	    if ($f >=1){
		$id{$koid} ="#FF0000"; #red
	    }else{
		$id{$koid} ="#0000FF";	#blue
	    }
	}else{
	    $KO_p{$koid}=$p;
	    $KO_f{$koid}=$f;
	    if (($f >1)&&($id{$koid} ne "#FF0000")){
		#$id{$koid} ="#FF0000"; #red
		$id{$koid} ="#00FF00"; #green
		$bad_ko{$koid}=1; 
	    }elsif (($f<1)&&($id{$koid} ne "#0000FF")){
		#$id{$koid} ="#0000FF";	#blue
		$id{$koid} ="#00FF00"; #green
		$bad_ko{$koid}=1; 
	    }
	}
    }
}
close A;

generate_graph("map01100.xml");
generate_graph("map01110.xml");
generate_graph("map01120.xml");
open (D, ">$outputname.badmap\n")||die "could not open $outputname.badmap\n";
#foreach my $a (keys %ko2affy){
foreach my $a (keys %bad_ko){
    foreach my $b (keys %{$ko2affy{$a}}){
	if (defined $stat{$b}){
	    print D $a, "\t", $b, "\t", $stat{$b}, "\t", $ko2affy{$a}{$b}, "\n";
	}else{
	    print STDERR "stat of $b is not available\n";
	}
    }
    
}
close D;





sub generate_graph{
    my ($mapid)=@_;
    open (B, "</mnt/disk4/blast_result/check_kegg/original_xml/$mapid")||die "could not open $mapid\n";
    open (C, ">$outputname.$mapid\n")||die "could not open $outputname.$mapid\n";
    my $keggid="";
    my $color_code="#808080"; ##this is yellow har to see##
    while (my $x=<B>){
	chomp $x;
	if ($x =~ /entry id/){
	    print C $x, "\n";
	    
	    if ($x=~/keggid=\"(\S+)\"/){
		$keggid=$1;
		
	    }
	    $color_code="#FFFF00";
	    for($keggid ){s/ko\://gi;}
	    #print STDERR $keggid, "\n";
	    if ($keggid =~ /\+/){
		my @tmp=split /\+/, $keggid;
		my %colors;
		foreach my $i (@tmp){
		    if (defined $id{$i}){
			$colors{$id{$i}}=1;
			$color_code=$id{$i};
		    }
		}
		my $count=keys %colors;
		if ($count >1){
		    $color_code="#00FF00";
		    print STDERR $x, "\n";
		}
	    }else{
		if (defined $id{$keggid}){
		    $color_code= $id{$keggid};
		} 
	    }
	    
	    
	    
	}elsif ($x =~ /path fill/){
	    
	
	    if ($x =~ /(^.+stroke=\")\S+(\".+$)/){
		my $front=$1;
		my $back=$2;
		# print STDERR $front, "##########", $back, "\n";
		print C $front, $color_code, $back, "\n";
	    }	
	    
	}else{
	    print C $x, "\n";
	}
    }
    close B;
    close C;
    return 0;
}
