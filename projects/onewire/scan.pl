#!/usr/bin/perl
use strict;

# Teensy (Unbuffered)

open T, "+>/dev/cu.usbmodem12341" or die($!);
select T; $| = 1;
select STDOUT; $| = 1;

# Txtzyme

sub putz { local $_; print T map "$_\n", @_ or die($!) }
sub getz { local $_; putz @_; $_ = <T>; $_ =~ s/\r?\n?$//; $_ }
putz "_ok_"; $_ = getz until /ok/;

# One-Wire Protocol

my $pin = "7d";
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
sub mrom { w8 0x55 }

# DS18B20 Thermometer Transactions (single device)

sub all_cnvt { rst; skip; cnvt; }
sub one_cnvt { rst; skip; cnvt; {} until rd }
sub one_data { rst; skip; data; my $c = r8; $c += 256 * r8 }

sub temp_c { all_cnvt; 0.0625 * one_data }
sub temp_f { 32 + 1.8 * temp_c }


# Application: read temps in SensorServer compatible format

my @pins = ('7d', '5d', '4d', '3d');
@pins = ($1) if $ENV{QUERRY_STRING} =~ /\bpin=(\d[abcdef])/;
sub b2d {oct "0b" . reverse @_}

# start convert on all pins

for (@pins) {
    $pin = $_;
    all_cnvt;
}
sleep 1;

# search for devices on all pins

print "{\n";
for (@pins) {
    $pin = $_;
    print "\"$_\":\t{\n";

    my @st = ();
    do {

        # find next device

        my @at = ();
        !rst or die "no devices on $pin";
        srom;
        my @nx = ();
        while ((scalar @at) < 64) {
            my $lo = rd;
            my $hi = rd;
            my $x = (scalar @st) ? shift @st : $lo;
            wr $x;
            @nx = (@at,1) if !$x && !$hi;
            push @at, $x
        }
        die("no pullup on $pin") unless b2d @at[0..30];
        @st = @nx;

        # get converted temperature

        my $code =  "c" . b2d (@at[8..23]);
        rst;
        #select device -------------
        mrom;
        map wr($_), @at;
        #read temp ------------
        data; my $c = r8; $c += 256 * r8;
        $c = $c-2**16 if $c>=2**15;
        my $sep = @st ? ',' : '';
        print "\t\"$code\":   $c$sep\n";

    } while(@st);
    my $sep = $pin != $pins[-1] ? ',' : '';
    print "}$sep\n";
}
print "}\n";

