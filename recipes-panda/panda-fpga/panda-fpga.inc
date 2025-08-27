SUMMARY = "PandABlocks-FPGA machine-dependent package"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

do_unpack[depends] += "xz-native:do_populate_sysroot"

do_install() {
    cp -rf ${WORKDIR}/opt ${D}/
}

FILES:${PN} += "/opt"
