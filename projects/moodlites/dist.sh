cat cron.log | perl -e 'for (<>) {$t{$1}++ if /\d+:\d+:(\d+) /} for (0..59) {$t=sprintf("%02d",$_); print "$t\t","|"x$t{$t},"\n"}'
