SUMMARY = "Boot part from PandABlocks-FPGA"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

# SRC_URI is set per machine by the generated recipe that requires this file
# (see fetch-fpga-ipks.py), from whatever boot ipks are in ipks/.

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
