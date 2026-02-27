#!/bin/sh

# This script is used to load the ldd modules at boot time. 
# It is placed in the rootfs_overlay directory and will be copied to the root filesystem during the build process.

case "$1" in
start)
echo "--- Starting init script for Module Loading ---"
scull_load.sh
module_load.sh faulty
modprobe hello
aesdchar_load.sh
;;
stop)
echo "Removing user modules"
aesdchar_unload.sh
rmmod hello
module_unload.sh faulty
scull_unload.sh
;;
*)
echo "Usage: $0 {start|stop}"
exit 1
esac
exit 0