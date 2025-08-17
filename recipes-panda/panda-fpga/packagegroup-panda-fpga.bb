DESCRIPTION = "Panda FPGA packages for a specific machine"

inherit packagegroup

RDEPENDS:${PN} = " \
    panda-fpga-loader \
    panda-fpga-boot \
"
