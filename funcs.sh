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

# Show list of VMs
function listVM()
{
	vm=`virsh list --all | awk '{print $2}' | grep -v Name` # | awk '{print $2}' <-- remove blank lines
	echo $vm
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

# Create snapshut for VM's disk, the $1 is the name of snapshot LVM disk,
# $2 is the size of the LVM disk, the $3 is path of the LVM disk
function createSnapshot()
{
	lvcreate --snapshot --name $1 --size $2G $3
}

# Remove the LVM disk, The $1 is the path of the LVM disk
function removeDisk()
{
	lvremove -f $1
}
