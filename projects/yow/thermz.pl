#!/usr/bin/perl
use strict;

# Teensy (Unbuffered)

open T, "+>/dev/cu.usbmodem12341" or die($!);
select T; $| = 1;
select STDOUT; $| = 1;

# Txtzyme

sub tz  { print T "@_\n" or die($!); }
sub led { my ($led) = @_; tz "6d $led o"; }
led 0;

sub putz { local $_; print T map "$_\n", @_ or die($!) }
sub getz { local $_; putz @_; $_ = <T>; $_ =~ s/\r?\n?$//; $_ }
putz "_ok_"; $_ = getz until /ok/;

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
clr_; ce_ 0; bl_ 1;

# HDLx-2416 Registers

sub ch  { my ($a, $ch) = @_; a $a; cue 0; cu_ 1; d ord($ch); wr_; }
sub bri { my ($bri) = @_; a 0; cue 0; cu_ 0; d $bri*8; wr_; }

# One-Wire Protocol (on pin D5, pwr VCC, gnd C7)

my $pin = "5d";
putz "${pin}1o7c0o";

sub rst { getz "${pin}0o480ui60uip420u" }
sub wr { putz $_[0] ? "${pin}0oi60u" : "${pin}0o60ui" }
sub w8 { my ($b) = @_; for (0..7) { wr($b&1); $b /= 2; } }
sub rd { getz "${pin}0oiip45u" }
sub r8 { led 1; my $b = 0; for (0..7) { $b |= (rd()<<$_) } led 0; return $b }
sub r { my $n = 0; for my $i (0..($_[0]-1)) {$b += (r8() << 8*$i)} $b }

# DS18B20 Thermometer Functions

sub skip { w8 0xCC }
sub cnvt { w8 0x44 }
sub data { w8 0xBE }
sub rrom { w8 0x33 }
sub srom { w8 0xF0 }

# DS18B20 Thermometer Transactions (single device)

sub all_cnvt { rst; skip; cnvt; putz "750m" }
sub one_cnvt { rst; skip; cnvt; {} until rd }
sub one_data { rst; skip; data; my $c = r8; $c += 256 * r8 }

sub temp_c { one_cnvt; 0.0625 * one_data }
sub temp_f { 32 + 1.8 * temp_c }

# Application Helpers

sub msg { my @m = split //,$_[0]; ch 3,$m[0]; ch 2,$m[1]; ch 1,$m[2]; ch 0,$m[3]}
sub txt { my ($t) = @_; for my $i (0..60) { msg (substr $t, $i, 4); tz "_wait_100m" }}
sub syn { tz "_syn_"; while (1) {last if <T> =~ /syn/}}

msg sprintf "%4.1f", temp_f while 1; 
