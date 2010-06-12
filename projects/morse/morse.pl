$_ = 'THE QUICK BROWN FOX JUMPED OVER THE LAZY DOGS BACK';

s/\w/_\l$&_\n$&/g;
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

s/ /mmm\n/g;
s/mmm\nmmm/_ _\n$&/g;
s/\./25{1mom0o}50m\n/g;
s/\-/75{1mom0o}50m\n/g;
print;

`echo '$_' >/dev/cu.usbmodem12341`;

