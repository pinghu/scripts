#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### update 9_23_2011
### idea: how to process this to only display the differential one?
### it is worth to disply as uber html?
##########################################################################
use strict;

my ($file, $CUT, $statpath, $longfile, $acrfile, $outname) = @ARGV;

my $usage = "$0 file_list P_CUT stat_path  annfile synfile outputname\n";
die $usage unless @ARGV == 6;
my %long;
my %acr;
fill_hash(\%long, $longfile);
fill_hash(\%acr, $acrfile);

open(OUTPUT, ">$outname.html")||die "could not open $outname.html\n";
system("mkdir sub_$outname\n");
open (B, "<$file")|| die "could not open AAA $file\n";
my %number;
my %score;
my %GENE;
my %good;
my %link;
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
	my $goname=$tmp[0]. " ". $tmp[5];
	my $goshort=substr($goname, 0, 58);
	my $id="<td>".$goshort."</td>";
	my $p=$tmp[4];
	my $x=$p;
	if ($x =~ /(-?\d.\d+)[eE](.\d+)/){
	    my ($const, $expon) = ($1, $2);
	    my $result = ($const * 10 ** $expon);
	    #print STDERR $x, "\t", $result, "\n";
	    $x=$result;
	}
	my $n=$tmp[1];
	my @genes=split /\#/, $tmp[6];
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
	my $goid=$tmp[0];
	for($goid){s/://gi;}
	my $pagename="sub_$outname/$goid.$statfilename.html";
	$link{$id}{$line}=$pagename;
	write_gene_html ($tmp[6], $pagename, "$goid -- $statfilename", \%PPP, \%FFF, \%long, \%acr);
    }
    close C;
    
}
close B;

print OUTPUT "<html><body>\n";
my $color_code=get_color_code($CUT);
print OUTPUT $color_code;

print OUTPUT "<table border=1>\n";
for (my $i =1; $i <@ff; $i++){
    print OUTPUT  "<tr>\n";
    print OUTPUT  "<td align=\"LEFT\">GL$i</td>\n";
    print OUTPUT  "<td align=\"LEFT\">";
    print OUTPUT  $ff[$i];
    print OUTPUT  "</td>\n";
    print OUTPUT  "</tr>\n";
}
print OUTPUT  "</table>\n";
print OUTPUT "<table BORDER=2 CELLPADDING=2 CELLSPACING=2 WIDTH=200>\n";
print OUTPUT "<tr><th>GO_Name";
for(my $i=0; $i<@ff; $i++){
   print OUTPUT "</th><th>GL$i";  
}


print OUTPUT "</th><th>SigFile#</th><th>AllGene#</th></tr>\n";

foreach my $i (sort keys %good){
    my $good_number=0;
    if (defined $good{$i}){
	$good_number=$good{$i};
    }
    
    my $gn=0;
    my $gstring="";
    foreach my $gg(keys %{$GENE{$i}}){
	$gn++;
	$gstring.=$gg."#";
    }
    
    print OUTPUT "<tr>".$i; 
    
    foreach my $j (@ff){
	my $SCORE="-";
	
	if ((defined $score{$i}{$j})&&($score{$i}{$j}<=$CUT)){
	    $SCORE=$score{$i}{$j};
	    
	}
	
	if (($SCORE eq "-")||(!defined $link{$i}{$j})){
	    my ($span_class, $sub_score)=get_span_P(1, $CUT);
	    print OUTPUT "</td><td $span_class >", $SCORE;
	}else{
	    my ($span_class, $sub_score)=get_span_P($SCORE, $CUT);
	    my $LIN=$link{$i}{$j};
	    print OUTPUT "</td><td $span_class ><a href=\"$LIN\">", $SCORE, "</a>";
	}
    }
    print OUTPUT "</td><td>", $good_number, "</td><td>", $gn, "</td></tr>\n";
}
print OUTPUT"</table></body></html>\n";

sub write_gene_html{
    ######gene names will be #seperated###########
    my ($gene_names, $file_name, $tname, $HPPP, $HFFF, $HLONG_NAME,$Hacr) =@_;
    my @array =split /\#/, lc($gene_names);
   # print STDERR $gene_names, "\n";

    open (DDDD, ">$file_name")or die "could not open XXX $file_name\n ";

    my $header =get_sub_header($tname);
    print DDDD $header;
    print DDDD "\n\n<table border=1>\n<tr>\n";
    print DDDD "<td><font color=\"#000099\">Gene</font></td>\n";
    print DDDD "<td><font color=\"#000099\">Acronym</font></td>\n";
    print DDDD "<td><font color=\"#330033\">P</font></td>\n";
    print DDDD "<td><font color=\"#996600\">Fold</font></td>\n";
    print DDDD "<td><font color=\"#006600\">Name</font></td>\n";
  
    print DDDD "</tr>\n";
    my %order;my $other="";
    for (my $i =0; $i < scalar @array; $i++){
	my $name=$array[$i];
	my $P="N/A";
	my $FC="N/A";
	my $long="N/A";
	my $aaa="N/A";
	
	#foreach my $i (keys %{$HPPP}){
	 #   if($name eq $i){
		#print STDERR $i, "\t", $$HPPP{$i},"\t", $name, "\twork\n";
	    #}else{
		#print STDERR $i, "\t", $$HPPP{$i},"\t", $name, "\n";
	    #}
	#}
	
	if (defined $$HPPP{$name}){$P=$$HPPP{$name};}
	if (defined $$HFFF{$name}){$FC=$$HFFF{$name};}
	if (defined $$HLONG_NAME{$name}){$long=$$HLONG_NAME{$name};}
	if (defined $$Hacr{$name}){$aaa=$$Hacr{$name};}

	my $span_class="style=\"background-color:f0f0f0\"";
	my $span_p="style=\"background-color:C0C0C0\"";
	if (($FC ne "N/A")&&($FC ne "")&&($FC ne "-")){
	    if ($FC >4){
		$span_class="style=\"background-color:f06464\""; 
	    }elsif($FC>2){
		$span_class="style=\"background-color:f09292\"";
	    }elsif($FC>1.2){
		$span_class="style=\"background-color:f0c1c1\"";
	    }elsif($FC>0.8){
		$span_class="style=\"background-color:f0f0f0\"";
	    }elsif($FC>0.5){
		$span_class="style=\"background-color:c1c1f0\"";
	    }elsif($FC>0.25){
		$span_class="style=\"background-color:9292f0\"";
	    }else{
		$span_class="style=\"background-color:6464f0\"";
	    }
	}
	if (($P ne "N/A")&&($P ne "")&&($P ne "-")){
	    if ($P <0.0001){ 
		$span_p="style=\"background-color:ff0000\""; 
	    }elsif($P<0.001){
		$span_p="style=\"background-color:ff9700\"";
	    }elsif($P<0.01){
		$span_p="style=\"background-color:ffca00\"";
	    }elsif($P<0.1){
		$span_p="style=\"background-color:fffd00\"";
	    }else{
		$span_p= "style=\"background-color:c0c0c0\"";
	    } 
	}
       
	my $line="<tr>\n<td><a href=\"javascript:void(0)\" onclick=\"gar(\'$name\');\">$name</a> </td>\n"
	    ."<td><a href=\"javascript:void(0)\" onclick=\"gsr(\'$aaa\');\">$aaa</a> </td>\n"
	    ."<td $span_p>$P</td>\n"."<td $span_class>$FC</td>\n"
	    ."<td><font color=\"#006600\">$long</font></td>\n"
	    ."</tr>\n";
	

	if (($FC ne "N/A")&&($FC ne "")&&($FC ne "-")){
	    if (! defined $order{$FC}){$order{$FC}=$line;}
	    else{
		$order{$FC}.=$line;
	    }
	}else{
	    $other.=$line;
	} 
    }
    foreach my $i (sort {$a<=>$b} keys  %order){
	print DDDD $order{$i};
    }
    print DDDD $other;
    print DDDD "</table>\n"; 
    print DDDD time_string(), "\n";
    print DDDD "</BODY></HTML>\n";
    return;
}

sub get_sub_header{
    my ($name)=@_;
        my $header="<html>
	<head>

	<script language=\"JavaScript\">
	
	function gsr( gene ) {
	    link = \'http://www.genecards.org/cgi-bin/carddisp.pl?gene=\'+ gene;
		window.open( link, \'popup\', \'width=900,height=700,resizable=yes,scrollbars=yes\' );
	}
	function gfr( gene ) {
	    link = \'http://mvl-genome.na.pg.com/tigr-scripts/prok_manatee/shared/ORF_infopage.cgi?db=mgl&orf=\' + gene;
	    window.open( link, \'popup\', \'width=900,height=700,resizable=yes,scrollbars=yes\' );
	}
	function gar( gene ) {
	    link = \'http://iip6.pg.com/iip-server/gsr/search/searchType/AFFY_ID/matchType/STARTS_WITH/searchTerm/\' + gene;
	    window.open( link, \'popup\', \'width=900,height=700,resizable=yes,scrollbars=yes\' );
	}

	function ger( gene ) {
	    link = \'http://www.ncbi.nlm.nih.gov/entrez/query.fcgi?db=gene&cmd=Retrieve&dopt=Graphics&list_uids=\' + gene;
	    window.open( link, \'popup\', \'width=900,height=700,resizable=yes,scrollbars=yes\' );
	}

	var newWin;
	function popupWindow( term, geneList, genes ) {
	    if( newWin != null ) {
			newWin.close();
		}
        newWin = window.open(\'http://yahoo.com\',\'popup\',\'width=900,height=700,resizable=yes\'); 
    }

	</script>

  </head>

  <body>
  
  <h1><center>$name<center></h1>

  <table>
  <tr><td valign=top>
  <table border = 1>
  <tr><th>FOLD_CHANGE_COLOR_KEY</th></tr>
  <tr><td style=\"background-color:#6464f0\">Fold change &lt 0.25 </td></tr>
  <tr><td style=\"background-color:#9292f0\"> 0.25 =&lt Fold change &lt 0.5</td></tr>
  <tr><td style=\"background-color:#c1c1f0\"> 0.5 =&lt Fold change &lt 0.8</td></tr>

  <tr><td style=\"background-color:#f0c1c1\"> 1.2 =&lt Fold change &lt 2</td></tr>
  <tr><td style=\"background-color:#f09292\"> 2 =&lt Fold change &lt 4</td></tr>
  <tr><td style=\"background-color:#f06464\"> 4 &lt Fold change</td></tr>

  <tr><td style=\"background-color:f0f0f0\"> Other </td></tr>
  </table>
  </td>
  <td valign=top>
  <table border = 1>
  <tr><th>pvalue_COLOR_KEY</th></tr>
  <tr><td style=\"background-color:#FF0000\">p-value &lt 1.0E-4 </td></tr>
  <tr><td style=\"background-color:#FF9700\"> 1.0E-4 =&lt p-value &lt 1.0E-3</td></tr>

  <tr><td style=\"background-color:#FFCA00\"> 1.0E-3 =&lt p-value &lt 0.01</td></tr>
  <tr><td style=\"background-color:#FFfd00\"> 0.01 =&lt p-value &lt 0.1</td></tr>
  <tr><td style=\"background-color:#C0C0C0\"> other</td></tr>
  </table>
  </td>
  <tr></table>

";
    return $header;
}
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

sub get_color_code{
    my ($P_CUT)=@_;
    my $content="<table border=\"1\" align=\"CENTER\">\n"
    . "<tr><td align=\"CENTER\"><h2>Heat Map Color Legend</h2></td></tr>\n<tr>\n<td style=\"background-color:C0C0C0\">\n"
    .$P_CUT
    ." < p</td>\n</tr>\n<tr>\n<td style=\"background-color:FFfd00\">"
    .0.1*$P_CUT
    . " < p <= "
    .$P_CUT
    ."</td>\n</tr>\n<tr>\n<td style=\"background-color:FFca00\">"
    .0.01*$P_CUT
    ." < p <= "
    .0.1*$P_CUT
    ."</td>\n</tr>\n<tr><td style=\"background-color:FF9700\">"
    .0.001*$P_CUT
    . " < p <= "
    .0.01*$P_CUT
    ."</td>\n</tr>\n<tr>\n<td style=\"background-color:FF0000\">p <= "
    .0.001*$P_CUT
    ."</td>\n</tr>\n</table>\n";
    return $content;
}

sub get_span_P{
    my ($p, $P_CUT)=@_;
    my $span_class="style=\"background-color:C0C0C0\"";
    my $score=0;
    if ($p <=0.001*$P_CUT){
	$span_class="style=\"background-color:FF0000\"";
	$score=4;
    }elsif($p<=0.01*$P_CUT){
	$span_class="style=\"background-color:FF9700\"";
	$score=3;
    }elsif($p<=0.1*$P_CUT){
	$span_class="style=\"background-color:FFca00\"";
	$score=2;
    }elsif($p<=$P_CUT){
	$span_class="style=\"background-color:FFfd00\"";
	$score=1;
    }

    return ($span_class, $score);
}
