# collect and interpret 100 samples

perl -e '
	map $t{<>}++, 1..100;
	print "\n", map "$t{$_}\t$_", sort keys %t;
' < /dev/cu.usbmodem12341&
echo "7do0o100{1o0otp20m}" >/dev/cu.usbmodem12341

