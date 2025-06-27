SUMMARY = "LED daemon and control command"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
inherit systemd

SRC_URI = " \
    file://led-daemon \
    file://led-daemon.service \
    file://set-led \
"

RDEPENDS:${PN} = "busybox"

SYSTEMD_SERVICE:${PN} = "led-daemon.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}/${systemd_system_unitdir} ${D}/${bindir}
    install -m 0644 ${WORKDIR}/led-daemon.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/led-daemon ${D}/${bindir}
    install -m 0755 ${WORKDIR}/set-led ${D}/${bindir}
}
