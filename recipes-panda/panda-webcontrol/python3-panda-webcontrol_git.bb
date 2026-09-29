SUMMARY = "PandABlocks-webcontrol python package"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit setuptools3

FILESEXTRAPATHS:prepend := "${THISDIR}/files:${THISDIR}/../../:"
SRC_URI += " \
    git://github.com/PandABlocks/PandABlocks-webcontrol;branch=main;protocol=https \
    file://panda-webcontrol.service \
    file://panda-webcontrol-wrapper \
    file://panda-webcontrol.nav.html \
"
require recipes-panda/panda-webcontrol-generated/panda-webcontrol-release.inc
S = "${WORKDIR}/git"

RDEPENDS:${PN} += " \
    python3-numpy \
    python3-tornado \
"

do_patch() {
    sed -i 's/"footerHeight": [0-9]\+/"footerHeight": 45/' ${S}/malcolm/modules/web/www/settings.json
}

do_install:append() {
    install -d ${D}/${systemd_system_unitdir} ${D}/${bindir}
    install -m 0644 ${WORKDIR}/panda-webcontrol.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/panda-webcontrol-wrapper ${D}/${bindir}
    mkdir -p ${D}/opt/etc/www
    install -m 0644 ${WORKDIR}/panda-webcontrol.nav.html ${D}/opt/etc/www
}

inherit systemd
SYSTEMD_SERVICE:${PN} = " \
    panda-webcontrol.service \
"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

FILES:${PN} += " \
    ${bindir} \
    ${datadir} \
    /opt/etc/www \
"
