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
  int(16*$_[0]);
}

# see http://en.wikipedia.org/wiki/HSL_and_HSV#From_HSV

sub saturate {
  ($bulb, $hue) = @_;
  $h = int($hue);
  $c = br($hue - $h);
  $x = br(1 - ($hue - $h));
  set $bulb, 255, $c, $x, 0 if $h==0;
  set $bulb, 255, $x, $c, 0 if $h==1;
  set $bulb, 255, 0, $c, $x if $h==2;
  set $bulb, 255, 0, $x, $c if $h==3;
  set $bulb, 255, $x, 0, $c if $h==4;
  set $bulb, 255, $c, 0, $x if $h==5;
}

while (1) {
  saturate rn(50)+1, 6*rand();
  select undef, undef, undef, 0.3;
}
