# Description
This is a fork of the original [cronic](http://habilis.net/cronic/)

     Cronic v2 - cron job report wrapper
     Copyright 2007 Chuck Houpt. No rights reserved, whatsoever.
     Public Domain CC0: http://creativecommons.org/publicdomain/zero/1.0/

cronic2 notifies only on first failure.
It remembers later that it had already notified.
If a script stops failing, it'll forget that it failed, so that if it failed again, it would notify again

To start using the memory feature, you need to run

    echo "export CRONIC2=~/.cronic2.db" >> ~/.bashrc
    touch ~/.cronic2.db
    # restart bash
    # http://unix.stackexchange.com/a/22722
    exec bash -l 

where I chose `~/.cronic2.db` to be the location of the file in which `cronic2` stores the commands that had failed.

If the environmental variable `CRONIC2` exists, and if the file it references exists, then the memory feature works. Otherwise, `cronic2` falls back to the original `cronic` functionality, i.e. notifying on every failure

# Installation
For a global install:

     sudo cp cronic2 /usr/local/bin/
     sudo ln -s /usr/local/bin/cronic2 /usr/bin/

# Unit tests

    cd tests; bash test1.sh

# root crontab
To make this work with root crontab, you need to manually set the path to the `.cronic2.db` file from `~/.cronic2.db` to something like `/home/shadi/.cronic2.db`
