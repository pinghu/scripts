#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### update Dec_3_2014
### combine all samples into table excel sheet
### 
##########################################################################
use strict;

my ($file, $PCUT) = @ARGV;

my $usage = "$0 file_list generate file_list.hairtheme.xls\n";
die $usage unless @ARGV >= 1;
if(! defined $PCUT){$PCUT=0.05;}
#my $acr_file="/home/ping/db/affy/ann34/HG-U133_Plus_2.na34.annot.csv.syn";
my $acr_file="/home/ping/db/affy/HG-U219.na33.annot.csv.syn";
my %acr;
fill_hash($acr_file,\%acr);

open (B, "<$file")|| die "could not open AAA $file\n";

my @ff;
my %data;
my %CN;
#my %TotalGN;
my %Genelist;
my %direction;
#my (%FFF, %PPP);
while (my $line =<B>){
    chomp $line;
    push (@ff, $line);
    open (C, "<$line")|| die "could not open BBB $line\n";
########we can use this to creat a gene page then I do not need to maintain the overall heatmap page, but just create one using the raw result file#####################   
    my $statfilename=$line;
    my $name_all=$statfilename."_p05";
    my $name_up=$statfilename."_upp05";
    my $name_dn=$statfilename."_dnp05";
    ###Need to think about how to do this one
    #my $statfile= "$statpath/$statfilename";
   
    
    #fill_stat(\%{$PPP{$statfilename}}, \%{$FFF{$statfilename}}, $statfile);
 
##################################################
#now I need to creat the gene page  write_gene_html ($genestring, $sub_item_file_name, "$name -- $SUBTITLE", $HPPP, $HFFF, $HLONG_NAME, $Hacr);
#################################################
    open (A, "<$name_all.result")||die "could not open $name_all.result\n";
    while (my $a=<A>){
	chomp $a;
	my @tmp=split /\t/, $a;
	if(scalar @tmp >=5){
	    my $PP=$tmp[0]."\t".$tmp[5]; #name
	    if ($tmp[4] =~ /(-?\d.\d+)[eE](.\d+)/){
		my ($const, $expon) = ($1, $2);
		my $result = ($const * 10 ** $expon);
		#print STDERR $x, "\t", $result, "\n";
		$tmp[4]=$result;
	    }
	    if($tmp[4] <=$PCUT){	
		$data{$PP}{$statfilename}=$tmp[4]; #pval
		$direction{$PP}{$statfilename}="sig"; #direction
	    }
	    $CN{$PP}{$statfilename}{"all"}=$tmp[1]; #number sig probes
	   # $TotalGN{$PP}{$statfilename}=$tmp[2]; #total probes
	    $Genelist{$PP}{$statfilename}=$tmp[6]; #probes id
	}
    }
    close A;

    open (A, "<$name_up.result")||die "could not open $name_up.result\n";
    while (my $a=<A>){
	chomp $a;
	my @tmp=split /\t/, $a;
	if(scalar @tmp >=5){
	    my $PP=$tmp[0]."\t".$tmp[5];
	    if ($tmp[4] =~ /(-?\d.\d+)[eE](.\d+)/){
		my ($const, $expon) = ($1, $2);
		my $result = ($const * 10 ** $expon);
		#print STDERR $x, "\t", $result, "\n";
		$tmp[4]=$result;
	    }
	    if($tmp[4] <=$PCUT){
		if((! defined $data{$PP}{$statfilename})||($tmp[4] <  $data{$PP}{$statfilename})){
		    $data{$PP}{$statfilename}=$tmp[4];
		    $direction{$PP}{$statfilename}="up"; #direction
		}
	    }
	    $CN{$PP}{$statfilename}{"up"}=$tmp[1];
	    if(defined $Genelist{$PP}{$statfilename}){
		$Genelist{$PP}{$statfilename}.="#".$tmp[6];
	    }else{
		$Genelist{$PP}{$statfilename}=$tmp[6];
	    }
	}
	
    }
    close A;
    
    open (A, "<$name_dn.result")||die "could not open $name_dn.result\n";
    while (my $a=<A>){
	chomp $a;
	my @tmp=split /\t/, $a;
	if(scalar @tmp >=5){
	    my $PP=$tmp[0]."\t".$tmp[5];
	    if ($tmp[4] =~ /(-?\d.\d+)[eE](.\d+)/){
		my ($const, $expon) = ($1, $2);
		my $result = ($const * 10 ** $expon);
		#print STDERR $x, "\t", $result, "\n";
		$tmp[4]=$result;
	    }
	    if($tmp[4] <=$PCUT){
		if((! defined $data{$PP}{$statfilename})||($tmp[4] <  $data{$PP}{$statfilename})){
		    $data{$PP}{$statfilename}=$tmp[4];
		    $direction{$PP}{$statfilename}="dn"; #direction
		}
	    }
	    $CN{$PP}{$statfilename}{"dn"}=$tmp[1];
	    if(defined $Genelist{$PP}{$statfilename}){
		$Genelist{$PP}{$statfilename}.="#".$tmp[6];
	    }else{
		$Genelist{$PP}{$statfilename}=$tmp[6];
	    }

	}
	
    }
    close A;

}
close B;
open (C, ">$file.Hairtheme.xls")|| die "could not open AAA $file.hairtheme.xls\n";
print C "Theme_ID\tThemeName";
for(my $j=0; $j<@ff; $j++){
    print C "\t",  $ff[$j], ".themeDirection";
}
print C "\t","SEP";
for(my $j=0; $j<@ff; $j++){
    print C "\t", $ff[$j], ".themepvalue";
}

print C "\tTotal_Sig_File\tBestPVal\tprobecount\tsymbolcount\tsymbol\n";
foreach my $i(sort keys %data){
     for($i){s/\s*null\s*//gi;}
     ####select which theme to go in the result
       
     #########Can add selection Here########
     my $GOGO=0;
     if ($i =~ /hair/gi){
	 $GOGO=1;
     }elsif($i =~ /epith/gi){
	 $GOGO=1;
     }elsif($i =~ /kerat/gi){
	 $GOGO=1;
     }elsif($i =~ /epider/gi){
	 $GOGO=1;
     }elsif($i =~ /pig/gi){
	    $GOGO=1;
     }elsif($i =~ /melan/gi){
	 $GOGO=1;
     }
     if($GOGO==0){next;}
     my $printString=$i;
     my $directString="";
     my $pvalString="";
     my $sigCount=0;
     my $bestP=1;
     my $GeneString="";
     for(my $j=0; $j<@ff; $j++){
	my $ffname=$ff[$j];
	if(defined  $Genelist{$i}{$ffname}){
	    if($GeneString ne ""){ 
		$GeneString=$Genelist{$i}{$ffname};
	    }else{
		$GeneString.=$Genelist{$i}{$ffname};
	    }
	}
       
	my $trend="--"; my $color="black"; my $PVAL=1;
	if(defined $direction{$i}{$ffname}){
	    $trend=$direction{$i}{$ffname};
	    if($trend eq "up"){$color="red";}
	    if($trend eq "dn"){$color="blue";}
	    if($trend eq "sig"){$color="green";}
	}
	if(defined $data{$i}{$ffname}){
	    $PVAL= $data{$i}{$ffname};
	}
	my $UPN=0; my $SIGN=0; my $DNN=0;
	if(defined $CN{$i}{$ffname}{"sig"}){
	    $SIGN=$CN{$i}{$ffname}{"sig"};
	}
	if(defined $CN{$i}{$ffname}{"up"}){
	    $DNN=$CN{$i}{$ffname}{"up"};
	}
   
   	if(defined $CN{$i}{$ffname}{"dn"}){
	    $UPN=$CN{$i}{$ffname}{"dn"};
	}
	if($SIGN ==0){
	    if(($UPN !=0)||($DNN !=0)){
		$SIGN=$UPN+$DNN;
	    }
	}

   	if($UPN ==0){
	    $UPN=$SIGN-$DNN;
	}
	
 	if($DNN ==0){
	    $DNN=$SIGN-$UPN;
	}
	if($SIGN>0){$sigCount++;}
	if($PVAL<$bestP){$bestP=$PVAL;}
	$directString .="\t".$trend ;
	$pvalString .= "\t".$PVAL;
     }
     my @tmp=split /\#/, $GeneString;
     my %gene; my %syn;
     for(my $i=0; $i<@tmp; $i++){
	 $gene{$tmp[$i]}=1;
	 if(defined $acr{$tmp[$i]}){
	     $syn{$acr{$tmp[$i]}}=1;
	 }
     }
     my $symbol="";
     my $probecount=scalar keys %gene;
     my $symbolcount= scalar keys %syn;
     for my $i (sort keys %syn){
	 $symbol.=$i."#";
     }
     if($sigCount>0){
	 print C $i, $directString,"\tSEP",$pvalString, "\t", $sigCount, "\t", $bestP, "\t",$probecount,"\t", $symbolcount, "\t",$symbol,"\n";
     }
}
close C;
sub fill_hash{
    my ($file, $HF)=@_;
    open (X, "<$file")or die "could not open $file\n ";
    while (my $line=<X>){
        chomp $line;
        my @tmp=split /\t/, $line;
        if (defined $tmp[1]){
            $$HF{$tmp[0]}=$tmp[1];
        }else{
            $$HF{$tmp[0]}="#";
        }
    }
    close X;
    return;
}

