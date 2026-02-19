#!/bin/sh
# Shared definitions for buildroot scripts

# Shared download directory for Buildroot packages
export BR2_DL_DIR=${HOME}/.dl
mkdir -p ${BR2_DL_DIR}

# Enable compiler cache to speed up rebuilds
export BR2_CCACHE=y
export BR2_CCACHE_DIR=${HOME}/.buildroot-ccache
mkdir -p ${BR2_CCACHE_DIR}

# Set ccache size limit (default is 1GB, increase for larger projects)
export BR2_CCACHE_SIZE=5G

# The defconfig from the buildroot directory we use for qemu builds
QEMU_DEFCONFIG=configs/qemu_aarch64_virt_defconfig
# The place we store customizations to the qemu configuration
MODIFIED_QEMU_DEFCONFIG=base_external/configs/aesd_qemu_defconfig
# The defconfig from the buildroot directory we use for the project
AESD_DEFAULT_DEFCONFIG=${QEMU_DEFCONFIG}
AESD_MODIFIED_DEFCONFIG=${MODIFIED_QEMU_DEFCONFIG}
AESD_MODIFIED_DEFCONFIG_REL_BUILDROOT=../${AESD_MODIFIED_DEFCONFIG}
