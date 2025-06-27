SUMMARY = "PandABlocks-webcontrol package"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = " \
    https://github.com/PandABlocks/PandABlocks-webcontrol/releases/download/4.0/panda-webcontrol@4.0.zpg \
    file://nav.html \
    file://panda-webcontrol.service \
    file://panda-webcontrol-wrapper \
"
SRC_URI[sha256sum] = "61e3617d43ca89772fd53fcbbfbeec06ca1bbdd16b7128c7357d04bd11986079"
S = "${WORKDIR}"

RDEPENDS:${PN} = " \
    bash \
    python3-cothread \
    python3-numpy \
    python3-tornado \
    python3-panda-malcolm \
"

do_patch() {
}

do_install() {
    rm -rf ${WORKDIR}/share ${WORKDIR}/bin ${WORKDIR}/lib
    for file in `find ${WORKDIR} -name '*.zpg'`; do
        cp -f ${file} ${WORKDIR}/panda.tar
        tar -xf ${WORKDIR}/panda.tar -C ${WORKDIR}/
    done
    mkdir -p ${D}/opt/share ${D}/opt/bin ${D}/${bindir}
    cp -rf ${WORKDIR}/share/panda-webcontrol ${D}/opt/share
    cp -rf ${WORKDIR}/share/www ${D}/opt/share
    cp -rf ${WORKDIR}/bin/* ${D}/opt/bin
    cp -rf ${WORKDIR}/nav.html ${D}/opt/share/panda-webcontrol/templates
    cp -rf ${WORKDIR}/etc/www ${D}/opt/share/panda-webcontrol/etc_www
    install -m 0755 ${WORKDIR}/panda-webcontrol-wrapper ${D}/${bindir}
    sed -i '1 i #!/usr/bin/env python' ${D}/opt/bin/panda-webcontrol.py
    sed -i 's|code\.interact.*|import cothread; cothread.WaitForQuit()|' ${D}/opt/bin/panda-webcontrol.py
    chmod 755 ${D}/opt/bin/panda-webcontrol.py
    install -d ${D}/${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/panda-webcontrol.service ${D}/${systemd_system_unitdir}
}

inherit systemd
SYSTEMD_SERVICE:${PN} = "panda-webcontrol.service"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

FILES:${PN} += "${bindir} /opt/bin /opt/share/panda-webcontrol"
FILES:${PN}-doc += "/opt/share/www"
