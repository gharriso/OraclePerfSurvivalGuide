$blocksize=8096; 
while (<>) {
	if ($_=~/WAIT #(.*) nam='direct path(.*)temp'(.*)ela=(.*)file(.*)cnt=(.*)obj#=(.*)/)
	{

		 $count++; 
		 $ela+=$4; 
		 $blocks+=$6; 
	}
}
printf("%-20s %10d\n","Total temp IO waits",$count); 
printf("%-20s %10d\n","Elasped Microseconds",$ela);
printf("%-20s %10d\n","Total blocks",$blocks);
printf("%-20s %10d\n","Average blocks",$blocks/$count);
printf("%-20s %10d\n","Microseconds/block",$ela/$blocks);
printf("%-20s %10.4f\n","Microseconds/byteRW",$ela/$blocks/$blocksize);

print "\nNB: assuming blocksize of $blocksize\n"; 
 
