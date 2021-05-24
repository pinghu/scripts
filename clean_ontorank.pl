use strict;
my $usage="$0  [list]....\n"; 
die $usage unless @ARGV == 1;
my ($list) = @ARGV;

open (A, "<$list")||die "could not open $list\n";
while (my $a=<A>){
    chomp $a;
    my $file1="$a.result";
    my $file2="$a.sig";
    
    open (B, "<$file1")||die "could not open $file1\n";
    open (C, ">$file2")||die "could not open $file2\n";
    my $all="";
    my %check;
    while (my $c=<B>){
	chomp $c;
	my @tmp=split /\t/, $c;
	if (@tmp>4){
	    if (($tmp[3]<=0.05)&&($tmp[2]<=500)&&($tmp[1]>1)){
		if (! defined $check{$tmp[5]}){
		    print C $tmp[0], "\t",$tmp[1], "\t",$tmp[2], "\t", $tmp[3], "\t", $tmp[4], "\n";
		    $check{$tmp[5]}=1;
		}
	    }
	}else{
	    print C $c, "\n";
	}
    }
    close B;
    close C;
}
close A;
