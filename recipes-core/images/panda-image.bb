inherit core-image
inherit plnx-image

IMAGE_NAME = "packages"
IMAGE_NAME_SUFFIX = ""
IMAGE_INSTALL = " \
    packagegroup-core-boot \
    ${CORE_IMAGE_EXTRA_INSTALL} \
    kernel-modules \
    led-daemon \
    packagegroup-panda-fpga \
    panda-config \
    panda-server \
    panda-webcontrol \
    panda-docs \
    bridge-utils \
    fpga-manager-script \
    htop \
    iperf3 \
    i2c-tools \
    linux-xlnx-udev-rules \
    mtd-utils \
    pciutils \
    perf \
    tcf-agent \
    tmux \
"
GLIBC_GENERATE_LOCALES = "en_GB.UTF-8 en_US.UTF-8"
IMAGE_LINGUAS = "en-gb en-us"
IMAGE_FSTYPES = "squashfs squashfs.md5sum"
KERNEL_IMAGETYPES = "uImage"
ROOTFS_POSTPROCESS_COMMAND += "rm_boot_directory;"
rm_boot_directory() {
  rm -rf ${IMAGE_ROOTFS}/boot/*
}
