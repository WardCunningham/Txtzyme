I had planned to exhibit uno in the dorkbot gallery show.
I'd been asking around to borrow a plug-computer to run it for the month long event.
Paul Stoffregen suggested I just rewrite my perl in c and run it on the Teensy stand alone.
I thought it would be too much trouble to make it fast enough.
Paul took that as a challenge.

Paul wrote four versions with progressively more aggressive optimizations.
This took place one evening in the hacker space at the Portland Open-Source Bridge conference.

* sparkle_ -- direct conversion from perl
* sparkle_fp -- fixed-point table lookup for sine and random
* sparkle_fastest -- open coding port bit set & clear

This last version was the first to run faster than the perl/txtzyme version.
It has a delayMicroseconds(75) commented out in the run loop.
The exhibited version had this delay which we tuned to match the visual appearance of the txtzyme version.

A better match might have been achieved with a longer table of random numbers.
The effective sequence could be improved by combining results from cycling two pointers through the table at different rates. 
