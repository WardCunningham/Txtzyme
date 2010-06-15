# conduct perception experiment
# (apple osx specific implementation)

my $stty = `stty -g`;
my $teensy = '/dev/cu.usbmodem12341';
mkdir 'results' unless -e 'results';

die("can't find teensy\n") unless -e $teensy;
`echo 6d0o >$teensy`;

while () {
	print "enter your initials: ";
	experiment($1) if <> =~ /(\w{2,3})/;
	sleep 3;
	`say next`;
}

sub experiment {
	my ($initials) = @_;
	`stty -icanon -echo`;
	`say ready`;
	`echo trial \`date +%s\` >> results/$initials`;
	for $period (split(/\s+/, `jot -r 10 50 250`)) {
		my $result;
		while() {
			`echo 5{1o${period}m0o${period}m} >$teensy`;
			$result = getc;
			last if $result =~ /[1-9]/;
			`say again`;
		}
		`say good`;
		`echo "$period\t$result" >> results/$initials`;
	}
	`say thank you`;
	`stty $stty`;
}
