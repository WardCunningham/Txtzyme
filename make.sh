for mcu in `grep 'MCU =' Makefile | cut -f 3 -d ' '`
do echo ============= $mcu ==============
	cat Makefile | 
	perl -pe '
		s/^MCU = /#MCU = /;
		s/^#(MCU = '$mcu')/$1/;
		' > /tmp/txtzyme_makefile
	# head -60 /tmp/txtzyme_makefile
	make clean
	make -f /tmp/txtzyme_makefile
	mv txtzyme.hex hex/$mcu.hex
	mv txtzyme.elf hex/$mcu.elf
done
make clean
rm /tmp/txtzyme_makefile
