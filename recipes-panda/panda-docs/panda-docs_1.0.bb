SUMMARY = "HTTP server service file to show documentation"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = " \
    file://panda-docs.service \
    file://index.html \
    file://panda-rootfs-faq.html \
    file://style.css \
"

RDEPENDS:${PN} = " \
    python3 \
    panda-fpga-no-fmc-doc \
    panda-server-doc \
    panda-webcontrol-doc \
"

do_install() {
    install -d ${D}/${systemd_system_unitdir} ${D}/opt/share/www
    install -m 0644 ${WORKDIR}/panda-docs.service ${D}/${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/index.html ${D}/opt/share/www
    install -m 0644 ${WORKDIR}/style.css ${D}/opt/share/www
    install -m 0644 ${WORKDIR}/panda-rootfs-faq.html ${D}/opt/share/www
}

inherit systemd
SYSTEMD_SERVICE:${PN} = "panda-docs.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"
FILES:${PN} += "/opt/share/www"
