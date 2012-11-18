
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

# Performance (Stars and Stripes)

my $pat = 'wwwwwrrrrrwwwwwrrrrrwwwwwrrrrrwwwwwrrrrrwwwwwbbbbbwwwbbbbbwwwbbbbbwwwbbbbb';
my %rgb = ('w' => '15,15,15', 'r' => '15,0,0', 'b' => '0,0,15');

sub perform {
  for my $seq (0..(length($pat)-1)) {
    for my $bulb (1..50) {
      my $ch = substr($pat, ($seq+$bulb)%length($pat), 1);
      $rgb{$ch} =~ /(\d+),(\d+),(\d+)/;
      set ($bulb, 255, $1, $2, $3);
    }
  }
}

# Control Loop

use Fcntl ":flock"; 
while(1) {
  flock T, LOCK_EX;
  perform();
  flock T, LOCK_UN;
}

