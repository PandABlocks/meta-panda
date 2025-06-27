SUMMARY = "Service and start-up scripts to load the FPGA for PandABlocks"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = " \
    file://panda-fpga.service \
    file://panda-load-firmware \
"

RDEPENDS:${PN} = "pandai2c bash kernel-module-panda"

do_install() {
    install -d ${D}/${systemd_system_unitdir} ${D}/${bindir}
    install -m 0644 ${WORKDIR}/panda-fpga.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/panda-load-firmware ${D}/${bindir}
}

inherit systemd
SYSTEMD_SERVICE:${PN} = "panda-fpga.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"
