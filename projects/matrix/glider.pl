#!/usr/bin/perl
use strict;

# Teensy

open T, "+>/dev/cu.usbmodem12341" or die($!);
select T; $| = 1;
select STDOUT; $| = 1;

# Txtzyme

sub putz { local $_; print T map "$_\n", @_ or die($!); }
sub getz { local $_; putz @_; $_ = <T>; $_ =~ s/\r?\n?$//; $_ }

# NFM-12883

my @anode = qw( 4c 5f 4f 1c 2f 2c 6c 7c ); # original
my @cathode = qw( 0c 5c 0f 3c 7f 1f 6f 3f );

# my @anode = qw( 4f 5c 4c 1f 2c 2f 6f 7f ); # flipped (c for f)
# my @cathode = qw( 0f 5f 0c 3f 7c 1c 6c 3c );

sub blink {
    my ($x, $y) = (int($_[0]), int($_[1]));
    return if $x<0 or $x>7 or $y<0 or $y>7;
    my ($a, $c) = ($anode[$x], $cathode[$y]);
    putz "6d0o ${a}1o ${c}0o 50u i ${a}i 6d1o";
}

my @g = (
    0b0100, 0b0010, 0b1110, 0b0000,
    0b0000, 0b1010, 0b0110, 0b0100,
    0b0000, 0b0010, 0b1010, 0b0110,
    0b0000, 0b0100, 0b0011, 0b0110,
);

for my $t (0..10) {
    for my $p (0..3) {
        for (0..100) {
            for my $r (0..3) {
                my $i = $g[4*$p+$r];
                for my $c (0..3) {
                    blink ($t+$c)%8, ($t+$r)%8 if $i/(2**$c)%2;
                }
            }
        }
    }
}
                