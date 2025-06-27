SUMMARY = "Initramfs init script for PandA"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit allarch

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = " file://pinit"

do_install() {
    install -d ${D}/init.d
    install -m 0755 ${WORKDIR}/pinit ${D}/init.d/01-init
}

FILES:${PN} = "/init.d"
