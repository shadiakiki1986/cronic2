# Description
This is a fork of the original cronic

     http://habilis.net/cronic/
     Cronic v2 - cron job report wrapper
     Copyright 2007 Chuck Houpt. No rights reserved, whatsoever.
     Public Domain CC0: http://creativecommons.org/publicdomain/zero/1.0/

cronic2 notifies only on first failure.
It remembers later that it had already notified.
If a script stops failing, it'll forget that it failed, so that if it failed again, it would notify again

To start using the memory feature, you need to run `touch ~/.cronic2.db`.
If this file exists, then the memory feature works, otherwise it won't and falls back to the original cronic functionality

# Installation
For a global install:

     sudo cp cronic2 /usr/local/bin/
     sudo ln -s /usr/local/bin/cronic2 /usr/bin/

# Unit tests

    cd tests; bash test1.sh
