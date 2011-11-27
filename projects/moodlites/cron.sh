# * * * * * (cd Txtzyme/projects/moodlites; sh cron.sh)
# 0 0 * * * (cd Txtzyme/projects/moodlites; mv cron.log old.cron.log)

for i in 1 2 3 4
do perl mood.pl >>cron.log
sleep 10
done
