
# Open unbuffered bidirectional serial Teensy connection
open T, '+</dev/cu.usbmodem12341' or die($!);
select T; $| = 1;
select STDOUT; $| = 1;

# Read and Write Txtzyme
sub putz { local $_; print T map "$_\n", @_ or die($!) }
sub getz { local $_; putz @_; $_ = <T>; $_ =~ s/\r?\n?$//; $_ }

# Sync up with Txtzyme
putz "_ok_"; $_ = getz until /ok/;
print "running\n";

$version = getz "v";
print "detected $version\n";

# Teensy 2.0
if ($version eq 'atmega32u4') {
	@top = ('0f','1f','4f','5f','6f','7f','6b','5b','4b','7d','6d');
	@mid_top = ('4d');
	@mid_bot = ('6e','5d');
	@bot = ('0b','1b','2b','3b','7b','0d','1d','2d','3d','6c','7c');
}

# Teensy++ 2.0
if ($version eq 'at90usb1286') {
	@top = ('6b','5b','4b','3b','2b','1b','0b','7e','6e','0f','1f','2f','3f','4f','5f','6f','7f');
	@mid_top = ('4e','0a','1a','2a','3a');
	@mid_bot = ('5e','4a','5a','6a','7a');
	@bot = ('7b','0d','1d','2d','3d','4d','5d','6d','7d','0e','1e','0c','1c','2c','3c','4c','5c','6c','7c');
}

@all = (@top, @mid_top, @mid_bot, @bot);

# Blink on logic 1 input
while (1) {
	for (@all) { putz $_, "io{1o}" }
	putz "100m";
	for (@all) { putz $_, "io{0o}" }
	putz "100m";
}
