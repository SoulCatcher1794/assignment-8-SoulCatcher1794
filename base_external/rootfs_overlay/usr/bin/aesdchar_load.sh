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

echo "Load ${module} module, exit on failure"

# Get the kernel version to construct the path to the module
KERNEL_VERSION=$(uname -r)
driver_location=/lib/modules/${KERNEL_VERSION}/extra/

# If driver was found in the location specified, use insmod
if [ -e "${driver_location}${module}.ko" ]; then
    echo "Loading local built file ${module}.ko"
    insmod "${driver_location}${module}.ko" || exit 1
else # Otherwise look for it and run it using modprobe
    echo "Local file ${module}.ko not found, attempting to modprobe"
    modprobe ${module} || exit 1
fi

# Get the major number (allocated with allocate_chrdev_region) from /proc/devices
echo "Get the major number (allocated with allocate_chrdev_region) from /proc/devices"
major=$(awk "\$2==\"$module\" {print \$1}" /proc/devices)
if [ -n "${major}" ]; then
    echo "Remove any existing /dev node for /dev/${device}"
    rm -f /dev/${device}
    echo "Add a node for our device at /dev/${device} using mknod"
    mknod /dev/${device} c "$major" 0
    echo "Change group owner to ${group}"
    chgrp $group /dev/${device}
    echo "Change access mode to ${mode}"
    chmod $mode  /dev/${device}
else
    echo "No device found in /proc/devices for driver ${module} (this driver may not allocate a device)"
fi