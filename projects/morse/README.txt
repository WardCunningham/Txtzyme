
Txtzyme Morse
-------------
by Ward Cunningham

This perl script generates a series of Txtzyme commands and then sends them to the teency's usb device.


Things to Try
-------------

Generate and transmit the script.

$ cd projects/morse
$ perl morse.pl

Watch the morse code blink in the teensy's LED.

Connect a speaker to pin D6 to hear the morse code.


How it Works
------------

The perl program converts ASCII to Morse Code's dots, dashes and spaces.
The program then converts each of these to a Txtzyme program:

  dot => 25{1mom0o}50m
  dash => 75{1mom0o}50m
  space => mmm

Dots are 25 cycles of tone followed by a 50 millisecond pause.
Dashes are three times longer than dots, so their program repeats for 75 cycles.

These Txtzyme programs reuse numbers for several commands.

Specifically:

  1mom0o == 1m 1o 1m 0o

This generates one cycle of the 500 Hz square wave.

Also letter and word spaces use:

  mmm == 50m 50m 50m == 150m

This is works when we know 50 is left over from the previous Morse letter.

