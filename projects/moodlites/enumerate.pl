open (T, ">/dev/cu.usbmodem123451") or die($!);

sub start { print T "1o" }
sub zero { print T "0o1o2u" }
sub one { print T "0o2u1o" }
sub stop { print T "0o\n" }

sub bits { my ($n,$v) = @_; for (my $i=$n-1; $i>=0; $i--) { $v>>$i&1 ? one() : zero() }}
sub bulb { bits(6, $_[0]) }
sub light { bits(8 ,$_[0]) }
sub color { bits(4, $_[0]) }

sub set {
  my ($bulb, $light, $red, $green, $blue) = @_;
  start(); bulb($bulb); light($light); color($blue); color($green); color($red); stop();
}

for (1..50) { set($_, 255, 0, 0, 15) }

$status = '.'x50;
`echo $status >> heat.log`;
