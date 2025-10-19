#!/usr/bin/env bash
cd "$(dirname "$0")"
META_DIR="$(pwd)"

export KAS_MACHINE=${1}
export KAS_WORK_DIR=${2:-$PWD}
export KAS_IMAGE_VERSION="4.8"
if [ -z "${KAS_MACHINE}" ]; then
    echo "Usage: $0 <machine> [<work_dir>]"
    exit 1
fi

function error {
    echo >&2 "$@"
    exit 1
}

kas-container build ./kas.yml || error "kas build failed"
cd ${KAS_WORK_DIR}
BOOT_DIR=boot-${KAS_MACHINE}
mkdir -p ${BOOT_DIR}
cp -Lf build/tmp/deploy/images/${KAS_MACHINE}/fitImage-petalinux-initramfs-image-${KAS_MACHINE}-${KAS_MACHINE} ${BOOT_DIR}/image.ub &&
cp -f build/tmp/deploy/images/${KAS_MACHINE}/{rootfs.squashfs,boot.bin,boot.scr,target-defs} ${BOOT_DIR}/ && cd ${BOOT_DIR} &&
tar cvzf ${META_DIR}/boot-${KAS_MACHINE}.tar.gz *
