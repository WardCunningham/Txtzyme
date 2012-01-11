
# Textzyme

open (T, ">/dev/cu.usbmodem123451") or die($!);

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
  return if $bulb > 50 or $bulb < 1;
  start(); bulb($bulb); light($light); color($blue); color($green); color($red); stop();
}

# flash a streak of white one way or the other

sub front { set ($_[0], 255, 15, 15, 15); }
sub back { set ($_[0], 0, 0, 0, 0); }

sub inbound { for $i (0..60) { front (50-$i); back (60-$i); } }
sub outbound { for $i (0..60) { front ($i); back ($i-10); } }

use Fcntl ":flock"; 
flock T, LOCK_EX;

$n = int (rand(6));
inbound() if $n == 0;
outbound() if $n == 1;

# for some reason the above programs leaves 
# the last light sometimes glowing red or blue.
# this logic makes sure it is good 'n out.
# (could it be some buffering issue?)

for (1..5) {
  set(1, 0, 0, 0, 0);
  set(50, 0, 0, 0, 0);
}

flock T, LOCK_UN; 

