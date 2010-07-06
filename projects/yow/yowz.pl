#!/usr/bin/perl
use strict;

# Txtzyme

open T, ">/dev/cu.usbmodem12341" or die($!);
select T; $| = 1;
select STDOUT; $| = 1;
sub tz  { print T "@_\n" or die($!); }
sub led { my ($led) = @_; tz "_led_ 6d $led o"; }

# HDLx-2416 Pins

my @d = ('0b','1b','2b','3b','1d','0d','7b');
sub clr_{ tz "_clr_ 7f 0o 10u 1o"; }
sub cue { my ($cue) = @_; tz "_cue_ 6f $cue o"; }
sub cu_ { my ($cu) = @_; tz "_cu_ 5f $cu o"; }
sub ce_ { my ($ce) = @_; tz "_ce_ 5b $ce o 6b $ce o"; }
sub a   { use integer; my ($a0, $a1) = ($_[0]%2, $_[0]/2); tz "_a_ 0f $a0 o 1f $a1 o"; }
sub d   { use integer; my ($d) = @_; for my $i (0..6) { tz "_d${i}_ $d[$i] ".($d%2)."o"; $d/=2; }}
sub wr_ { tz "_wr_ 4f 0o 1o"; }
sub bl_ { my ($bl) = @_; tz "_bl_ 2d $bl o"; }

# HDLx-2416 Registers

sub ch  { my ($a, $ch) = @_; tz "_ch ${ch}_"; a $a; cue 0; cu_ 1; d ord($ch); wr_; }
sub bri { my ($bri) = @_; tz "_bri ${bri}_"; a 0; cue 0; cu_ 0; d $bri*8; wr_; }

# Initialize (Clear All)

clr_; ce_ 0; bl_ 1;
led 0;

# Application Helpers

sub msg { my @m = split //,@_[0]; ch 3,$m[0]; ch 2,$m[1]; ch 1,$m[2]; ch 0,$m[3]; }
sub txt { my ($t) = @_; for my $i (0..55) { msg (substr $t, $i, 4); tz "_wait_100m" }}

while (1) {

	# Blink-Fade Application

	for my $q (0..9) {
		msg "Yow$q";
		for my $b (0..7) { bri $b; tz "40m" }
	}

	# Scroll Application

	txt "    The quick brown fox jumped over the lazy dogs back.                ";
	txt "    Now is the time for all good men to come to Dorkbot.               ";

	# Clock Application

	for (1..40) {
		msg `date +%M%S`;
		for my $b (0..7) { bri $b; tz "40m" }
		sleep 1;
	}
}
