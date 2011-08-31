#!/bin/sh
echo Content-type: text/plain; echo
perl -e 'for (0..628) {
	$t = int( 1300 + 600 * sin( $_/50.0 ));
	print "7d 1o ${t}u 0o 5m \n"
}' >/dev/cu.usbmodem123451
echo done
