#! /usr/bin/perl -w
@dirs = ("Calgary","Cantrbry");
@steps=	("1K","2K","4K","8K","16K","32K","64K");

open(BAT_STAT,'>',"BAT.stat");
open(BAT_LOG,'>',"BAT.log");

foreach my $dir (@dirs)
{
	opendir(DIR, $dir) || die "Can't open directory $dir";
	my @files = grep(!/\A\.\.?\z/,readdir(DIR));
	print @files;
	foreach my $step (@steps)
	{
		foreach my $file (sort @files)
		{
			my $file_name = $file;
			$file_name =~ s/\.(\w+)\z//; 
			print("===============================================================\n");
			system("semihuffman.exe -s $step ./$dir/$file ./$dir/$file_name.shuff");
			print("===============================================================\n");
			system("semihuffman.exe -d ./$dir/$file_name.shuff ./$dir/$file_name.decomp");
			print("===============================================================\n");
		}
		system("python3 file_compare.py ./$dir");	
		open(LOG,'<',"compared.log") or die "compared.log file NOT FOUND\n";
		my $error = 0;
		while(<LOG>)
		{
			chomp;
			if(/(\w+)is NOT the same\z/)
			{
				print BAT_LOG ("$1 File decompress Error\n");
				$error = 1;
			}
		}
		if($error != 1)
		{
			print BAT_LOG ("$step Huffman File decompression All OK\n");
		}
		
		
		open(STAT,'<',"compress.stat") or die "compress.stat file NOT FOUND\n";
		print BAT_STAT "************** $step *******************\n";
		while(<STAT>)
		{
			chomp;
			if(m/(\w+).lz4/)
			{
				$file_name = $1;
			}
			if(m/RC=(0|1)(.)(\d+)\z/)
			{
				my $ratio = $1 + 0;
				my $temp  = $3 + 0;
				$ratio = $ratio*100 + $temp/100;
				printf BAT_STAT ("$file_name\t\tRC = %0.2f\n",$ratio);
			}
		}
		close(STAT);
		close(LOG);
		system("del compared.log");
		system("del compress.stat");
		system("del $dir\\*.shuff");
		system("del $dir\\*.decomp");
		print ("Delete Old Files completely\n");
	}
}
close(BAT_STAT);
close(BAT_LOG);