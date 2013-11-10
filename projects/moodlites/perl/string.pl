use strict;

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

sub snooze {
  my ($sec) = @_;
  select undef, undef, undef, $sec;
}

sub br {
  int(15.9*$_[0]);
}

sub sat { # see http://en.wikipedia.org/wiki/HSL_and_HSV#From_HSV
  my ($hue) = @_;
  my $h = $hue%360/60.0;
  my $n = int($h);
  my $f = $h - $n;
  my ($up,$hi,$dn, $lo) = ($h-$n, .9999, 1-$h+$n, 0);
  my @r = ($hi, $dn, $lo, $lo, $up, $hi);
  my @g = ($up, $hi, $hi, $dn, $lo, $lo);
  my @b = ($lo, $lo, $up, $hi, $hi, $dn);
  return (br($r[$n]), br($g[$n]), br($b[$n]))
}



my @r = 0..49;
my @s=map(rand(),@r);
my @c = split '', ' .+omMmo+.';

sub pull {
  my ($to, $on) = @_;
  ($to - $on) / 3;
}

sub delta {
  my ($r) = @_;
  my ($left, $right) = (($r+1)%50, ($r+50-1)%50);
  my $pull = pull ($s[$left], $s[$r]) + pull ($s[$right], $s[$r]);
  my $noise = (2*rand()-rand())/50;
  $pull*1.48 + $noise;
}

sub roll {
  my ($s) = @_;
  $s+10 - int($s+10);
}

sub sim {
  my @d = map delta($_), @r;
  # print join(" ",@d), "\n\n";
  @s = map roll($s[$_]+$d[$_]), @r;
}

sub show {
  for my $bulb (1..50) {
    my ($r,$g,$b) = sat $s[$bulb-1]*360;
    set $bulb, 255, $r, $g, $b;
  }
}

for my $t (1..2000) {
  #print join(" ",map($c[int(10*$_)],@s)),"\n";
  sim;
  sim;
  show;
  #snooze .2;
}
