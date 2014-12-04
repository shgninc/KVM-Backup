#!/bin/bash
. funcs
TMP=/tmp
backupDir=/bakdir

vmName=`listVM | cut -f1 -d ' '`
disk=`vmDisk $vmName`
echo $disk

if [ -e $disk ] 
then
   if [ ! -d $TMP$backupDir ]
   then
      mkdir -p $TMP$backupDir
      ls -l $TMP$backupDir
   fi
   
else
   echo "There is no disk for this VM!"
fi
