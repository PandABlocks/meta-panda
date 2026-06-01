SUMMARY = "PandABlocks-webcontrol"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:${THISDIR}/../../:"
SRC_URI = " \
    file://panda-webcontrol.service \
    file://panda-webcontrol-wrapper \
    file://panda-webcontrol.py \
    file://panda-webcontrol.nav.html \
"

S = "${WORKDIR}"

RDEPENDS:${PN} = " \
    bash \
    python3-cothread \
    python3-numpy \
    python3-panda-malcolm \
    python3-tornado \
"

inherit systemd
SYSTEMD_SERVICE:${PN} = " \
    panda-webcontrol.service \
"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}/${systemd_system_unitdir} ${D}/${bindir}
    install -m 0644 ${WORKDIR}/panda-webcontrol.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/panda-webcontrol-wrapper ${D}/${bindir}
    install -m 0755 ${WORKDIR}/panda-webcontrol.py ${D}/${bindir}
    mkdir -p ${D}/opt/etc/www
    install -m 0644 ${WORKDIR}/panda-webcontrol.nav.html ${D}/opt/etc/www
}

FILES:${PN} += " \
    ${bindir} \
    ${datadir} \
    /opt/etc/www \
"
