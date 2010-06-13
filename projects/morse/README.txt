
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

Capture the ASCII version of the code by reading from the Teensy.

$ cat /dev/cu.usbmodem12341

