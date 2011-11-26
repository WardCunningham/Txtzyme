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
    my ($x, $y, $i) = @_;
    my ($a, $c) = ($anode[$x], $cathode[$y]);
    putz "${a}1o ${c}0o ${i}u i${a}i";
}

sub box {
    my ($x, $y, $i) = @_;
    $i = int(($i+1.1)*100);
    blink $x, $y, $i;
    blink $x+1, $y, $i;
    blink $x, $y+1, $i;
    blink $x+1, $y+1, $i;
}

# Control Knob

my $prev = '00';
putz "5bi4b1oi6b1oi5b0o";   # b4 -o<---o- b5 -o--->o- b6 shaft encoding
putz "2bi1b1o2b0o";         # b2 -o--->o- b1 push to close

sub twisted {
    my $curr = getz("4bip") . getz("6bip");
    my $delta = 
        ($prev.$curr) =~ /0010|1011|1101|0100/ ? -1 :
        ($prev.$curr) =~ /0001|0111|1110|1000/ ? 1 : 0;
    $prev = $curr;
    $delta;
}

sub pushed {
    !getz "1bip";
}

# Star Throb Application

my @x = (3,6,5,1,0);
my @y = (0,2,6,6,2);
my @t = (0,0,0,0,0);
my @d = (11,25,27,12,17);

my $i = my $ii = 0;

while (1) {
    if (pushed) {
        $i = ($ii = ($ii + twisted + 20) % 20) / 4;
        box $x[$i], $y[$i], 0; 
    } else {
        $d[$i] += twisted;
        for my $j (0..4) {
            $t[$j] += $d[$j] / 100;
            box $x[$j], $y[$j], sin $t[$j];
        }
    }
}


                