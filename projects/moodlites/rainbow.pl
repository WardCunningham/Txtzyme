# Random colors applied to random bulbs, every 1/4 second.

# Textzyme

open (T, ">".`ls /dev/cu.usbmodem*`) or die($!);

# GE G35 control signals
# from http://www.deepdarc.com/2010/11/27/hacking-christmas-lights/

sub start { print T "1o" }
sub zero  { print T "0o1o2u" }
sub one   { print T "0o2u1o" }
sub stop  { print T "0o\n" }

sub bits  { my ($n,$v) = @_; for (my $i=$n-1; $i>=0; $i--) { $v>>$i&1 ? one() : zero() }}
sub bulb  { bits(6, $_[0]) }
sub light { bits(8 ,$_[0]) }
sub color { bits(4, $_[0]) }

sub set {
  my ($bulb, $light, $red, $green, $blue) = @_;
  start(); bulb($bulb); light($light); color($blue); color($green); color($red); stop();
}

sub all {
  my ($red, $green, $blue) = @_;
  for (1..50) { set($_, 255, $red, $green, $blue) }
}

sub rn {
  int($_[0]*rand());
}

sub br {
  # return 0 if $_[0]<0.1;
  int(15.9*$_[0])
}

sub sat {
  ($hue) = @_;
  $h = $hue%360/60.0;
  $n = int($h);
  $f = $h - $n;
  ($up,$hi,$dn, $lo) = ($h-$n, .9999, 1-$h+$n, 0);
  @r = ($hi, $dn, $lo, $lo, $up, $hi);
  @g = ($up, $hi, $hi, $dn, $lo, $lo);
  @b = ($lo, $lo, $up, $hi, $hi, $dn);
  return (br($r[$n]), br($g[$n]), br($b[$n]))
}

$i = 0;
while(1) {
  $i+=5;
  for $bulb (1..50) {
    ($r, $g, $b) = sat($i + 360/20*$bulb);
    set $bulb, 255, $r, $g, $b
  }
  #select undef, undef, undef, 0.3;
}
