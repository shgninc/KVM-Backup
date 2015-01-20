#!/bin/bash

#create new vm from an existing vm
#sudo v irsh create open.xml
# Destroy a vm in disk file .img type 
function destroy_vm()
{
	echo "Destroy VM $NAME"
	rm -rf /home/ssd/$NAME.img
	virsh destroy $NAME
	virsh undefine $NAME
}

# Get LVM group disk
function getVg()
{
	vgName=`vgdisplay | grep "VG Name" | awk '{print $3}'`
	echo $vgName
}

# Show list of VMs
function listVM()
{
	vm=`virsh list --all  | awk '{print $2}' | grep -v Name` # | awk '{print $2}'` <-- remove blank lines
	echo $vm
}

# Choose the right VM, The $1 is the name of the VM was selected
function selectVM()
{
	vms=`listVM`
	for vm in $vms
	do
	   if [ $1 = $vm ]
	   then
		select=$vm
	   fi
	done
	if [ $select ]
	then
	   echo $select
	else
	   echo 0
	fi
}

# Return number of VMs
function vmNo()
{
	vm=`listVM | wc -w`
	return $vm
}

# Show VM's disk path, the $1 is the vm name in virsh
function vmDisk()
{
	vmPath=`virsh domblklist $1 | grep vda | awk '{print $2}'`
	echo $vmPath
}

# Return VM's disk size, the $1 is the LVM disk name
function vmDiskSize()
{
	vmSize=`lvs $1 | awk '{print $4}' | grep -v LSize | awk '{print substr($0,0,index($0,".")-1)}'`
	echo $vmSize
}

# Create snapshot for VM's disk, the $1 is the name of snapshot LVM disk,
# $2 is the size of the LVM disk, the $3 is path of the LVM disk
function createSnapshot()
{
	isExist=`lvs | grep $1 | wc -l`
	if [ $isExist == 1 ]
	then
	   echo "cleaning the exist LVM snapshot..."
	   vgName=`getVg`
	   echo $vgName
	   sleep 4s
	   removeDisk $DEV"/"$vgName"/"$1
	fi
	echo "creating the snapshot for LVM disk..."
	sleep 4s
	lvcreate --snapshot --name $1 --size $2G $3
}

# Remove the LVM disk, The $1 is the path of the LVM disk
function removeDisk()
{
	lvremove -vf $1
}

# Create dump xml file for VMs specefications
function createDump()
{
	virsh dumpxml $1 > $2
}

# Backup VMs disk and convert it to a compressed file
function backupDisk()
{
	dd if=$1 | gzip -c | dd of=$2
}

# Check VG LVM Disk size
function getVgFree()
{
	vgFree=`vgs | awk '{print $7}' | grep -v VFree`
	echo $vgFree
}

# Create LVM disk for Backup target folder
function creatLvmBackup()
{
	isExist=`lvs | grep -c lv_vmBackup`
	vgName=`getV`
        if [ $isExist -ne 1 ]
        then
           echo "Creating the LVM Backup Disk..."
           sleep 4s
	   `lvcreate -n lv_vmBackup -L 100G $vgName`
	   mkfs.ext4 -q /dev/vg_qrmkvm/lv_vmBackup
        elif [ `mount | grep -c lv_vmBackup` -ne 1 ]
	then
	   echo "Mounting the LVM backup disk to /backup"
	   mount $DEV"/"$vgName"/"lv_vmBackup /ashena/backup/
	   rm -rf /ashena/backup/*
	fi
}
