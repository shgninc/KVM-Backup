#!/bin/bash
#set -e
set -x

. funcs.sh
if [ $# -eq 0 ]; then
    echo "No arguments provided..."
    exit 1
fi
dom=$1

########################## Start the Operation #####################
# detect if the Given VM is exist oe not #
#listAllVM  
virsh list --all | grep -w "$dom" > /dev/null 2>&1
isExist="$?"
# detect if the Given VM is exist oe not #

# if the $dom VM is exist #
if [ "$isExist" -eq "0" ]; then
	isRunning=`virsh list | grep -c $dom` #1>log.log 2>log.err `
	#if the $dom VM is running, then turn it off
	if [ "$isRunning" -eq "1" ]; then
		echo "Guest is running. Asking/waiting for guest to shutdown..."
		wasRunning="0"
		Guest destroy $dom
		#sleep 60
		echo "The Guest was Destroyed..."
	fi
	
	#### delete a vm with its disk
	destroy_vm $dom
	#### delete a vm with its disk
fi
