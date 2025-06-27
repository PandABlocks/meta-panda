SUMMARY = "PandABlocks-server associated driver"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit module

DEPENDS = "python3"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
    git://github.com/PandABlocks/PandABlocks-server;branch=master;protocol=https \
    file://CONFIG \
    file://0001-Minor-build-improvements.patch \
"
SRCREV = "8debbfa3b9ca964cbb583d4259917aefaa131e66"
S = "${WORKDIR}/git"
MAKE_TARGETS = "driver"
MODULES_MODULE_SYMVERS_LOCATION = "build/driver"

do_configure() {
    cp -f ${WORKDIR}/CONFIG ${S}/
}
