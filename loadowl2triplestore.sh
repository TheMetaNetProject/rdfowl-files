#!/bin/sh

# argument processing
if [[ "$1" = "" ]]; then
    langlist='en es ru fa'
else
    langlist="$1"
fi

SELECTED_OPTIONS=default_options

for lang in $langlist
do
  echo "Loading $lang - `date`"
  echo 'clear.' | /u/metanet/tools/openrdf-sesame-2.7.8/bin/console.sh -q -s http://localhost:8080/openrdf-sesame mr_$lang
/usr/bin/curl -T ./mr_$lang.owl \
     -H "Content-Type: application/rdf+xml;charset=UTF-8" \
     http://localhost:8080/openrdf-sesame/repositories/mr_$lang/statements
done
