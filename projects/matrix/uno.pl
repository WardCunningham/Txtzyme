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
    putz "${a}1o ${c}0o 50u i ${a}i";
}

sub rn {
    rand(2)+rand(2)+rand(2)+rand(2);
}

for (my $t=0; ; $t+=.0002) {
    blink
        rn() + 3*sin(7.7*$t),
        rn() + 3*cos(3.1*$t);
}

