SUMMARY = "Boot part from PandABlocks-FPGA"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"
PACKAGE_ARCH = "${MACHINE_ARCH}"

GITHUB_BASE_URI = "https://github.com/PandABlocks/PandABlocks-FPGA/releases/"
SRC_URI:append:panda-zedboard = " \
    file:///scratch/panda/fpga/ZedBoard-no-fmc/boot@ZedBoard-4.0-28-g6f788ae-dirty.zip \
"
# PandABox
PANDABOX_BOOT_URL = "https://github.com/PandABlocks/PandABlocks-FPGA/releases/download/4.0/boot@PandABox-4.0.zip;name=pandabox-boot"
PANDABOX_BOOT_SHA256 = "58f55a4d9530fdf465481022a96b01aae11771a29404e0916628e675326fb663"
SRC_URI:pandabox = "${@d.getVar('BOOT_ZIP') or d.expand('${PANDABOX_BOOT_URL}')}"
SRC_URI[pandabox-boot.sha256sum] =  "${@d.getVar('BOOT_ZIP_SHA256') or d.expand('${PANDABOX_BOOT_SHA256}')}"
# XU5 SoC a on ST1 board
XU5_ST1_BOOT_URL = "https://github.com/PandABlocks/PandABlocks-FPGA/releases/download/4.0/boot@xu5_st1-4.0.zip;name=xu5_st1-boot"
XU5_ST1_BOOT_SHA256 = "ca5c7d65e72c89de7c38e22cac8779b63ace78b95c512ab62609b049067d8595"
SRC_URI:xu5_st1 = "${@d.getVar('BOOT_ZIP') or d.expand('${XU5_ST1_BOOT_URL}')}"
SRC_URI[xu5_st1-boot.sha256sum] = "${@d.getVar('BOOT_ZIP_SHA256') or d.expand('${XU5_ST1_BOOT_SHA256}')}"

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
