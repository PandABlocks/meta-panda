SUMMARY = "PandABlocks-FPGA machine-dependent package"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
PACKAGE_ARCH = "${MACHINE_ARCH}"
PACKAGES = "${PN} ${PN}-doc"

fwdir = "/opt/share/panda-fpga-${APP}"

do_install() {
    rm -rf ${WORKDIR}/share ${WORKDIR}/bin ${WORKDIR}/lib
    for file in `find ${WORKDIR} -name '*.zpg'`; do
        cp -f ${file} ${WORKDIR}/panda.tar
        tar -xf ${WORKDIR}/panda.tar -C ${WORKDIR}/
    done
    rm -f ${WORKDIR}/share/panda-fpga/load-panda-firmware
    mkdir -p ${D}/${fwdir}
    cp -rf ${WORKDIR}/share/panda-fpga/* ${D}/${fwdir}
    cp -rf ${WORKDIR}/share/template_designs ${D}/${fwdir}
    # Install the documentation
    install -d ${D}/opt/share/www/
    cp -rf ${WORKDIR}/share/www/panda-fpga ${D}/opt/share/www/
}

FILES:${PN} += "${fwdir}"
FILES:${PN}-doc = "/opt/share/www"
