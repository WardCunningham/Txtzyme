my %tally;
for (<results*/*>) {
	my @lines = `cat $_`;
	for (@lines) {
		next unless /(\d+)\t(\d)/;
		$tally{"$1 $2"}++;
	}
}

print "\t", join("\t", 1..9), "\n\n";
for my $t (50 .. 250) {
	print $t, "\t";
	for my $c (1 .. 9) {
		print $tally{"$t $c"}, "\t";
	}
	print "\n";
}