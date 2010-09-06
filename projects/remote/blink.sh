while true; do
    sleep 1; echo 1bo 100m o >/dev/cu.usbmodem12341
    sleep 1; echo 1000{0b1o24uo 1bo24uo}>/dev/cu.usbmodem12341
    sleep 1; echo 0b1o 100m o>/dev/cu.usbmodem12341
    sleep 1; echo 1000{0b1o24uo 1bo24uo}>/dev/cu.usbmodem12341
done
