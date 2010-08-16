# collect and interpret 100 samples

perl -e '
	<>;
	map $t{int(<>)}++, 2..300;
	@k = sort keys %t;
	print "\n", map "$t{$_}\t$_\t"."|"x$t{$_}."\n", shift(@k)..pop(@k);
' < /dev/cu.usbmodem12341&
echo "7do0o300{1o0otp20m}" >/dev/cu.usbmodem12341

