$| = 1;
$div = $ENV{'DIV'} || 4;
%c = (r => 31, g => 32, b => 34, n => 30);

for (1..50) {
	$b{$_} = " ";
}

for (<>) {
	@_ = split(/\t/, $_);
	$n = 51 - $_[2];
	$b{$n} = substr($_[3], 0, 1); 
	next if ($l++) % $div;
	print "$_[0]\t";
	p();
}

sub p {
	for (1..50) {
		print "  " if $_ == 16 || $_ == 31;
		$b = $b{$_};
		$c = $c{$b};
		print "\033[${c}m$b\033[30m ";
	}
	print "\n";
}
