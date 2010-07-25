Pre-Built Txtzyme Hex Files
===========================

Txtzyme runs on Teensy and Teensy++ versions 1.0 and 2.0. These devices are available, inexpensive and well supported by <http://pjrc.com/teensy>. Once you are in possession of a device you will need to:

- Download the Teensy loader from <http://pjrc.com/teensy/loader.html>
- Download Txtzyme hex from <http://github.com/WardCunningham/Txtzyme/tree/master/hex/>

Choose the hex file that corresponds to your Teensy.
The correspondences are as follows:

- `at90usb1286.hex` for Teensy++ 2.0
- `at90usb162.hex` for Teensy 1.0
- `at90usb646.hex` for Teensy++ 1.0
- `atmega32u4.hex` for Teensy 2.0

Once Txtzyme is running you can send commands to it from the shell.
Here is how to send a "blink" program from an OS X Terminal window:

        $ echo '5{ 6d 1o 100m 0o 100m }' >/dev/cu.usbmodem12341
