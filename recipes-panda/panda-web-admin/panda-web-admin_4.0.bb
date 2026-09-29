SUMMARY = "PandABlocks-web-admin"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:${THISDIR}/../../:"
SRC_URI = " \
    file://panda-web-admin.socket \
    file://panda-web-admin.service \
    file://panda-web-admin.py \
    file://panda-web-admin-sar-report.py \
    file://rootfs-version.sh \
    file://static/favicon.ico \
    file://static/PandA-logo-for-black-background.svg \
    file://static/style.css \
    file://templates/button.html \
    file://templates/docs.html \
    file://templates/drawer.html \
    file://templates/form_select.html \
    file://templates/header.html \
    file://templates/footer.html \
    file://templates/index.html \
    file://templates/nav.html \
    file://panda-fpga.docs.html.in \
    file://fpga-release.txt \
    file://README.rst \
"
S = "${WORKDIR}"

inherit python3native
DEPENDS = " \
    python3-docutils-native \
    python3-jinja2-native \
    python3-requests-native \
    python3-six-native \
    python3-sphinx-native \
    python3-sphinx-rtd-theme-native \
"
RDEPENDS:${PN} = " \
    bash \
    python3-tornado \
"

inherit systemd
SYSTEMD_SERVICE:${PN} = " \
    panda-web-admin.socket \
    panda-web-admin.service \
"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}/${systemd_system_unitdir} ${D}/${bindir}
    install -d ${D}/${datadir}/web-admin
    install -m 0644 ${WORKDIR}/panda-web-admin.socket ${D}/${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/panda-web-admin.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/panda-web-admin.py ${D}/${bindir}
    install -m 0755 ${WORKDIR}/panda-web-admin-sar-report.py ${D}/${bindir}
    install -m 0755 ${WORKDIR}/rootfs-version.sh ${D}/${bindir}
    cp -r ${WORKDIR}/templates ${D}/${datadir}/web-admin
    cp -r ${WORKDIR}/static ${D}/${datadir}/web-admin

    # The docs page renders every *.docs.html in /opt/etc/www.  The FPGA docs
    # live on GitHub Pages, one site per release, so the link has to name the
    # release this image was built against -- which is the one pinned in the
    # top-level fpga-release.txt that fetch-fpga-ipks.py reads.
    install -d ${D}/opt/etc/www
    sed "s|@FPGA_RELEASE@|$(cat ${WORKDIR}/fpga-release.txt)|g" \
        ${WORKDIR}/panda-fpga.docs.html.in > ${D}/opt/etc/www/panda-fpga.docs.html
    chmod 0644 ${D}/opt/etc/www/panda-fpga.docs.html
}

FILES:${PN} += " \
    ${bindir} \
    ${datadir} \
    /opt/etc/www \
"
