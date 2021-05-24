#! /usr/bin/perl -w
##########################################################################
#### Author: Ping HU
#### 
##########################################################################
use strict;
my $usage="$0  <file>  \n"; 
die $usage unless @ARGV == 1;
my ($file) = @ARGV;
my $name="";
my $seq="";
my $total=0;
my $totalN=0;
my $totalQ=0;
open (A, "<$file")||die "could not open $file\n";
my %SLen;
my %SQual;
print  "file\treads#\tAverageLength\tAverageQualityScore\n"; 
while (my $a=<A>){
    chomp $a;
    
    if ($a =~ /^\@\S+/){
	#$totalN++;
	my $name=$a;
	my $seq=<A>;
	chomp $seq;
	my $SeqLen=length($seq);

	my $aa=<A>;
	chomp $aa;
	for($aa){s/\r//gi;}
	if($aa ne "+"){print STDERR $aa, "\t Not Right\n";}else{
	  $totalN=$totalN+1;  
	}
	my $bb=<A>;  
	chomp $bb;
      
	my $avebb2=get_average_SANGERquality_score($bb);
	if (! defined $SLen{$SeqLen}){
	    $SLen{$SeqLen}=1;
	} else{
	   $SLen{$SeqLen}++; 
	}
	if (! defined $SQual{$avebb2}){
	    $SQual{$avebb2}=1;
	} else{
	   $SQual{$avebb2}++; 
	}
	if($SeqLen<75){
	    print $name, "\t", $SeqLen, "\t",  $avebb2,"\n";
	}
	$total+=$SeqLen;
	
    }
    
}
close A;

print "++++++++++++++++++++++++++\nSequenceLength\tSequenceNumber\n";
foreach my $i (keys %SLen){
    print $i, "\t", $SLen{$i}, "\n";
}
print "++++++++++++++++++++++++++\nSequenceQuality\tSequenceNumber\n";
foreach my $i (keys %SQual){
    print $i, "\t", $SQual{$i}, "\n";
   $totalQ+= $i * $SQual{$i};
}
print  "$file $totalN reads,  Average Length =", $total/$totalN, " Average Quality Score = ", $totalQ/$totalN, "\n"; 
print  "$file\t$totalN\t", $total/$totalN, "\t", $totalQ/$totalN, "\n"; 


sub change_quality{
    my ($input_string)=@_;
     my @qual=split //, $input_string;
    my $phred_quality_string ="";
    foreach my $this_char (@qual){
	#print STDERR $this_char, "\t";
	# convert illumina scaled phred char to phred quality score
	my $phred_quality = ord($this_char) - 64;
	# convert phred quality score into phred char
	my $phred_char = chr($phred_quality + 33); 
	#print STDERR $phred_char, "\n";
	$phred_quality_string .= $phred_char;
    }
    return $phred_quality_string;
}

sub get_average_quality_score{
    my ($input_string)=@_;
     my @qual=split //, $input_string;
    my $total_score=0;
    my $string_len=length($input_string);
    foreach my $this_char (@qual){

	# convert illumina scaled phred char to phred quality score
	my $phred_quality = ord($this_char) - 64;
	#my $phred_char = chr($phred_quality + 33);
	#print STDERR $this_char, "\t", $phred_quality,"\t",$phred_char,  "\n";
	$total_score+=$phred_quality;
	
    }    
    my $average_score=0;
    if ($string_len>0){
	$average_score=int($total_score/$string_len);
    }
    return $average_score;
}
sub get_average_SANGERquality_score{
    my ($input_string)=@_;
     my @qual=split //, $input_string;
    my $total_score=0;
    my $string_len=length($input_string);
    foreach my $this_char (@qual){

	# convert illumina scaled phred char to phred quality score
	my $phred_quality = ord($this_char) -33;
	# score # ==2
	#print STDERR $this_char, "\t", $phred_quality, "\n";
	$total_score+=$phred_quality;
	
    }    
    my $average_score=0;
    if ($string_len>0){
	$average_score=int($total_score/$string_len);
    }
    return $average_score;
}
