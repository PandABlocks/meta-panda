SUMMARY = "PandABlocks slowfpga bitstream needed for PandABox"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
PACKAGE_ARCH = "${MACHINE_ARCH}"
APP = "slowfpga"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:pandabox = "https://github.com/PandABlocks/PandABlocks-slowFPGA/releases/download/4.0/panda-slowfpga@4.0.zpg"
SRC_URI[sha256sum] = "638a24128a17556cb3848cddbf73016f96fc97d2ba0e695b1eedc7b0629e9240"

fwdir = "/opt/share/panda-fpga-${APP}"

do_install() {
    rm -rf ${WORKDIR}/share
    for file in `find ${WORKDIR} -name '*.zpg'`; do
        cp -f ${file} ${WORKDIR}/panda.tar
        tar -xf ${WORKDIR}/panda.tar -C ${WORKDIR}/
    done
    mkdir -p ${D}/${fwdir}
    cp -rf ${WORKDIR}/share/panda-fpga/* ${D}/${fwdir}/
}

FILES:${PN} += "${fwdir}"
