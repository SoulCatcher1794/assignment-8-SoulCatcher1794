#!/bin/sh
module=aesdchar
device=aesdchar
mode="664"

set -e
# Group: since distributions do it differently, look for wheel or use staff
if grep -q '^staff:' /etc/group; then
    group="staff"
else
    group="wheel"
fi

# Get the kernel version to construct the path to the module
KERNEL_VERSION=$(uname -r)
driver_location=/lib/modules/${KERNEL_VERSION}/extra/

# If driver was found in the location specified, use insmod
if [ -e "${driver_location}${module}.ko" ]; then
    insmod "${driver_location}${module}.ko" || exit 1
else # Otherwise look for it and run it using modprobe
    modprobe ${module} || exit 1
fi

# Get the major number (allocated with allocate_chrdev_region) from /proc/devices
major=$(awk "\$2==\"$module\" {print \$1}" /proc/devices)
if [ -n "${major}" ]; then
    rm -f /dev/${device}
    mknod /dev/${device} c "$major" 0
    chgrp $group /dev/${device}
    chmod $mode  /dev/${device}
else
    echo "No device found in /proc/devices for driver ${module} (this driver may not allocate a device)"
fi