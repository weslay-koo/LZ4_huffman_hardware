#! /usr/bin/perl -w
#### Must be run in Xilinx CMD SHELL

my @file_num =	(0..28);

my $out_path = ".\\test_out\\semihuffman";

my %dir_name = (	
					"$out_path\\3K"	=>	3072,
					"$out_path\\5K"	=>	5120,
					"$out_path\\6K"	=>	6144,
					"$out_path\\7K"	=>	7168
					#"$out_path\\1K"	=>	1024,
					#"$out_path\\2K"	=>	2048,
					#"$out_path\\4K"	=>	4096,
					#"$out_path\\8K"	=>	8192,
					#"$out_path\\16K"=>	16384,
					#"$out_path\\32K"=>	32768,
					#"$out_path\\64K"=>	65536
				);

foreach my $dir (sort keys %dir_name)
{
	foreach my $num (@file_num)
	{
		my $stat_length = $dir_name{$dir} + 0;
		my $number 		= $num + 0;
		my $arg_32bit 	= $stat_length*256 + $number;
		print("===============================================================\n");
		system("mix_compression_top_tb_isim_beh.exe -tclbatch autosim.tcl -testplusarg NO=$arg_32bit");
		print ("$num file has been tested\n");
		print("===============================================================\n");
	}
	system("ls $out_path");
	system("mv $out_path\\*.shuff $dir\\");
	system("mv $out_path\\*.simlog $dir\\");
	print ("Test output has been MOVED\n");
}

