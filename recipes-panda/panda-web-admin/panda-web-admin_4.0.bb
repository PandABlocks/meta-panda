SUMMARY = "PandABlocks-web-admin"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = " \
    file://panda-web-admin.service \
    file://panda-web-admin.py \
    file://rootfs-version.sh \
    file://quickstart.md \
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
    file://panda-webcontrol.service \
    file://panda-webcontrol-wrapper \
    file://panda-webcontrol.py \
    file://panda-webcontrol.nav.html \
"
S = "${WORKDIR}"

inherit python3native
DEPENDS = " \
    python3-mistune-native \
"
RDEPENDS:${PN} = " \
    bash \
    python3-cothread \
    python3-numpy \
    python3-panda-malcolm \
    python3-tornado \
"

inherit systemd
SYSTEMD_SERVICE:${PN} = " \
    panda-web-admin.service \
    panda-webcontrol.service \
"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}/${systemd_system_unitdir} ${D}/${bindir}
    install -d ${D}/${datadir}/web-admin
    install -m 0644 ${WORKDIR}/panda-web-admin.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/panda-web-admin.py ${D}/${bindir}
    install -m 0755 ${WORKDIR}/rootfs-version.sh ${D}/${bindir}
    cp -r ${WORKDIR}/templates ${D}/${datadir}/web-admin
    cp -r ${WORKDIR}/static ${D}/${datadir}/web-admin
    cat <<EOF > ${D}/${datadir}/web-admin/static/rootfs-quickstart.html
<html lang="en">
  <head>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">
    <meta name="theme-color" content="#000000">
    <title>PandA Rootfs Quickstart</title>
    <link href="style.css" rel="stylesheet" type="text/css" />
  </head>
  <body class="dark">
EOF
    python3 <<EOF
import mistune
with open('${WORKDIR}/quickstart.md', 'r') as f:
    output = mistune.markdown(f.read())
with open('${D}/${datadir}/web-admin/static/rootfs-quickstart.html', 'a') as f:
    f.write(output)
EOF
    echo '</body></html>' >> \
        ${D}/${datadir}/web-admin/static/rootfs-quickstart.html
    # Webcontrol part
    install -m 0644 ${WORKDIR}/panda-webcontrol.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/panda-webcontrol.py ${D}/${bindir}
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
