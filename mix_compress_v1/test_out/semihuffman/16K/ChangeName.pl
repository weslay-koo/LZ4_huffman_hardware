#! /usr/bin/perl -w
@dirs = ("compare_pattern");

foreach my $dir (@dirs)
{
	opendir(DIR, $dir) || die "Can't open directory $dir";
	my @files = grep(!/\A\.\.?\z/,readdir(DIR));
	print @files;
	foreach my $file (sort @files)
	{
		my $file_name = $file;
		$file_name =~ s/\.(\w+)\z/\.pattern/; 
		system("move .\\$dir\\$file .\\$dir\\$file_name");
	}
}