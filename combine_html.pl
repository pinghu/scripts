#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  [p][col][file] first line is title\n"; 
die $usage unless @ARGV ==2;
my ($outfile, $listfile) = @ARGV;
open (A, "<$listfile")||die "could not open $listfile\n";
my @files;
while (my $a=<A>){
    chomp $a;
    for($a){s/\r//gi;}
    push(@files, $a);
}
close A;

my %data;
my %linkF;
my $PLOT_LINK2="http://mvic-biotech.na.pg.com/projects/Healthy_Hair/GSS1301_MDEHair/Statistical_Analyses/plotpergene/";
my $PLOT_LINK="http://mvic-biotech.na.pg.com/projects/Healthy_Hair/GSS1301_MDEHair/Statistical_Analyses/plotpergene/";
foreach my $file (@files){
open (A, "<$file")||die "could not open $file\n";
while (my $a=<A>){
    chomp $a;
    for($a){
	s/\<\/td\>//gi;s/\<\/tr\>//gi;

	
#<tr style="color: blue">\tGO:0006631	fatty acid metabolic process\t<a href="./GSS1423.Mlut292_Mlut173C.diff.html_files/ITEM76.html" target="_geneWindow" );>down</a>\t1.947E-15\t1.245E-9\t60\t1\t10\t1.947E-15\t50\t637
    }
    if($a =~ /<h2><a href=\"(.*html)\"/){
	$linkF{"all"}{$file}=$1;
    }
    if($a =~ /<tr style="color:\s+(\S+)">/){
	#print STDERR "$a\n";
	my $color=$1;
	my @tmp=split /\<td\>/, $a;
#	print STDERR $tmp[1], "\t", $tmp[2], "\n";
	my $theme=$tmp[1];
	my $p=$tmp[3];
	my $link="";
	if($tmp[2] =~/href=\"(.*html)\"/){
	    $link=$1;
	}
	if($color eq "blue"){
	    $p=-$p;
	}
	$data{$theme}{$file}=$p;
	$linkF{$theme}{$file}=$link;
#	print STDERR $theme, "\t", $file, "\t", $p, "\t", $link, "\n";
    }

}
close A;
}
open (B, ">$outfile")or die "could not open $outfile\n ";
my $MAIN_HEADER= get_main_header($outfile);
print B $MAIN_HEADER;
print B "<table border=1 class=\"sortable\" id=\"5429378998752\" >\n<tr><td>Theme</td>";
foreach my $file (@files){
    my $link=$linkF{"all"}{$file};
    my $nn=$file;
    for($nn){s/\.html//gi;}
    print B "<td><a href=\"$link\">$nn</a></td>";
}
print B "</tr>\n";

foreach my $i(keys %data){
   print B "<tr><td>$i</td>";
    foreach my $file (@files){
	my $p=1;
	my $link="NA";
	if(defined $data{$i}{$file}){
	    $p=$data{$i}{$file};
	}
	if(defined $linkF{$i}{$file}){
	    $link=$linkF{$i}{$file};
	}
	my $color="white";
	if($p<0){$color="#66FFFF";}elsif($p<1){$color="#FFCCFF";}
	print B "<td style=\"background-color: $color\"><a href=\"$link\">", $p, "</a></td>";

    }
   print B "</tr>\n";
}
my $tail=get_end();
print B  "\n</table>", $tail;
close B;

sub get_main_header{
    my ($TITLE)=@_;
    my $MAIN_HEADER="<html>\n<head>\n
    <title>Clusterer Heat Map</title>
	<script language=\"JavaScript\">
	function gsr( gene ) {
	    link = \'http://en.wikipedia.org/wiki/\'+ gene;
		window.open( link, \'popup\', \'width=900,height=700,resizable=yes,scrollbars=yes\' );
	}

	function gar( gene ) {
	    link = \'$PLOT_LINK\' + gene + '.png';
	    window.open( link, \'popup\', \'width=900,height=700,resizable=yes,scrollbars=yes\' );
	}
        function fue( gene ) {
	    link = \'$PLOT_LINK2\' + gene + '.png';
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
        <script type=\"text/javascript\" src=\"http://artemis.na.pg.com/sorttable.js\"></script>

  </head>

  <body>
  <h1><center>$TITLE</center></h1>
 
";
    return $MAIN_HEADER;
}
sub get_end{
    my $tail="<h3>Report created on: ".time_string()."</h3>\n</body>\n</html>\n";
    return $tail;
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

