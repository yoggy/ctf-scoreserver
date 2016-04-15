ctf-scoreserver
====

Description
----
Scoreserver Web Application for CTF(Capture The Flag)

  - http://github.com/yoggy/ctf-scoreserver

Prerequire
----

    $ sudo apt-get install ruby ruby-dev rubygems bundler sqlite3 libsqlite3-dev build-essential git
    $ bundle install

Launch web application
----

    $ ruby scoreserver.rb

How to access scoreboard
----

    http://[host or ip address]:4567/

Configuration
----
config.rb is created when scoreserver.rb is started.
Please change ADMIN_PASS_SHA1 value in config.rb.

ADMIN_PASS_SHA1 is SHA-1 hash value for administrator password 

    ex. 
       $ echo -p "administrator password" | sha1sum
       208fccd4c9416a58a198b4bc6b0516275e468788
    

You must restart scoreserver.rb, if you rewrite config.rb.

How to access administrator site
----

    http://[host or ip address]:4567/admin

github
----
clone (anonymous access)

    $ git clone git://github.com/yoggy/ctf-scoreserver.git

pull
  
    $ mkdir ctf-scoreserver
    $ cd ctf-scoreserver
    $ git init
    $ git remote add origin git@github.com:yoggy/ctf-scoreserver.git
    $ git pull origin master
  
Copyright and license
----
Copyright (c) 2016 yoggy

Released under the [MIT license](LICENSE.txt)

