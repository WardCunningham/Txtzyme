This project uses Txtzyme to control GE G35 digital LED Holliday lights.
We replace the stock controller with our own code.
Our work follows the protocol described here:

* http://www.deepdarc.com/2010/11/27/hacking-christmas-lights/

On power-up the lights are dark and the logic at each bulb is waiting to be initialized.
Each new address send finds the next uninitialized light which takes on that address.
We initialize a whole strand by setting each subsequent light to blue:

* perl enumerate.pl

We display the mood of our house much the way the classic mood ring displays the mood of the wearer: by temperature.

* http://en.wikipedia.org/wiki/Mood_ring

We select one (initialized) bulb at random and then set its color based on some temperature within the house.
We use the furnace's hot-air plenum temperature because the furnace operates in several modes (moods) throughout the day.

* perl mood.pl

We use the color code RED=hot, GREEN=warm, BLUE=cold. We observe moods as follows.

* night: all BLUE due to setback thermostat
* morning: all RED as house is warmed up
* afternoon: all BLUE as outside is warm enough to keep furnace from running
* evening: RED and GREEN as furnace cycles to sustain daytime temperature

Transitions provide a slowly evolving mixture of the above combinations.

We've simulated this behavior and found that, for a string of 50 bulbs, updating a single bulb every 15 seconds yields a suitable whole-string response time.
We achieve this period by launching a cron script once every minute.
The script uses sleep to space four invocations of mood.pl 15 seconds apart.

* * * * * * (cd Txtzyme/projects/moodlites; sh cron.sh)
* 0 0 * * * (cd Txtzyme/projects/moodlines; mv cron.log old.cron.log)

We've checked for proper operation by computing the distribution of log entries for each of 60 possible seconds.

If you want to see what you're lights have been doing, there is a log viewer that produces color-coded output from cron.logs with a command something like this.

* cat old.cron.log cron.log | perl show.pl

