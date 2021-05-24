#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### update 9_23_2011
### idea: how to process this to only display the differential one?
### it is worth to disply as uber html?
##########################################################################
use strict;

my ($file,  $outname) = @ARGV;

my $usage = "$0 file_list   outputname\n";
die $usage unless @ARGV == 2;



open (B, "<$file")|| die "could not open AAA $file\n";

my @ff;
my %title;
my %trend;
my %trend_N;
my @pattern;
my $check=0;
while (my $line =<B>){
    chomp $line;
    push (@ff, $line);
   
    open (C, "<$line")|| die "could not open BBB $line\n";
    my $t=<C>;
    my @tt=split /\t/, $t;
    $title{$line}= $tt[0];
    while (my $M =<C>){
	chomp $M;
	my @tmp=split /\t/, $M;
	if ($check==0){
	    push(@pattern, $tmp[0]);
	}
	$trend{$tmp[0]}{$line}=$tmp[4];
	$trend_N{$tmp[0]}{$line}=$tmp[5];
    }
    $check=1;
    close C;
    
}
close B;

open(OUTPUT, ">$outname.html")||die "could not open $outname.html\n";
print OUTPUT "<html><head><script src=\"/home/ping/bin/sorttable.js\"></script></head><body>\n";

print OUTPUT "<table class=\"sortable\" BORDER=2 CELLPADDING=2 CELLSPACING=2 WIDTH=200>\n";
print OUTPUT "<tr><th>Comparison";
for(my $i=0; $i<@pattern; $i++){
   print OUTPUT "</th><th>", $pattern[$i];  
}


print OUTPUT "</th></tr>\n";

    
for(my $j=0; $j<@ff; $j++){
    my $file=$ff[$j];
    print OUTPUT "<tr><td><a href=\"$file\">", $file, "</a></td>";
    for(my $i=0; $i<@pattern; $i++){
	my $TR=$trend{$pattern[$i]}{$ff[$j]};
	my $TRN=$trend_N{$pattern[$i]}{$ff[$j]};
	my $color="yellow";
	my $bgcolor="#AAAAAA";
	if ($TR eq "UP"){$color="black"; $bgcolor="#FF0000";}
	if ($TR eq "DOWN"){$color="white"; $bgcolor="#0000FF";}
	print OUTPUT "<td bgcolor=$bgcolor ><font color=$color>$TRN</font></td>";
    }
    print OUTPUT "</tr>\n";
    
}
print OUTPUT"</table>\n";
print OUTPUT time_string();
print OUTPUT "</body></html>\n";

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

