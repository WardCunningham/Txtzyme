my %tally;
my $binsize = $ARGV[0] || 1;
print "bin: $binsize\n";

for (<results*/*>) {
	my @lines = `cat $_`;
	for (@lines) {
		next unless /(\d+)\t(\d)/;
		my $t = $1 - ($1 % $binsize);
		$tally{"$t $2"}++;
	}
}

print "\t", join("\t", 1..9), "\n\n";
for (my $t=50-(50 % $binsize); $t<=250; $t+=$binsize) {
	print $t, "\t";
	for my $c (1 .. 9) {
		print $tally{"$t $c"}, "\t";
	}
	print "\n";
}