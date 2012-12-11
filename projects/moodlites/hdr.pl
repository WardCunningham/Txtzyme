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

sub max {
  my ($max, @vars) = @_;
  for (@vars) {
    $max = $_ if $_ > $max;
  }
  return $max;
}

sub sethdr {
  my ($bulb, $red, $green, $blue) = @_;
  my $light = max $red, $green, $blue;
  return set $bulb, 0, 0, 0, 0 if $light == 0;
  my ($r, $g, $b) = map int(255.0/$light*$_/16), ($red, $green, $blue);
  set $bulb, $light, $r, $g, $b;
}

sub rn {
  int($_[0]*rand());
}

sub sc {
  return int($_[0]/16);
}

while (1) {
  $_ =`cat /Users/ward/g35/color`;
  ($r, $g, $b) = /(\d+)/g;
  for $bulb (1..50) {
    if ($bulb/3 % 2) {
      set $bulb, 255, sc($r), sc($g), sc($b);
    } else {
      sethdr $bulb, $r, $g, $b;
    }
  }
  select undef, undef, undef, 0.1;
}
