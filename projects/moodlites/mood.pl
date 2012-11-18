exit;

# Textzyme

open (T, ">".`ls /dev/cu.usbmodem*`) or die($!);

# GE G35 control signals
# from http://www.deepdarc.com/2010/11/27/hacking-christmas-lights/

sub start { print T "1o" }
sub zero  { print T "0o1o2u" }
sub one   { print T "0o2u1o" }
sub stop  { print T "0o100m\n" }

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


# SensorServer json (furnace plenum code c19356)

`/usr/bin/curl -s guest:please\@jd.local:4567/one/5d` =~ /"c19356":\s*(\d+),/;
my $heat = sprintf("%.1f", ($1/16.0)*9/5+32);

# Select one bulb and set color based on furnace temperature

my $bulb = int(rand(50))+1;

use Fcntl ":flock"; 
flock T, LOCK_EX;
 
if (-f 'next.txt') { all($c[0], $c[1], $c[2]) if @c = split(/\./, `cat next.txt; rm next.txt`); $show = "next" }
elsif ($heat > 90) { set($bulb, 255, 15, 0, 0); $show = "red"; }
elsif ($heat > 70) { set($bulb, 255, 0, 15, 0); $show = "green"; }
else               { set($bulb, 255, 0, 0, 15); $show = "blue"; }

flock T, LOCK_UN; 

my $now = localtime;
print "$now\t$heat\t$bulb\t$show\n"
