Txtzyme Blink
-------------
by Ward Cunningham

This project conducts an experiment in visual perception. While testing Txtzyme example programs I found that I could see LED blinks uniformly and distinctly but that I could not count them correctly. Could I be observing some rate limit deep within my perceptual system?

To test this hypothesis I wrote a Mac specific experiment manager. I chose to offer instruction mostly with voice synthesis and to collect responses with single keystrokes so that the subject's attention could remain focused on the experiment.

Things to Try
-------------

Try collecting data from yourself and your friends. 

$ open instructions.rtf
$ perl experiment.pl

This will display instructions and then collect data through mechanisms suitable for volunteer participation at a club meeting. Results are timestamped and stored under the subject's initials within the results directory.

$ perl tally.pl

This script reads and counts responses from all subjects. The results are then printed in tab-separated columns, one for each possible response, with each row corresponding to the stimulus half-cycle period in milliseconds. Here are some of my first results:

	1	2	3	4	5	6	7	8	9

50										
51										
52						1				
53			1	1	1					
54				1						
55										
56					1					
57										
58										
59				2	1					
60				1						
61										
62			1							
63				1						
64										
65			2							
66					1					
67										
68				2						
69										
