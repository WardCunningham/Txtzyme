old=1000
while true
	new=`jot -r 1 660 2000`
	do for i in `jot 200 $old $new`
		do echo 7f 1o $i u 0o 20m
	done >/dev/cu.usbmodem1001
	old=$new
done
