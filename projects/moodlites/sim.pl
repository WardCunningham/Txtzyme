# while true; do perl sim.pl; sleep 15; done

$bulb = int(rand(50))+1;
$status = `tail -1 sim.log`;
chomp($status);
substr($status, $bulb-1, 1) = int(rand(1.6))? 'o' : '.';
`echo $status >>sim.log`;
