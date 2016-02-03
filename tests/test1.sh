#!/bin/bash
# Unit tests of cronic2 script

set -e

NF=~/.cronic2.db

if [ -s $NF ]; then
  echo "Cannot run test on non-empty $NF file:"
  cat $NF
  exit 1
fi

#-------------------------------------------------
# 1. test cases of memory disabled
rm -f $NF
# test error on first failure
( tf=`tempfile` && bash ../cronic2 ls bla > $tf && test `wc -l $tf|awk '{print $1}'` -gt 0 && test ! -s $NF && rm $tf       ) || ( echo "test 1-1 failed" && exit 1 )
# test error on 2nd failure
( tf=`tempfile` && bash ../cronic2 ls bla > $tf && test `wc -l $tf|awk '{print $1}'` -gt 0 && test ! -s $NF && rm $tf       ) || ( echo "test 1-2 failed" && exit 1 )

#-------------------------------------------------
# 2. test cases of memory enabled
touch $NF
# test no error on correct command
( tf=`tempfile` && bash ../cronic2 ls     > $tf && test ! -s $tf                                            ) || ( echo "test 2-1 failed" && exit 1 )
# test error on first failure
( tf=`tempfile` && bash ../cronic2 ls bla > $tf && test `wc -l $tf|awk '{print $1}'` -gt 0  && rm $tf       ) || ( echo "test 2-2 failed" && exit 1 )
# test no error on 2nd failure
( tf=`tempfile` && bash ../cronic2 ls bla > $tf && test ! -s $tf                                            ) || ( echo "test 2-3 failed" && exit 1 )
# test no error on success
( mkdir bla     && bash ../cronic2 ls bla       && test `wc -l $NF|awk '{print $1}'` -eq 0 && rmdir bla     ) || ( echo "test 2-4 failed" && rmdir bla && exit 1 )
# test error on first failure after success
( tf=`tempfile` && bash ../cronic2 ls bla > $tf && test `wc -l $tf|awk '{print $1}'` -gt 0  && rm $tf       ) || ( echo "test 2-5 failed" && exit 1 )

#--------------------------------
rm $NF
echo "All tests pass"
