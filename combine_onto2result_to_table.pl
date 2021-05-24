#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### update 9_23_2011
### idea: how to process this to only display the differential one?
### it is worth to disply as uber html? somtimes it linked back to molecular function and biological process
##########################################################################
use strict;

my ($file, $CUT, $statpath, $longfile, $acrfile, $outname) = @ARGV;

my $usage = "$0 file_list P_CUT stat_path  annfile synfile outputname\n";
die $usage unless @ARGV == 6;
my %long;
my %acr;
fill_hash(\%long, $longfile);
fill_hash(\%acr, $acrfile);

open(OUTPUT, ">$outname.xls")||die "could not open $outname.html\n";

open (B, "<$file")|| die "could not open AAA $file\n";
my %number;
my %score;
my %GENE;
my %good;

my @ff;
while (my $line =<B>){
    chomp $line;
    push (@ff, $line);
    open (C, "<$line")|| die "could not open BBB $line\n";
########we can use this to creat a gene page then I do not need to maintain the overall heatmap page, but just create one using the raw result file#####################   
    my $statfilename=$line;


   if ($line=~/(\S+)\_p\d+.result/){
	$statfilename=$1;
    }elsif ($line=~/(\S+)\_dnp\d+.result/){
	$statfilename=$1;
    }elsif ($line=~/(\S+)\_upp\d+.result/){
	$statfilename=$1;
    }elsif ($line=~/(\S+).up.result/){
	$statfilename=$1;
    }elsif ($line=~/(\S+).down.result/){
	$statfilename=$1;
    }elsif ($line=~/(\S+).sig.result/){
	$statfilename=$1;
    }elsif ($line=~/(\S+).result/){
	$statfilename=$1;
    }


    my $statfile= "$statpath/$statfilename";
    my (%FFF, %PPP);
  

    fill_stat(\%PPP, \%FFF, $statfile);
 
##################################################
#now I need to creat the gene page  write_gene_html ($genestring, $sub_item_file_name, "$name -- $SUBTITLE", $HPPP, $HFFF, $HLONG_NAME, $Hacr);
#################################################
    while (my $M =<C>){
	chomp $M;
	my @tmp=split /\t/, $M;
	if (@tmp<5){next;}
	my $goname=$tmp[0]. " ". $tmp[6];
	#my $goshort=substr($goname, 0, 58);
	my $id=$goname;
	my $p=$tmp[5];
	my $x=$p;
	if ($x =~ /(-?\d.\d+)[eE](.\d+)/){
	    my ($const, $expon) = ($1, $2);
	    my $result = ($const * 10 ** $expon);
	    #print STDERR $x, "\t", $result, "\n";
	    $x=$result;
	}
	my $n=$tmp[1];
	my @genes=split /\#/, $tmp[7];
	if ($x<=$CUT){
	    if (!defined $good{$id}){
		$good{$id}=1;
	    }else{
		$good{$id}++;
	    }
	    
	}
	$score{$id}{$line}=$p;
	$number{$id}{$line}=$n;
	foreach my $i (@genes){
	    $GENE{$id}{$i}=1;
	}


    }
    close C;
    
}
close B;


print OUTPUT "#Table of Biological Themes\n";
print OUTPUT "GO_Name";
for(my $i=0; $i<@ff; $i++){
   print OUTPUT "\t", $ff[$i];  
}
print "\n";
print OUTPUT "\tSigFile#\tAllGene#\n";
foreach my $i (sort keys %good){
    my $good_number=0;

    my $gn=0;
    my $gstring="";
    foreach my $gg(keys %{$GENE{$i}}){
	$gn++;
	$gstring.=$gg."#";
    }
    print OUTPUT $i; 
    foreach my $j (@ff){
	my $SCORE="-";
	if ((defined $score{$i}{$j})&&($score{$i}{$j}<=$CUT)){
	    $SCORE=$score{$i}{$j};
	    $good_number++;
	}
	print OUTPUT "\t", $SCORE;

    }
    print OUTPUT "\t", $good_number, "\t", $gn, "\n";
}
print OUTPUT "\n";


sub fill_stat{
    my ($ph,$fh,$file)=@_;
    open (X, "$file")||die "could not open DDD $file\n";
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
sub fill_stat_log{
    my ($ph,$fh,$file)=@_;
    open (X, "$file")||die "could not open EEE $file\n";
    my $tmpx=<X>;
    while (my $line = <X>){
	chomp $line;
	my @tmp=split /\t/, $line;
	if (@tmp<2){next;}
	$$ph{lc($tmp[0])}=lc($tmp[1]);
	$$fh{lc($tmp[0])}=2**($tmp[2]);
    }
    close X;
    return;
}
sub time_string{
    my @Weekdays = ('Sunday', 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday');
    my @Months = ('January', 'February', 'March', 'April', 'May', 'June', 'July', 'August', 'September', 'October', 'November', 'December');
    my @Now = localtime(time());
    my $Month = $Months[$Now[4]];
    my $Weekday = $Weekdays[$Now[6]];
    my $Hour = $Now[2];
    my $AMPM;
    if ($Hour > 12) {
	$Hour = $Hour - 12;
	$AMPM = "PM";
    } else {
	$Hour = 12 if $Hour == 0;
	$AMPM ="AM";
    }
    my $Minute = $Now[1];
    $Minute = "0$Minute" if $Minute < 10;
    my $Year = $Now[5]+1900;
    my $time_string="$Weekday, $Month $Now[3], $Year $Hour:$Minute $AMPM";
    return $time_string;
}

sub fill_hash{
    my ($h, $file)=@_;
    open (X, "$file")||die "could not open FFF $file\n";
    while (my $line = <X>){
	chomp $line;
	my @tmp=split /\t/, $line;
	if (@tmp<2){next;}
	$$h{lc($tmp[0])}=lc($tmp[1]);
    }
    close X;
    return;
}

