
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
sub light { bits(8 ,$_[0] < 0 ? 0 : $_[0] > 255 ? 255 : $_[0] ) }
sub color { bits(4, $_[0] < 0 ? 0 : $_[0] > 15 ? 15: $_[0] ) }

sub set {
  my ($bulb, $light, $red, $green, $blue) = @_;
  return if $bulb > 50 or $bulb < 1;
  start(); bulb($bulb); light($light); color($blue); color($green); color($red); stop();
}

use Fcntl ":flock"; 
flock T, LOCK_EX;

my $cen = int(rand(50));
my @col = (15, 5, 0);
my $r = 7;
for (0..$r) {
	set ($cen+$_, 255, $col[0]-$_, $col[1]-$_, $col[2]-$_);
        set ($cen-$_, 255, $col[0]-$_, $col[1]-$_, $col[2]-$_);
}

for (0..$r) {
        set ($cen+$r-$_, 15, 1, 1, 1);
        set ($cen-$r+$_, 15, 1, 1, 1);
        print T "40m";
}

for $l (0..5) {
	for (0..30) {
		set ($cen+(int(rand(2*$r)-$r)), 15-(3*$l), 1, 1, 1);
	}
}

for (0..$r) {
        set ($cen+$r-$_, 255, 0, 0, 0);
        set ($cen-$r+$_, 255, 0, 0, 0);
	print T "40m";
}
for (0..5) {
	set ($cen, 0, 0, 0, 0);
}

flock T, LOCK_UN; 
