$n = 12;
for (<>) {
	($a,$b,$c) = /(\d+\.\d)\s+(\d+\.\d)\s+(\d+\.\d)/m;
	$x += $a+$b+$c;
	next if ++$i % $n;
	$t = $x/($n*3);
	printf("%1.2f\t%s\n", $t, "|" x int(($t-57)*20));
	$x = 0;
}
