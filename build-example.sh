#!/usr/bin/env bash
BRANCH="rel-v2023.2"
DIR=$PWD

fail()
{
    echo >&2 "$@"
    exit 1
}

if [[ $# -ne 2 ]]; then
    echo "Usage: $0 <machine> <work-folder>"
    echo "Where <machine> can be: pandabox or xu5-st1"
    echo "The build output will appear in <work-folder>/boot-\$MACHINE"
    exit 1
fi

MACHINE="$1"
DOWNLOADS="$2/downloads"
SSTATE="$2/sstate-cache"
TMP="$2/tmp"
BUILDDIR="$2/build"
OUTPUTDIR="$2/boot-$MACHINE"

type repo || fail "Please install repo tool"
yes | repo init -u https://github.com/Xilinx/yocto-manifests.git -b $BRANCH
repo sync

(
    cd sources
    git clone -b $BRANCH https://github.com/PandABlocks/meta-panda
)

mkdir -p $DOWNLOADS $SSTATE $TMP $BUILDDIR $OUTPUTDIR

. setupsdk $BUILDDIR

cat <<EOF > conf/local.conf
MACHINE = "$MACHINE"
DISTRO = "panda-petalinux"
DL_DIR = "$DOWNLOADS"
SSTATE_DIR = "$SSTATE"
TMPDIR = "$TMP"
INHERIT += "rm_work"
CONF_VERSION = "2"
RM_OLD_IMAGE = "1"
USER_CLASSES ?= "buildstats"
LICENSE_CREATE_PACKAGE = "1"
COPY_LIC_MANIFEST = "1"
CONNECTIVITY_CHECK_URIS ?= ""
BB_GENERATE_MIRROR_TARBALLS ?= "1"
PATCHRESOLVE = "noop"
PACKAGECONFIG:append:pn-qemu-system-native = " sdl"
BB_HASHSERVE = ""
BB_SIGNATURE_HANDLER = "OEBasicHash"
PRSERV_HOST = "localhost:0"
LICENSE_FLAGS_ACCEPTED = " \\
        commercial_\${MLPREFIX}ffmpeg \\
        commercial_\${MLPREFIX}x264 \\
        commercial_\${MLPREFIX}gstreamer1.0-omx \\
        commercial_\${MLPREFIX}libomxil \\
        commercial_\${MLPREFIX}sox \\
        commercial_\${MLPREFIX}faac \\
        commercial_\${MLPREFIX}faad2 \\
        xilinx "
EOF

bitbake-layers add-layer $DIR/sources/meta-panda

bitbake panda-image &&
    cp -Lf $TMP/deploy/images/$MACHINE/uImage-initramfs-$MACHINE $OUTPUTDIR/uImage &&
    cp -f $TMP/deploy/images/$MACHINE/rootfs.squashfs $OUTPUTDIR/ &&
    cp -f $TMP/deploy/images/$MACHINE/{boot.bin,boot.scr,target-defs,system.dtb} $OUTPUTDIR/ &&
    zip boot-$MACHINE.zip $OUTPUTDIR/*
