SUMMARY = "This package is for fetching, building and installing the PandABlocks-server on the initramfs"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

SRC_URI:append = " \
    file://panda-server.service \
    file://panda-extension-server.service \
    file://panda-server-wrapper \
    file://panda-extension-server-wrapper \
"

inherit python3native

DEPENDS = " \
    python3-sphinx-native \
    python3-docutils-native \
    python3-six-native \
    python3-sphinx-rtd-theme-native \
    python3-babel-native \
    python3-jinja2-native \
    python3-pygments-native \
    python3-imagesize-native \
"
RDEPENDS:${PN} += "kernel-module-panda python3"

do_configure() {
    cp -f ${WORKDIR}/CONFIG ${S}
}

do_install() {
    install -d ${D}/${bindir}
    install -m 0755 ${S}/build/server/server ${D}/${bindir}/panda-server
    install -m 0755 ${S}/python/extension_server ${D}/${bindir}/panda-extension-server
    install -m 0755 ${S}/build/server/slow_load ${D}/${bindir}/panda-slow-load
    install -d ${D}/${systemd_system_unitdir} ${D}/${bindir}
    install -m 0644 ${WORKDIR}/panda-server.service ${D}/${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/panda-extension-server.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/panda-extension-server-wrapper ${D}/${bindir}
    install -m 0755 ${WORKDIR}/panda-server-wrapper ${D}/${bindir}
    install -d ${D}/opt/share/www
    cp -r ${S}/build/html ${D}/opt/share/www/panda-server
}

inherit systemd
SYSTEMD_SERVICE:${PN} = " \
    panda-server.service \
    panda-extension-server.service \
"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

FILES:${PN} += "${bindir}"
FILES:${PN}-doc += "/opt/share/www"
