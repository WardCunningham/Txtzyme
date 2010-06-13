# alternate between slow and fast acquistion

while true
	do echo _slow_6d1o500{5sp16m600u}0o >/dev/cu.usbmodem12341;
	sleep 10;
	for i in 1 2 3 4 5 6 7 8 9 10
		do echo _fast_1o500{5sp}0o >/dev/cu.usbmodem12341
		sleep .348
	done
done
