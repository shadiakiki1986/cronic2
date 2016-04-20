#!/bin/bash
# Unit tests of cronic2 script

set -e

#-------------------------------------------------
# 0. test cases of memory disabled by no environment variable
unset CRONIC2
# test error on first failure
( tf=`tempfile` && bash ../cronic2 ls bla > $tf && test `wc -l $tf|awk '{print $1}'` -gt 0 && rm $tf       ) || ( echo "test 0-1 failed" && exit 1 )
# test error on 2nd failure
( tf=`tempfile` && bash ../cronic2 ls bla > $tf && test `wc -l $tf|awk '{print $1}'` -gt 0 && rm $tf       ) || ( echo "test 0-2 failed" && exit 1 )
#-------------------------------------------------

export CRONIC2=~/test_cronic2.db

if [ -s $CRONIC2 ]; then
  echo "Cannot run test on non-empty $CRONIC2 file:"
  cat $CRONIC2
  exit 1
fi

#-------------------------------------------------
# 1. test cases of memory disabled by no file
rm -f $CRONIC2
# test error on first failure
( tf=`tempfile` && bash ../cronic2 ls bla > $tf && test `wc -l $tf|awk '{print $1}'` -gt 0 && test ! -s $CRONIC2 && rm $tf       ) || ( echo "test 1-1 failed" && exit 1 )
# test error on 2nd failure
( tf=`tempfile` && bash ../cronic2 ls bla > $tf && test `wc -l $tf|awk '{print $1}'` -gt 0 && test ! -s $CRONIC2 && rm $tf       ) || ( echo "test 1-2 failed" && exit 1 )

#-------------------------------------------------
# 2. test cases of memory enabled
touch $CRONIC2
# test no error on correct command
( tf=`tempfile` && bash ../cronic2 ls     > $tf && test ! -s $tf                                            ) || ( echo "test 2-1 failed" && exit 1 )
# test error on first failure
( tf=`tempfile` && bash ../cronic2 ls bla > $tf && test `wc -l $tf|awk '{print $1}'` -gt 0  && rm $tf       ) || ( echo "test 2-2 failed" && exit 1 )
# test no error on 2nd failure
( tf=`tempfile` && bash ../cronic2 ls bla > $tf && test ! -s $tf                                            ) || ( echo "test 2-3 failed" && exit 1 )
# test no error on success
( mkdir bla     && bash ../cronic2 ls bla       && test `wc -l $CRONIC2|awk '{print $1}'` -eq 0 && rmdir bla     ) || ( echo "test 2-4 failed" && rmdir bla && exit 1 )
# test error on first failure after success
( tf=`tempfile` && bash ../cronic2 ls bla > $tf && test `wc -l $tf|awk '{print $1}'` -gt 0  && rm $tf       ) || ( echo "test 2-5 failed" && exit 1 )

#-------------------------------------------------
# 3. test cases of ~ getting expanded or not
if [ -s "~/bla" ]; then
  echo "Cannot run test on non-empty ~/bla file:"
  exit 1
fi

# test no error on correct command
( tf=`tempfile` && bash ../cronic2 ls ~     > $tf && test ! -s $tf                                            ) || ( echo "test 3-1 failed" && exit 1 )
# test error on first failure
( tf=`tempfile` && bash ../cronic2 ls ~/bla > $tf && test `wc -l $tf|awk '{print $1}'` -gt 0  && rm $tf       ) || ( echo "test 3-2 failed" && exit 1 )
# test no error on 2nd failure
( tf=`tempfile` && bash ../cronic2 ls ~/bla > $tf && test ! -s $tf                                            ) || ( echo "test 3-3 failed" && exit 1 )
# test no error on 3rd failure if full path
( tf=`tempfile` && fp=~ && bash ../cronic2 ls $fp/bla > $tf && test ! -s $tf                                            ) || ( echo "test 3-4 failed" && exit 1 )
# test no error on correct
( tf=`tempfile` && touch ~/bla && bash ../cronic2 ls ~/bla > $tf && test ! -s $tf                                            ) || ( echo "test 3-5 failed" && exit 1 )
# test error on 1st failure after correct
( tf=`tempfile` && rm ~/bla && bash ../cronic2 ls ~/bla > $tf && test `wc -l $tf|awk '{print $1}'` -gt 0  && rm $tf       ) || ( echo "test 3-6 failed" && exit 1 )

#--------------------------------
rm $CRONIC2
echo "All tests pass"
