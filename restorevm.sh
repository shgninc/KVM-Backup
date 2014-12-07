#!/bin/bash
. funcs.sh
TMP=/tmp
backupDir=/bakdir
DEV=/dev
preDisk="snap-"

vmName=`listVM | cut -f1 -d ' '`
diskPath=`vmDisk $vmName`
#echo $diskPath
size=`vmDiskSize $diskPath`
snapName=$preDisk$vmName

if [ -e $disk ] # check if the VM's disk exist
then
   if [ ! -d $TMP$backupDir ] # check if the tmp dir on /tmp exist
   then
      mkdir -p $TMP$backupDir
   fi
   createSnapshot $snapName $size $diskPath
   #echo $snapName $size $diskPath
else
   echo "There is no disk for this VM!"
fi
