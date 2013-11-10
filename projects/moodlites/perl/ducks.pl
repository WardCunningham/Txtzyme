
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

my @snr = (0,0,0,0,1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,15,15,15);
my @sn = ();
push(@sn, @snr);
push(@sn, reverse(@snr));
$sn = @sn;
$pn = $sn/2;

sub sn {
  my $n = $_[0]%$sn;
  $sn[$n];
}

sub fade {
  my ($r,$g,$b) = @_;
  for $n (1..$sn) {
    for (1..50) {
      my $pb = $_*3;
      set ($_, 255, sn($pb+$n+$pn*$r), sn(15),sn(0));
    }
  }
}


use Fcntl ":flock"; 
flock T, LOCK_EX;
 
while(1) {
  fade(0,1,2);
}

flock T, LOCK_UN; 

