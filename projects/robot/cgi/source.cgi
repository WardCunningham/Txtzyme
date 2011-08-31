#!/usr/bin/perl
print "Content-type: text/html\n\n";
for (<*.cgi>) {
	print "<h1><a href=$_>$_</a></h1>\n";
	$_ = `cat $_`;
	s/&/&amp;/g; s/</&lt;/g;
	print "<pre>$_</pre>\n";
}
