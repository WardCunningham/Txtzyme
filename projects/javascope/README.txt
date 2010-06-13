
Txtzyme Javascope
-----------------
by Ward Cunningham

This java program will read data from a Teensy running Txtzyme and display it as traces in a window. Use p to output data, _label_, to start a new trace. The data can come quickly or slowly. Javascope uses threads to read and display independently.

Things To Try
-------------

Try touching or clipping a short wire to pin F7 to pick up 60Hz hum.

Compile and launch Javascope.

$cd projects/javascope
$javac Scope.java
$java Scope &

Then run one or more shell commands to produce data.

$ echo _fast_220{5sp} >/dev/cu.usbmodem12341 
$ echo _slow_6d1o220{5sp16m600u}0o >/dev/cu.usbmodem12341
$ while sleep .0805; do echo _rep_220{5sp} >/dev/cu.usbmodem12341; done

Try running Timebase.sh. It makes a good demo because it alternates between slow and fast acquisitions (those with and without 16m600u delay).

$ sh Timebase.sh