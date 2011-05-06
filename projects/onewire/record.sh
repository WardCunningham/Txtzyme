while sleep 10
do QUERRY_STRING="pin=7d" perl scan.pl |
perl -e '
	$_ = join "", <>;
	print join "\t", map sprintf("%1.1f", $_/16.0*9/5+32), m/:\s+(\d+)/g;
	print "\n"
';
done | tee data.log