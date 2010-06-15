while () {
	`open instructions.rtf`;
	print "enter your initials: ";
	&experiment($1) if <> =~ /(\w{2,3})/;
	sleep 3;
	`say next`;
}

sub experiment {
	my ($initials) = @_;
	`say ready`;
	`echo trial \`date +%s\` >> results/$initials`;
	for $period (split(/\s+/, `jot -r 10 50 150`)) {
		my $result;
		while() {
			$result = &trial($period);
			last if $result =~ /[1-9]/;
			`say again`;
		}
		`say good`;
		`echo "$period\t$result" >> results/$initials`;
	}
	`say thank you`;
}

sub trial {
	my ($period) = @_;
	`echo 5{1o${period}m0o${period}m} > /dev/cu.usbmodem12341`;
	return `sh keystroke.sh`;
}