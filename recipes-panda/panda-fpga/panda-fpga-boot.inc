SUMMARY = "Boot part from PandABlocks-FPGA"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

# The SRC_URI for the machines in the current PandABlocks-FPGA release is set by
# the generated recipe that requires this file (see fetch-fpga-ipks.py).  The
# experimental boards below are not part of that release, so they keep their
# hand-pinned URLs; the ;name= parameter is what ties each URL to its checksum.
# XU5 SoC on a ST1 board
SRC_URI:xu5 = "https://github.com/PandABlocks/meta-panda/releases/download/4.2b1/panda-fpga-boot_xu5-4.1-29-g950117b-dirty_all.ipk;name=xu5-boot"
SRC_URI[xu5-boot.sha256sum] = "e1c7cc941447266f69529486ae1a6c7ae6526349874b1452c4f20d77a2336dba"
# Zedboard
SRC_URI:zedboard = "https://github.com/PandABlocks/meta-panda/releases/download/4.2b1/panda-fpga-boot_zedboard-4.1-29-g950117b-dirty_all.ipk;name=zedboard-boot"
SRC_URI[zedboard-boot.sha256sum] = "484b0e73adc4e772b7d8c284b947fd0e8d49a66a93b594fa129e944a44689d71"

do_unpack[depends] += "xz-native:do_populate_sysroot"

# With no SRC_URI for this machine do_unpack quietly does nothing, and the
# failure surfaces much later as a missing boot.bin, which reads like a corrupt
# ipk rather than a missing build step.  Say what actually went wrong.
python do_unpack:prepend() {
    if not d.getVar('SRC_URI'):
        bb.fatal("no boot ipk for MACHINE '%s'. Run ./fetch-fpga-ipks.py to "
                 "populate ipks/ and regenerate the panda-fpga recipes."
                 % d.getVar('MACHINE'))
}

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
