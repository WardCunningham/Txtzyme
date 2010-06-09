$_ = 'THE QUICK BROWN FOX JUMPED OVER THE LAZY DOGS BACK';

s/\w/_\l$&_$&/g;
s/A/.- /g;
s/B/-... /g;
s/C/-.-. /g;
s/D/-.. /g;
s/E/. /g;
s/F/..-. /g;
s/G/--. /g;
s/H/.... /g;
s/I/.. /g;
s/J/.--- /g;
s/K/-.- /g;
s/L/.-.. /g;
s/M/-- /g;
s/N/-. /g;
s/O/--- /g;
s/P/.--. /g;
s/Q/--.- /g;
s/R/.-. /g;
s/S/... /g;
s/T/- /g;
s/U/..- /g;
s/V/...- /g;
s/W/.-- /g;
s/X/-..- /g;
s/Y/-.-- /g;
s/Z/--.. /g;
print "$_\n";

s/ /300m\n/g;
s/\./50{1mom0o}100m\n/g;
s/\-/150{1mom0o}100m\n/g;
print;

`echo '$_' >/dev/cu.usbmodem12341`;

