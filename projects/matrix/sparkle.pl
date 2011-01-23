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

# my @anode = qw( 4c 5f 4f 1c 2f 2c 6c 7c ); # original
# my @cathode = qw( 0c 5c 0f 3c 7f 1f 6f 3f );

my @anode = qw( 4f 5c 4c 1f 2c 2f 6f 7f ); # flipped (c for f)
my @cathode = qw( 0f 5f 0c 3f 7c 1c 6c 3c );

sub blink {
    my ($x, $y) = (int($_[0]), int($_[1]));
    return if $x<0 or $x>7 or $y<0 or $y>7;
    my ($a, $c) = ($anode[$x], $cathode[$y]);
    putz "6d0o ${a}1o ${c}0o 50u i ${a}i 6d1o";
}

start:

# Step

for my $y (0..7) {
    for my $x (0..7) {
        for my $t (0..300) {
            blink $x, $y;
        }
    }
}
for my $y (0..7) {
    for my $x (0..7) {
        for my $t (0..300) {
            blink $y, 7-$x;
        }
    }
}


# Paint

for my $y (0..7) {
    for my $x (0..7) {
        for my $t (0..300) {
            blink 7-$x, 7-$y unless $t%($y+1);
            my ($xx, $yy) = ($t%8, 7-$t/8%($y+1));
            blink $xx, $yy unless $xx < 7-$x and $yy == 7-$y;
        }
    }
}

# Flat

for my $t (0..100) {
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

# Paper Tape

my @s = (0,0,0,0,0,0,0,0);
for (0..7) {
    $s[$_] = rand(256);
}
for my $t (0..200) {
    for (0..3) {
        for my $y (0..7) {
            my $s = $s[$y];
            for my $x (0..7) {
                blink $y,$x if $s%2;
                $s /= 2;
            }
        }
    }
    for (0..6) {
        $s[7-$_] = $s[6-$_];
    }
    $s[0] = rand(256);
}

# Rain

my (@x,@y,@v) = ((),(),());
for my $i (0..10) {
    push(@x, rand(8));
    push(@y, rand(8));
    push(@v, (1+rand(1))/20);
}
for my $t (0..3000) {
    for my $i (0..$#y) {
        if ($y[$i]>10) {
            $x[$i] = rand(8);
            $y[$i] = 0;
            $v[$i] = (1+rand(1))/20;
        } else {
            $y[$i] = $y[$i]+$v[$i];
        }
        blink $y[$i]-rand(2), $x[$i];
    }
}

# Less Flat

for (1..20000) {
    blink rand(4)+rand(4), rand(4)+rand(4);
}

# Circle

for my $t (0..31415) {
    my $r = 2 + sin($t/1000) + rand(1);
        blink 4+$r*sin($t), 4+$r*cos($t);
}

# Fuzzy

for (1..31415) {
    my $r = $_ / 10000;
    my $x = rand(2)+rand(2)+rand(2)+rand(2) + $r*sin($_/500.0);
    my $y = rand(2)+rand(2)+rand(2)+rand(2) + $r*-cos($_/500.0);
    blink $x, $y;
}

# Spin

for (1..(3141*6)) {
    my ($r,$t,$w) = (rand(4.5)-1.5, -$_/1000.0, .7 );
    blink
        4+$r*sin($t)+rand($w)-rand($w),
        4+$r*cos($t)+rand($w)-rand($w);
}
for (1..3141*24) {
    my ($r,$t,$w) = $_%4 ?
        (rand(4.5)-1.5, -$_/1000.0, .5):
        (rand(1.5)+2.5, -$_/1000.0/12, .3);
    blink
        4+$r*sin($t)+rand($w)-rand($w),
        4+$r*cos($t)+rand($w)-rand($w);
}

# Star

for my $t (0..31415) {
    my $r = 3 * sin(3.002 * $t) + rand(.5);
        blink 4+$r*sin($t), 4+$r*cos($t);
}
for my $t (0..31415) {
    my $r = ($t/5000) + 3 * sin(3.002 * $t) + rand(.3);
        blink 4+$r*sin($t), 4+$r*cos($t);
}

goto start;
