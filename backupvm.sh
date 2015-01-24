#!/bin/bash
set -e
set -x
. funcs.sh
TMP=/ashena
backupDir=/backup
DEV=/dev
preDisk="snap-"

vmName=`selectVM $1`
#echo $vmName
diskPath=`vmDisk $vmName`
#echo $diskPath
size=`vmDiskSize $diskPath`
#echo $size
snapName=$preDisk$vmName
#echo $snapName

if [ -e $diskPath ] # check if the VM's disk exist
then
   if [ ! -d $TMP$backupDir ] # check if the tmp dir on /tmp exist
   then
      mkdir -p $TMP$backupDir
   fi
   #createSnapshot $snapName $size $diskPath
   tmpPath=$TMP$backupDir"/"$vmName
   if [ ! -d $tmpPath ]
   then
	mkdir -p $tmpPath
   else
	`rm -rf $tmpPath/*`
   fi
   createDump $vmName $tmpPath"/"$vmName".xml"
   backupDisk $diskPath $tmpPath"/"$vmName".gz"
else
   echo "There is no disk for this VM!"
fi
