#!/usr/bin/perl -w
###########################################
# need to fix header about the genelinkmy %gene2name;
#perl ../src/combine_ko_output_to_html.pl list trend.kegg.err Biocheck_kegg_trend >Biocheck_kegg_trend.html
############################################
use strict;
my ($list, $keggfile, $title) = @ARGV;

my %mapcat;
open(IN,"</home/ping/db/KEGG/kegg_pathway_structure") or die "Cannot open kegg_pathway_structure to read.\n";
while(my $line =<IN>){
    chomp $line;
    my @tmp=split /\t/, $line;
    $mapcat{$tmp[2]}="<td>".$tmp[0]. "</td><td>". $tmp[1]."</td>";
}
close IN;

my @files;
open(IN,"<$list") or die "Cannot open $list to read.\n";
while(my $line =<IN>){
    chomp $line;
    push(@files, $line);
}
close IN;

my %goodfile;
my %mapids;
my %data;
my %colors;
my %backcolor;
print "<html><head><script src=\"http://artemis.na.pg.com/sorttable.js\"></script></head><body><h1>$title</h1><table class=\"sortable\" border=1>\n";
system("mkdir $title.sub_kegg");
open(IN,"<$keggfile") or die "Cannot open $keggfile to read.\n";
while(my $line =<IN>){
    chomp $line;
    my @tmp= split /\t/, $line;
    my $mapname=$tmp[2];
    my $compare=$tmp[0];
    my $mapid=$tmp[1];
    my $sigN=$tmp[3];
    my $sigPercent=$tmp[4];
    my $siguppercent=$tmp[5];
    my $sigboxuppercent=$tmp[7];
    my $TotalGeneNumber=$tmp[8];
    my $color="green";
    #if (defined $siguppercent)
    system("mkdir $title.sub_kegg/$compare");
    if(($siguppercent > 50) && ($sigboxuppercent >50)){$color="red";}
    if(($siguppercent < 50) && ($sigboxuppercent <50)){$color="blue";}
    
    $mapids{$mapid}=$mapname;
    
   # if (($sigN>=5)&&($sigPercent>=10)){
   if ($sigN>=1){
	$data{$mapid}{$compare}=$sigN. "</font></a></td><td>".$sigPercent."%</td><td>". $TotalGeneNumber ;

	$colors{$mapid}{$compare}=$color;
	if (($sigN>=5)&&($sigPercent>=10)){
	    $backcolor{$mapid}{$compare}="yellow";
	}
	
	system("cp $compare/new.$mapid.html $title.sub_kegg/$compare/new.$mapid.html\n");
	system("cp $compare/$mapid.new.png $title.sub_kegg/$compare/$mapid.new.png\n");
	$goodfile{"$title.sub_kegg/$compare/new.$mapid.html"}=1;
	$goodfile{"$title.sub_kegg/$compare/$mapid.new.png"}=1;
   }
    
}
close IN;
print "<tr><th>Category_I</th><th>Category_II</th><th>MapID</th><th>MapName</th>";
foreach my $a ( @files){
    print "<th>$a SigProbeNumber</th><th>$a Sig Percent</th><th>$a TotalGeneNumber</a>";
}
print "<th>good_count</th></tr>\n";
foreach my $b (keys %mapids){
    my $count=0;
    my $category=$mapcat{$b};
    my $ppp= "<tr>$category<td>$b</td><td>". $mapids{$b}. "</td>";
    foreach my $a (@files){
	if (defined $data{$b}{$a}){
	    my $cc=$colors{$b}{$a};
	    if (defined $backcolor{$b}{$a}){
	      
		$ppp.= "<td bgcolor=\"yellow\"><a href=\"$title.sub_kegg/$a/new.$b.html\"><font color=$cc>". $data{$b}{$a}. "</td>";
	    }else{
		$ppp.= "<td><a href=\"$title.sub_kegg/$a/new.$b.html\"><font color=$cc>". $data{$b}{$a}. "</td>";
	    }
	    $count++;
	}else{
	    $ppp.= "<td>-</td><td>-</td><td>-</td>";
	}
    }
    if ($count>0){
	print $ppp, "<td>$count</td></tr>\n";
    }
}

print "</table></body></html>\n";

foreach my $a (@files){
     foreach my $b (keys %mapids){
   
	if (! defined $goodfile{"$title.sub_kegg/$a/new.$b.html"}){
	    if (-e "$title.sub_kegg/$a/new.$b.html"){
		system ("rm $title.sub_kegg/$a/new.$b.html\n");
		print STDERR "rm $title.sub_kegg/$a/new.$b.html\n";
	    }
	}	
	if (! defined $goodfile{"$title.sub_kegg/$a/$b.new.png"}){
	    if (-e "$title.sub_kegg/$a/$b.new.png"){
		system ("rm $title.sub_kegg/$a/$b.new.png\n");
		print STDERR "rm $title.sub_kegg/$a/$b.new.png\n"
	    }
	}
    }
}

