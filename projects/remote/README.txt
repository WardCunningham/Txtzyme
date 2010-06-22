
Txtzyme Remote
--------------
by Ward Cunningham

The Txtzyme Remote server exposes selected Teensy capabilities through an extensible web interface.


Things to Try
-------------

Upgrade Ruby http://www.ruby-lang.org/en/downloads/

  $ sudo port install ruby

Install Ruby modules http://developer.apple.com/tools/developonrailsleopard.html

  $ sudo gem update --system
  $ sudo gem install sinatra
  $ sudo gem install haml
  $ sudo gem install json

Optionally apply patch for older ruby http://gist.github.com/441238

Fetch the source http://GitHub/wardcunningham/txtzyme

  $ git clone git@github.com:WardCunningham/Txtzyme.git

Launch the server.

  $ cd txtzyme/projects/remote
  $ rails server.rb

View individual bits.

  $ curl http://localhost:4567/f/1

Try the web-form

    http://localhost:4567/