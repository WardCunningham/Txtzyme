# Launches background job to plot output from Txtzyme.
# Runs forground loop sampling at a rate good for 60Hz hum.

perl -pe 's/\d+/"$&\t"."|"x($&*.1)/e' < /dev/cu.usbmodem12341 &
while sleep .144; do clear; echo 40{5sp300u} > /dev/cu.usbmodem12341; done
