#!/bin/sh

HOSTS="
r1 r2 r3
switch1 switch2 switch3
"

for HOST in $HOSTS ; do
   rm -f ./fetchedconfig
   ./getconfig.ex $HOST 2> /dev/null > /dev/null
   if [ -e ./fetchedconfig ]; then
      #DATE=`date -u --rfc-3339=seconds`
      #echo "! fetched from $HOST on $DATE" > ${HOST}-config.txt
      cat ./fetchedconfig > ${HOST}-config.txt
      rm -f ./fetchedconfig
      ./wikiupdate ${HOST} ./${HOST}-config.txt
      rm -f ./${HOST}-config.txt
   else
      echo "unable to fetch config for $HOST"
   fi
done

