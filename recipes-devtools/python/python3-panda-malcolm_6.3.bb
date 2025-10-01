SUMMARY = "Pymalcolm python package"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit pypi setuptools3

SRC_URI += " \
    file://0001-Add-hack-to-work-around-broken-annotypes-in-python-3.patch \
    file://favicon.ico \
"
SRC_URI[malcolmjs.sha256sum] = "701a5aa7031809e6e4baacd84161bd14781145aa4db568e6fba95f38fbfda7bb"
SRC_URI[sha256sum] = "2e65337121af02b801fded4d3b20a7ac3e01d76c6b8d06401e6564a03dc9fd73"
PYPI_PACKAGE = "malcolm"
RDEPENDS:${PN} += " \
    python3-annotypes \
    python3-cothread \
    python3-tornado \
"

do_configure() {
    echo '{ "version": "", "title": "PandA Web Control", "footerHeight": 45}' > ${S}/malcolm/modules/web/www/settings.json
    cp ${WORKDIR}/favicon.ico ${S}/malcolm/modules/web/www
}

do_install:append() {
    mkdir -p ${D}/${datadir}/web-admin/templates
    cp -f ${S}/malcolm/modules/web/www/index.html \
        ${D}/${datadir}/web-admin/templates/webcontrol-withoutnav.html

    template='{% raw admin_loader.load("nav.html").generate(active="panda-webcontrol", etc_loader=etc_loader, request=request) %}'
    sed -e "s|</body>|$template</body>|" \
        ${S}/malcolm/modules/web/www/index.html > \
        ${D}/${datadir}/web-admin/templates/webcontrol-index.html
}

FILES:${PN} += "${datadir}/web-admin/templates"
