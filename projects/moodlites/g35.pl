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

sub rn {
  int($_[0]*rand());
}

sub snooze {
  my ($sec) = @_;
  select undef, undef, undef, $sec;
}



# Like normal.pl (from program)

sub br {
  return 0 if $_[0]<0.3;
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

my @bulb = 1..50;

sub shuffle {
  for (0..49) {
    my $n = rn(50);
    ($bulb[$_], $bulb[$n]) = ($bulb[$n], $bulb[$_]);
  }
}

sub flicker {
  my ($hue, $dev) = @_;
  shuffle();
  for my $bulb (@bulb) {
    my ($r, $g, $b) = sat($hue+rn($dev));
    set $bulb, 255, $r, $g, $b;
    snooze 0.05;
  }
}

my $program = 0;
sub program {
  return snooze(.5) if $program++ % 10;
  my $dev = (`cat /Users/ward/g35/program` - 1) * 360 / 5;
  flicker rn(360), $dev
}



# like solid.pl (from color)

sub sc {
  return int($_[0]/16);
}

my @bulbs = [];
for (1..50) {
  push @bulbs, "0,0,0";
}

sub writeBulbs {
  open B, '>/Users/ward/g35/newBulbs';
  print B @bulbs;
  close B;
  rename '/Users/ward/g35/newBulbs', '/users/ward/g35/bulbs';
}

sub solid {
  $_ =`cat /Users/ward/g35/color`;
  push @bulbs, $_;
  shift @bulbs;
  for my $bulb (1..50) {
    my ($r, $g, $b) = $bulbs[51-$bulb] =~ /(\d+)/g;
    set $bulb, 255, sc($r), sc($g), sc($b);
  }
  writeBulbs;
  snooze 0.1;
}



# choose based on file activity

sub perform {
  my $program = -M '/Users/ward/g35/program';
  my $color = -M '/Users/ward/g35/color';
  if ($program < $color) {
    program;
  } else {
    solid;
  }
}

while (1) {
  perform;
}