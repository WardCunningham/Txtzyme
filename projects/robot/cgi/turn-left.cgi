#!/bin/sh
echo Content-type: text/plain; echo
perl ../move.pl 25 1 -1 >/dev/cu.usbmodem123451
echo done
