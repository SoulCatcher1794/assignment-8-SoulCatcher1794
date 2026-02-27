#!/bin/sh
module=$1
# Use the same name for the device as the name used for the module
device=$1
# Support read/write for owner and group, read only for everyone using 644
mode="664"

# Check that we have the right number of arguments
if [ $# -ne 1 ]; then
	echo "Wrong number of arguments"
	echo "usage: $0 module_name"
	echo "Will create a corresponding device /dev/module_name associated with module_name.ko"
	exit 1
fi

set -e
# Group: since distributions do it differently, look for wheel or use staff
# These are groups which correspond to system administrator accounts
if grep -q '^staff:' /etc/group; then
    group="staff"
else
    group="wheel"
fi

echo "Load ${module} module, exit on failure"
# Get the kernel version to construct the path to the module
KERNEL_VERSION=$(uname -r)
# Invoke insmod with all arguments we got
# and use a pathname, as insmod doesn't look in . by default
# The module should be in "/lib/modules/$(uname -r)/extra/" since it is not part of the standard kernel modules
# but rather a custom module we have built and installed there.
insmod /lib/modules/${KERNEL_VERSION}/extra/$module.ko $* || exit 1

# Get the major number (allocated with allocate_chrdev_region) from /proc/devices
major=$(awk "\$2==\"$module\" {print \$1}" /proc/devices)
if [ ! -z ${major} ]; then
    rm -f /dev/${device}
    mknod /dev/${device} c $major 0
    chgrp $group /dev/${device}
    chmod $mode  /dev/${device}
else
    echo "No device found in /proc/devices for driver ${module} (this driver may not allocate a device)"
fi