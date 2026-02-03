SUMMARY = "PandABlocks-server associated driver"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=e3fc50a88d0a364313df4b21ef20c29e"

inherit module

DEPENDS = "python3"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
    git://github.com/PandABlocks/PandABlocks-server;branch=main;protocol=https \
    file://CONFIG_driver \
"
SRCREV = "2a34851b2d1f13d64f92540b5f03a98e21b00222"
S = "${WORKDIR}/git"
MAKE_TARGETS = "driver"
MODULES_MODULE_SYMVERS_LOCATION = "build/driver"

do_configure() {
    cp -f ${WORKDIR}/CONFIG_driver ${S}/CONFIG
    echo "PLATFORM = ${PLATFORM}" >> ${S}/CONFIG
}
