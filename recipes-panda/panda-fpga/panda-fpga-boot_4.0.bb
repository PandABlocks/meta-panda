SUMMARY = "Boot part from PandABlocks-FPGA"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

include panda-fpga-boot-uris.inc

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
