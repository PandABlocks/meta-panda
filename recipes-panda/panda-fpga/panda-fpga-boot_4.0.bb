SUMMARY = "Boot part from PandABlocks-FPGA"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

# PandABox
SRC_URI:pandabox = "https://github.com/PandABlocks/meta-panda/releases/download/4.0alpha1/panda-fpga-boot@PandABox-4.0-35-ged4bb44-dirty.ipk;name=pandabox-boot"
SRC_URI[pandabox-boot.sha256sum] = "820dcd9aef6d07044bc59e720abd40df5622c6d9d256b068f1c28438957483a5"
# XU5 SoC on a ST1 board
SRC_URI:xu5_st1 = "https://github.com/PandABlocks/meta-panda/releases/download/4.0alpha1/panda-fpga-boot@xu5_st1-4.0-35-ged4bb44-dirty.ipk;name=xu5_st1-boot"
SRC_URI[xu5_st1-boot.sha256sum] = "64012c8866876bfd173609d24f92917a19c6c6b32b35088d2c03a4431fb69945"

do_unpack[depends] += "xz-native:do_populate_sysroot"

PROVIDES += "virtual/fsbl"
PROVIDES += "virtual/boot-bin"
PROVIDES += "virtual/bootloader"
PROVIDES += "virtual/dtb"
PROVIDES += "virtual/pmu-firmware"
RPROVIDES:${PN} += "${PN}-bin"

do_install() {
    mkdir -p ${D}/boot
    install -m 0744 ${WORKDIR}/boot/boot.bin ${D}/boot/boot.bin
    install -m 0744 ${WORKDIR}/boot/target-defs ${D}/boot/target-defs
    install -m 0744 ${WORKDIR}/boot/system.dtb ${D}/boot/system.dtb
}

inherit deploy
do_deploy() {
    install -m 0744 ${D}/boot/* ${DEPLOYDIR}/
}
addtask deploy after do_install

FILES:${PN} = "/boot"
