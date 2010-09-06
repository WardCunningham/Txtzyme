#!/usr/bin/perl
# while sleep .5; do perl test.pl; done

use strict;

# Teensy (Unbuffered)

open T, "+>/dev/cu.usbmodem12341" or die($!);
select T; $| = 1;
select STDOUT; $| = 1;

# Txtzyme

sub putz { local $_; print T map "$_\n", @_ or die($!) }
sub getz { local $_; putz @_; $_ = <T>; $_ =~ s/\r?\n?$//; $_ }
putz "_ok_"; $_ = getz until /ok/;

# Bi-Color LED (between B0, B1)

sub red { putz "1bo" }
sub grn { putz "0b1o" }
sub off { putz "1b0obo" }
off;

# One-Wire Protocol (on pin F6, pwr F7, gnd F5)

my $pin = "7d";
putz "${pin}1o5f0o";
sub rst { getz "${pin}0o480ui60uip420u" }
sub wr { putz $_[0] ? "${pin}0oi60u" : "${pin}0o60ui" }
sub w8 { my ($b) = @_; for (0..7) { wr($b&1); $b /= 2; } }
sub rd { getz "${pin}0oiip45u" }
sub r8 { my $b = 0; for (0..7) { $b |= (rd()<<$_) } return $b }
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

sub temp_c { all_cnvt; 0.0625 * one_data }
sub temp_f { 32 + 1.8 * temp_c }

# ROM Search

my @st = ();
do {
    my @at = ();
    my @pr = ();
    print "reset: ", rst, "\n";
    srom;
    my @nx = ();
    while ((scalar @at) < 48) {
        my $lo = rd;
        my $hi = rd;
        push @pr, 2*!$hi+!$lo;
        my $x = (scalar @st) ? shift @st : $lo;
        wr $x;
        @nx = (@at,1) if !$x && !$hi;
        push @at, $x
    }
    @st = @nx;
    print "pr: ", @pr, "\n";
    print "at: ", @at, "\n";
    print "st: ", @st, "\n";
    print "\n";
} while(@st);

# Read ROM for single device

# rst;
# rrom;
# printf "family: %x\n", r8;
# printf "serial: %x\n", r 6;
# printf "check: %x\n", r8;

# Search ROM

# Show rising (red) and falling (green) temps

# my ($old, $new) = (0, 0);
# while (1) {
#     ($old, $new) = ($new, temp_c());
#     printf "%3.5f c\n", $new;
#     off;
#     red if $new > $old;
#     grn if $old > $new;
# }


