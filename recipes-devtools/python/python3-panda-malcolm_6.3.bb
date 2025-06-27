SUMMARY = "Pymalcolm python package"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit pypi setuptools3

MALCOLM_JS_VERSION="1.7.12-0-g4e5e25f"
SRC_URI += " \
    https://github.com/DiamondLightSource/malcolmjs/releases/download/1.7.12/malcolmjs-${MALCOLM_JS_VERSION}.tar.gz;name=malcolmjs;subdir=malcolmjs \
    file://0001-Add-hack-to-work-around-broken-annotypes-in-python-3.patch \
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
    cp -rf ${WORKDIR}/malcolmjs/* ${S}/malcolm/modules/web/www/
    echo '{ "version": "", "title": "PandA Web Control", "footerHeight": 45}' > ${S}/malcolm/modules/web/www/settings.json
}
