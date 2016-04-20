# Description
This is a fork of the original [cronic](http://habilis.net/cronic/)

     Cronic v2 - cron job report wrapper
     Copyright 2007 Chuck Houpt. No rights reserved, whatsoever.
     Public Domain CC0: http://creativecommons.org/publicdomain/zero/1.0/

cronic2 notifies only on first failure.
It remembers later that it had already notified.
If a script stops failing, it'll forget that it failed, so that if it failed again, it would notify again

# Usage

The memory feature of `cronic2` is on when
* the cronic2 script sees the environmental variable `CRONIC2` set to a path to a file
* and the file referenced by `CRONIC2` environmental variable exists

This file will serve as the "memory" of `cronic2`.
If the above 2 conditions are not met, `cronic2` falls back to the original `cronic` functionality, i.e. notifying on every failure.

To set the environment variable `CRONIC2` in crontab,
refer to [this](http://stackoverflow.com/questions/2229825/where-can-i-set-environment-variables-that-crontab-will-use)
SO question with excellent answers.
Here I will list the `vixie-crontab` [solution](http://stackoverflow.com/a/10657111/4126114)
of typing the following at the head of the `crontab -e` file:
`CRONIC2=/home/shadi/.cronic2.db` where I chose `/home/shadi/.cronic2.db`
to be the memory file of `cronic2`.

If you would like to use the ~ in the path, e.g. `CRONIC2=~/.cronic2.db`,
you will also need `SHELL=/bin/bash` before it
as documented [here](http://manpages.ubuntu.com/manpages/xenial/en/man5/crontab.5.html)

On the other hand, to start using the memory feature of `cronic2` in your shell scripts, you need to run

    echo "export CRONIC2=~/.cronic2.db" >> ~/.bashrc
    touch ~/.cronic2.db
    # restart bash
    # http://unix.stackexchange.com/a/22722
    exec bash -l 

# Installation
For a global install:

     sudo cp cronic2 /usr/local/bin/
     sudo ln -s /usr/local/bin/cronic2 /usr/bin/

# Unit tests

    cd tests; bash test1.sh

# root crontab
To make this work with root crontab, you need to manually set the path to the `.cronic2.db` file from `~/.cronic2.db` to something like `/home/shadi/.cronic2.db`
