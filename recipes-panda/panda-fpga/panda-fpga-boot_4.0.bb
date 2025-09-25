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

PACKAGE_ARCH = "${MACHINE_ARCH}"

do_install() {
    mkdir -p ${D}/boot/devicetree
    install -m 0644 ${WORKDIR}/boot/boot.bin ${D}/boot/boot.bin
    install -m 0644 ${WORKDIR}/boot/target-defs ${D}/boot/target-defs
    install -m 0644 ${WORKDIR}/boot/system.dtb ${D}/boot/devicetree/system.dtb
}

inherit deploy
do_deploy() {
    mkdir -p ${DEPLOYDIR}/devicetree
    install -m 0744 ${D}/boot/boot.bin ${DEPLOYDIR}/
    install -m 0744 ${D}/boot/target-defs ${DEPLOYDIR}/
    install -m 0744 ${D}/boot/devicetree/system.dtb ${DEPLOYDIR}/devicetree
}
addtask deploy after do_install

SYSROOT_DIRS += "/boot/devicetree"
FILES:${PN} = "/boot/boot.bin /boot/target-defs /boot/devicetree/system.dtb"
