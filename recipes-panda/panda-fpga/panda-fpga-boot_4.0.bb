SUMMARY = "Boot part from PandABlocks-FPGA"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
PACKAGE_ARCH = "${MACHINE_ARCH}"

# PandABox
SRC_URI:pandabox = "https://github.com/PandABlocks/PandABlocks-FPGA/releases/download/4.0/boot@PandABox-4.0.zip;name=pandabox-boot"
SRC_URI[pandabox-boot.sha256sum] =  "58f55a4d9530fdf465481022a96b01aae11771a29404e0916628e675326fb663"
# XU5 SoC a on ST1 board
SRC_URI:xu5_st1 = "https://github.com/PandABlocks/PandABlocks-FPGA/releases/download/4.0/boot@xu5_st1-4.0.zip;name=xu5_st1-boot"
SRC_URI[xu5_st1-boot.sha256sum] = "ca5c7d65e72c89de7c38e22cac8779b63ace78b95c512ab62609b049067d8595"

PROVIDES += "virtual/fsbl"
PROVIDES += "virtual/boot-bin"
PROVIDES += "virtual/bootloader"
PROVIDES += "virtual/dtb"
PROVIDES += "virtual/pmu-firmware"
RPROVIDES:${PN} += "${PN}-bin"

do_install() {
    mkdir -p ${D}/boot/
    install -m 0744 ${WORKDIR}/boot.bin ${D}/boot/boot.bin
    install -m 0744 ${WORKDIR}/target-defs ${D}/boot/target-defs
    install -m 0744 ${WORKDIR}/devicetree.dtb ${D}/boot/system.dtb
}

inherit deploy
do_deploy() {
    install -m 0744 ${D}/boot/* ${DEPLOYDIR}/
}
addtask deploy after do_install

FILES:${PN} = "/boot"
