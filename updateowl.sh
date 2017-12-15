#!/bin/sh

# argument processing
if [[ "$1" = "" ]]; then
    langlist='en es ru fa'
else
    langlist="$1"
fi

# load configuration settings
if [ -e ~/.conf.metanet ] ; then
    source ~/.conf.metanet
fi

# generate files that are group writable
umask 0002

DIR=/u/metanet/repository/rdf
errorlog=error.log
bakdir=bak.`date +%Y.%m.%d`

# make backups: max 1 per day
if [ ! -d $bakdir ]; then
    mkdir $bakdir
    mv mr_*.owl $bakdir
    mv $errorlog $bakdir
else
    rm -f mr_*.owl $errorlog
fi

cd ${DIR}

# remove backups older than $DAYS_KEEP
DAYS_KEEP=10
find ${DIR} -name 'bak.*' -mtime +$DAYS_KEEP -exec rm -rf {} \; 2> /dev/null

#
# run Wiki 2 OWL converter
# then generate metanetrdf cache (for gmrupdate and m4* scripts)
# add -v flag to get "creating schema" message to verify we're ok. Steve Doubleday
echo "updateowl.sh running with PYTHONPATH: $PYTHONPATH" 
for lang in $langlist
do
  wiki2owl -l $lang -u $MNWIKI_USER -p $MNWIKI_PW mr_$lang.owl >> $errorlog 2>&1
  python  -m mnrepository.metanetrdf -v -l $lang >> $errorlog 2>&1
done
