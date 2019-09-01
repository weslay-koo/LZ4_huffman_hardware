#! /usr/bin/perl -w
@dirs = ("Cal","Cant");
$pattern = "ComparePattern";

open(SIZE_STAT,'>',"SIZE.stat");
open(BAT_LOG,'>',"BAT.log");

foreach my $dir (@dirs)
{
	opendir(DIR, $dir) || die "Can't open directory $dir";
	my @files = grep(!/\A\.\.?\z/,readdir(DIR));
	print @files;
	
	foreach my $file (sort @files)
	{
		my @info = stat("./$dir/$file");
		printf SIZE_STAT ("$file\t\t=\t\t%d\n",$info[7]);
	}
	
	foreach my $file (sort @files)
	{
		my $file_name = $file;
		$file_name =~ s/\.(\w+)\z//; 
		print("===============================================================\n");
		system("shuffman.exe -d ./$dir/$file ./$file_name.decomp");
		print("===============================================================\n");
	}
}


system("python3 compare.py . ./$pattern");	
open(LOG,'<',"compared.log") or die "compared.log file NOT FOUND\n";
my $error = 0;
my $file_count = 0;
while(<LOG>)
{
	chomp;
	$file_count = $file_count + 1;
	if(/(\w+)is NOT the same\z/)
	{
		print BAT_LOG ("$1 File decompress Error\n");
		$error = 1;
	}
}

close(LOG);

if($error != 1)
{
	print BAT_LOG ("$file_count Huffman File decompression All OK\n");
	
}

print ("Delete Old Files completely\n");


close(SIZE_STAT);
close(BAT_LOG);

system("del compared.log");
#system("del compress.stat");
system("del *.decomp");
