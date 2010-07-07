#!/usr/bin/perl
use strict;

# Teensy (Unbuffered)

open T, "+>/dev/cu.usbmodem12341" or die($!);
select T; $| = 1;
select STDOUT; $| = 1;

# Txtzyme

sub tz  { print T "@_\n" or die($!); }
sub led { my ($led) = @_; tz "6d $led o"; }

# HDLx-2416 Pins

my @d = ('0b','1b','2b','3b','1d','0d','7b');
sub clr_{ tz "7f 0o 10u 1o"; }
sub wr_ { tz "4f 0o 1o"; }
sub cue { my ($cue) = @_; tz "6f $cue o"; }
sub cu_ { my ($cu) = @_; tz "5f $cu o"; }
sub ce_ { my ($ce) = @_; tz "5b $ce o 6b $ce o"; }
sub bl_ { my ($bl) = @_; tz "2d $bl o"; }
sub a   { use integer; my ($a0, $a1) = ($_[0]%2, $_[0]/2); tz "0f $a0 o 1f $a1 o"; }
sub d   { use integer; my ($d) = @_; for my $i (0..6) { tz "$d[$i] ".($d%2)."o"; $d/=2; }}

# HDLx-2416 Registers

sub ch  { my ($a, $ch) = @_; a $a; cue 0; cu_ 1; d ord($ch); wr_; }
sub bri { my ($bri) = @_; a 0; cue 0; cu_ 0; d $bri*8; wr_; }

# Initialize (Clear All)

clr_; ce_ 0; bl_ 1;
led 0;

# Application Helpers

sub msg { my @m = split //,@_[0]; ch 3,$m[0]; ch 2,$m[1]; ch 1,$m[2]; ch 0,$m[3]; }
sub txt { my ($t) = @_; for my $i (0..60) { msg (substr $t, $i, 4); tz "_wait_100m" }}
sub syn { tz "_syn_"; while (1) {last if <T> =~ /syn/}}

while (1) {

	# Blink-Fade Application

	for my $q (0..9) {
		msg "Yow$q";
		for my $b (0..7) { bri $b; tz "40m" }
	}
	sleep 4;

	# Scroll Application

	txt "    The quick brown fox jumped over the lazy dogs back.                ";
	txt "    Now is the time for all good men to come to Dorkbot.               ";

	# Clock Application

	syn;
	for (1..20) {
		msg `date +%M%S`;
		for my $b (0..7) { bri 7-$b; tz "40m" }
		for my $b (0..7) { bri $b; tz "40m" }
		sleep 1;
	}
}
