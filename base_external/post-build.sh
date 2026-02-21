#!/bin/bash

# Post-build script for setting file permissions

# Set execute permissions on init scripts
chmod 0755 $TARGET_DIR/etc/init.d/S98lddmodules.sh

# Ensure helper scripts in /usr/bin are executable
chmod 0755 $TARGET_DIR/usr/bin/*.sh

exit 0
