
Txtzyme Perlscope
-----------------
by Ward Cunningham

Perlscope is a perl script that copies output from Txtzyme and expands numbers within it to include a bar chart representation. One normally leaves Perlscope running as a background job to collect and plot all Txtzyme output.


Things to Try
-------------

Launch Perlscope as a detached job.

$ perl -pe 's/\d+/"$&\t"."|"x($&*.1)/e' < /dev/cu.usbmodem12341 &

Test this with simple commands that generate predictable output.

$ echo _hello world_ >/dev/cu.usbmodem12341
$ echo __10p20p30p40p >/dev/cu.usbmodem12341

Try printing samples of hum picked up by a short wire connected to analog input channel 5 (pin F7) The delay, 16.2 milliseconds, has been chosen to sample hum at nearly adjacent points on successive samples.

$ echo 400{5sp16m200u} >/dev/cu.usbmodem12341

A neat trick is to write a loop that clears the screen between repeated data acquistions for a more realtime effect. 

$ while sleep .144; do clear; echo 40{5sp300u} > /dev/cu.usbmodem12341; done

Use shell job control to kill the detached job or just unplug the teensy. Here is a handy script that does all of the steps in one file.

$ cd projects/perlscope
$ sh scope.sh

