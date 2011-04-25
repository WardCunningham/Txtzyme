# 2b0o 3b1o 7b 1000{ 1o 3m 0o 10m}

use strict;

sub abs {my ($n) = @_; $n >= 0 ? $n : -$n;}
sub min {my ($p, $q) = @_; $p < $q ? $p : $q;}
sub max {my ($p, $q) = @_; $p > $q ? $p : $q;}

sub fwd {
	my ($hi, $lo, $dir) = @_;
	my ($t, $c) = $dir > 0 ? (1,0) : (0,1);
	"$hi${t}o$lo${c}o ";
}


sub run {
	my $p = 1000;
	my ($r, $l) = map(int($p*abs($_)), @_);
	my ($p1, $p2, $p3)  = (min($r,$l), max($r,$l)-min($r,$l), $p-max($r,$l));
	my ($f, $s) = $r > $l ? ('7b','0d') : ('0d','7b'); 
	"10 {${f}1o ${s}1o ${p1}u ${s}0o ${p2}u ${f}0o ${p3}u}";
}

sub go {
	my ($r, $l) = @_;
	#print '4b1o ';
	print fwd '2b', '3b', $r;
	print fwd '3d', '2d', $l;
	#print '4b0o ';
	print run $r, $l;
	print "\n";
}

for my $t (1..1500) {
	go sin($t/30), cos($t/30);
}
