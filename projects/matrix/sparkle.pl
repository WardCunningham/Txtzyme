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

# my @cathode = qw( 4c 5f 4f 1c 2f 2c 6c 7c ); # original
# my @anode = qw( 0c 5c 0f 3c 7f 1f 6f 3f );

my @cathode = qw( 0f 5f 0c 3f 7c 1c 6c 3c ); # flipped
my @anode = qw( 4f 5c 4c 1f 2c 2f 6f 7f );



sub blink {
    my ($x, $y) = (int($_[0]), int($_[1]));
    return if $x<0 or $x>7 or $y<0 or $y>7;
    my ($a, $c) = ($anode[$x], $cathode[$y]);
    putz "${a}1o ${c}0o 50u i ${a}i";
}

start:

# # Step
#
# for my $y (0..7) {
#     for my $x (0..7) {
#         for my $t (0..2000) {
#             blink $x, $y;
#         }
#     }
# }

# Flat

for my $t (0..200) {
    for my $y (0..7) {
        for my $x (0..7) {
            blink $x, $y;
        }
    }
}

# Random

for (1..20000) {
    blink rand(8), rand(8);
}

# Fuzzy

for (1..50000) {
    my $x = rand(2)+rand(2)+rand(2)+rand(2) + 2*sin($_/500.0);
    my $y = rand(2)+rand(2)+rand(2)+rand(2) + 2*cos($_/500.0);
    blink $x, $y;
}

# Spin

for (1..8000000) {
    my ($r,$t,$w) = $_%4 ?
        (rand(4.5)-1.5, -$_/100000.0, .3):
        (rand(1.5)+2.5, -$_/100000.0/12, .3);
    blink 
        4+$r*sin($t)+rand($w)-rand($w),
        4+$r*cos($t)+rand($w)-rand($w);
}

goto start;
