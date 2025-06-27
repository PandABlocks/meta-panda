SUMMARY = "Panda scripts to deal with FMC EEPROMSs"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

inherit python_setuptools_build_meta

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI = "file://pandai2c"
S = "${WORKDIR}/pandai2c"
RDEPENDS:${PN} += "${PYTHON_PN}-numpy"
