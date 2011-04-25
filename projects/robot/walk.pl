use strict;

sub abs {my ($n) = @_; $n >= 0 ? $n : -$n;}
sub min {my ($p, $q) = @_; $p < $q ? $p : $q;}
sub max {my ($p, $q) = @_; $p > $q ? $p : $q;}

sub fwd {
	my ($hi, $lo, $dir) = @_;
	my ($t, $c) = $dir > 0 ? (1,0) : (0,1);
	"$hi${t}o$lo${c}o ";
}

sub usec {
	my ($t) = @_;
	$t > 0 ? $t.'u' : '';
}

sub run {
	my $p = 1000;
	my ($r, $l) = map(int($p*abs($_)), @_);
	my $p1 = usec(min($r,$l));
	my $p2 = usec(max($r,$l)-min($r,$l));
	my $p3 = usec($p-max($r,$l));
	my ($f, $s) = $r > $l ? ('7b','0d') : ('0d','7b'); 
	"10 {${f}1o ${s}1o $p1 ${s}0o $p2 ${f}0o $p3}";
}

sub go {
	my ($r, $l) = @_;
	#print '4b1o ';
	print fwd '2b', '3b', -$r;
	print fwd '3d', '2d', $l;
	#print '4b0o ';
	print run $r, $l;
	print "\n";
}

my %p;
$p{'f'} = '100 1 1';
$p{'b'} = '100 -1 -1';
$p{'l'} = '75 1 -1';
$p{'r'} = '75 -1 1';

for ($ARGV[0] =~ /./g) {
	my ($time, $right, $left) = split ' ', $p{$_};
	for my $t (1..$time) { go $right, $left; }
}
