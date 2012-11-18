
# Textzyme

open (T, ">".`ls /dev/cu.usbmodem*`) or die($!);

# GE G35 control signals
# from http://www.deepdarc.com/2010/11/27/hacking-christmas-lights/

sub start { print T "1o" }
sub zero  { print T "0o1o2u" }
sub one   { print T "0o2u1o" }
sub stop  { print T "0o20m\n" }

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
  $rn = @rn = (0, 1, 3, 7, 15);
  $rn[rand($rn)];
}

sub every {
  for (1..50) {set($_, 255, rn(),rn(),rn()) }
  for (1..50) {set(52-$_, 255, rn(),rn(),rn()) }
}


use Fcntl ":flock"; 
flock T, LOCK_EX;
 
every();

flock T, LOCK_UN; 

