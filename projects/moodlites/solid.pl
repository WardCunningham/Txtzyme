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

sub rn {
  int($_[0]*rand());
}

sub sc {
  return int($_[0]/16);
}

@bulbs = [];
for (1..50) {
  push @bulbs, "0,0,0";
}

sub writeBulbs {
  open B, '>/Users/ward/g35/newBulbs';
  print B @bulbs;
  close B;
  rename '/Users/ward/g35/newBulbs', '/users/ward/g35/bulbs';
}

while (1) {
  $_ =`cat /Users/ward/g35/color`;
  push @bulbs, $_;
  shift @bulbs;
  for $bulb (1..50) {
    ($r, $g, $b) = $bulbs[51-$bulb] =~ /(\d+)/g;
    set $bulb, 255, sc($r), sc($g), sc($b);
  }
  writeBulbs();
  select undef, undef, undef, 0.1;
}
