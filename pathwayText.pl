#! /usr/bin/perl -w

use strict;

my $usage = "$0 stat_file acr_file PCUT FCUT \n";
die $usage unless @ARGV == 4;
my ($statfile, $acr_file,$PCUT, $FCUT ) = @ARGV;


my $outname= $statfile;
if ($statfile =~  /([^\/]+)\s*$/ ){
    $outname=$1;
}
if ($outname =~/(\S+)\.stat/){
    $outname=$1;
}
#####################
# constant
####################
my $pathfile="/home/ping/db/pathway/data/pathway-mammal-nonKEGG.list";
#######################
# step 1. Load data
#######################
my (%FFF, %PPP);
fill_stat(\%PPP, \%FFF, $statfile);  
my %acr; #from affy to acronym
fill_hash(\%acr, $acr_file);

my %gene; #from acronym to affy id
foreach my $aff (keys %acr){
    my $aa=$acr{$aff};
    #print STDERR $aa, "*****", $acr{$aff}, "\n";
    if (! defined $gene{$aa}){ 
	$gene{$aa}=$aff;            
    }else{
	$gene{$aa}.="\t".$aff; 
    }
}

my %list_gene; #genes in the data set acr->aff
foreach my $aff(keys %PPP){
    if (defined $acr{$aff}){
	$list_gene{$acr{$aff}}=$aff;
    }
}
my %path;
my %path_name;
my %path_n;
my %chip_n;
my %data_n;
my %path_gene;
my %path_link;
my %path_genelink;
open(IN,"<$pathfile") or die "Couldn't open  $pathfile";
while(my $in = <IN>){
    chomp $in; 
    my @tmp=split /\t/, $in;
    $tmp[3]=lc($tmp[3]);
  
    if (scalar @tmp <6){next;}
    $path_name{$tmp[0]}=$tmp[1];
    $path_gene{$tmp[0]}{$tmp[3]}=$tmp[4];
    $path_link{$tmp[0]}=$tmp[5];
    $path_genelink{$tmp[0]}{$tmp[3]}=$tmp[7];
    if (! defined $path_n{$tmp[0]}){
	$path_n{$tmp[0]}=1;
    }else{
	$path_n{$tmp[0]}++;
    }
    if (defined $gene{$tmp[3]}){
	print STDERR $tmp[3], "\t", $gene{$tmp[3]}, "\n";
	if (! defined $chip_n{$tmp[0]}){
               $chip_n{$tmp[0]}=1;
        }else{
               $chip_n{$tmp[0]}++;
        }
    }
    if (defined $list_gene{$tmp[3]}){
        $path{$tmp[0]}{$tmp[3]}=$list_gene{$tmp[3]};
        if (! defined $data_n{$tmp[0]}){
               $data_n{$tmp[0]}=1;
        }else{
               $data_n{$tmp[0]}++;
        }
    }
}
close IN;

#######################
# step 2 print html files
######################
my $outfile="$outname.pathtxt";

open (B, ">$outfile")or die "could not open $outfile\n ";


my %part; #sort 
foreach my $pp(keys %path){
    my $pname=$path_name{$pp};
    my $header2= $pp."\t".$path_name{$pp}."\n";
    my $N2=$chip_n{$pp};
    my $N3=$data_n{$pp};
    if ($N3<5){next;}
    my $N4=0;
    my $up=0;
    my $down=0;
    my $sigup=0;
    my $sigdown=0;
    foreach my $gg (keys %{$path{$pp}}){
	my @ll=split "\t", $path{$pp}{$gg};
	my $c=0;
	my $gup=0;
	my $gdown=0;
	my $siggup=0;
	my $siggdown=0;
	foreach my $probe (@ll){
	    if (defined $FFF{$probe}){
		for ($PPP{$probe}){
		    s/\</0/gi;
		}
		if ($PPP{$probe}<=$PCUT){
		    $c=1;
		    if ($FFF{$probe}>$FCUT){$siggup++;}
		    elsif($FFF{$probe}<$FCUT){$siggdown++;}
		}
		if ($FFF{$probe}>$FCUT){$gup++;}
		elsif($FFF{$probe}<$FCUT){$gdown++;}
	    }elsif (defined $PPP{$probe}){
		if ($PPP{$probe}<=$PCUT){$c=1;}
	    }
	}
	$N4+=$c;
	if ($gup>0){$up++;}
	if ($gdown>0){$down++;}	
	if ($siggup>0){$sigup++;}
	if ($siggdown>0){$sigdown++;}
    }
    my $P2= int (100*$N4/$N3);
    my $PU= int (100*$up/$N3);
    my $PD= int (100*$down/$N3);
    my $sigPU=0;
    my $sigPD=0;
    if ($N4>=5){
	$sigPU= int (100*$sigup/$N4);
	$sigPD= int (100*$sigdown/$N4);
    

	my $score=0;
	if ($PU >$PD){
	    if ($PU>=90){
		$score=$score+2;
	    }elsif($PU>=70){
		$score=$score+1;
	    }
	}elsif($PD>$PU){
	    if ($PD>=90){
		$score=$score+2;
	    }elsif($PD>=70){
		$score=$score+1;
	    }	
	}
	
	if ($sigPU >$sigPD){
	    if ($sigPU>=90){
		$score=$score+2;
	    }elsif($sigPU>=70){
		$score=$score+1;
	    }
	}elsif($sigPD>$sigPU){
	    if ($sigPD>=90){
		$score=$score+2;
	    }elsif($sigPD>=70){
		$score=$score+1;
	    }	
	}
	
	$score=$score+$N4;
	if ($P2>=50){
	    if($P2<70){
		$score=$score+2;
	    }else{
		$score=$score+3;
	    }
	}
	my $line_content=
	    "$pname"
	    .":$pp\t"
	    ."$P2\t"
	    ."$N4\t$sigup\t$sigdown"
	    #."$PU\t"
	    #."$PD\t"
	    #."$sigPU\t"
	    #."$sigPD\t"   
	    ."\n";
	#print STDERR $line_content, "\n";
	if (! defined $part{$score}){
	    $part{$score}=$line_content;
	}else{
	    $part{$score}.=$line_content;
	}
    }
    
}
print B "PathwayName:ID\tSigPercent\tSigProbeNumber\tSigUP\tSigDOWN\n";
foreach my $score (sort {$b<=>$a} keys %part){
    print B $part{$score};
}
close B;


sub fill_stat{
    my ($ph,$fh,$file)=@_;
    open (X, "$file")||die "could not open $file\n";
    while (my $line = <X>){
	chomp $line;
	my @tmp=split /\t/, $line;
	if (@tmp<2){next;}
	$$ph{lc($tmp[0])}=lc($tmp[1]);
	$$fh{lc($tmp[0])}=lc($tmp[2]);
    }
    close X;
    return;
}

sub fill_hash{
    my ($h, $file)=@_;
    open (X, "$file")||die "could not open $file\n";
    while (my $line = <X>){
	chomp $line;
	my @tmp=split /\t/, $line;
	if (@tmp<2){next;}
	$$h{lc($tmp[0])}=lc($tmp[1]);
    }
    close X;
    return;
}
