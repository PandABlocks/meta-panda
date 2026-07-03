SUMMARY = "Service and start-up scripts for PandABlocks"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = " \
    file://panda-config.service \
    file://panda-config \
    file://99-automount-usb.rules \
    file://sysstat-collect.timer \
    file://sysstat-collect.service \
"

RDEPENDS:${PN} = "bash"

inherit systemd

SYSTEMD_SERVICE:${PN} = "panda-config.service sysstat-collect.timer sysstat-collect.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}/${systemd_system_unitdir} ${D}/${bindir} ${D}/etc/udev/rules.d
    install -m 0644 ${WORKDIR}/panda-config.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/panda-config ${D}/${bindir}
    install -m 0666 ${WORKDIR}/99-automount-usb.rules \
        ${D}/etc/udev/rules.d/99-automount-usb.rules
    install -m 0644 ${WORKDIR}/sysstat-collect.service ${D}/${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/sysstat-collect.timer ${D}/${systemd_system_unitdir}

}

FILES:${PN} += "/etc/udev/rules.d/"
