inherit core-image
inherit plnx-image

IMAGE_NAME = "rootfs"
IMAGE_NAME_SUFFIX = ""
DISTRO_FEATURES:remove = "x11"
IMAGE_FEATURES:remove = "splash"
IMAGE_INSTALL = " \
    packagegroup-core-boot \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    kernel-modules \
    led-daemon \
    packagegroup-panda-fpga \
    panda-config \
    panda-server \
    panda-web-admin \
    panda-webcontrol \
    bridge-utils \
    fpga-manager-script \
    git-revision-file \
    htop \
    iperf3 \
    i2c-tools \
    linux-xlnx-udev-rules \
    mtd-utils \
    pciutils \
    perf \
    stress-ng \
    squashfs-tools \
    sysstat \
    tcf-agent \
    tmux \
"
GLIBC_GENERATE_LOCALES = "en_GB.UTF-8 en_US.UTF-8"
IMAGE_LINGUAS = "en-gb en-us"
IMAGE_FSTYPES = "squashfs squashfs.md5sum"
ROOTFS_POSTPROCESS_COMMAND += "rm_boot_directory;"
rm_boot_directory() {
  rm -rf ${IMAGE_ROOTFS}/boot/*
}

require panda-image-sdk.inc
