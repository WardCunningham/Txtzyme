
Txtzyme Demo
-----------------
by Ward Cunningham

Paul has built a family of demo boards for Teensy and Teensy++ computers. These boards have buttons and leds on every io pin and pots on analog input pins. This project includes some simple testing of board resources and a little bit of show-off blinking lights.


Things To Try
-------------

Test the outputs of a demo board. This script uses the mac "say" program to blink each led in turn as it identifies the led verbally. 

$ perl test_outputs.pl

Test inputs of a demo board. This script reads each button and then blinks the led corresponding to any pressed buttons. Try adjusting the pots on analog inputs. We are reading those pins as logic so they will appear as a pressed button when adjusted above the digital logic threshold. 

$ perl test_inputs.pl

Try blinking lots of lights.

$ perl sequence.pl

If you have more than one demo board, plug them all in and run sequence on all of them.

$ for i in /dev/cu.usbmodem*; do (perl sequence.pl $i &); done;