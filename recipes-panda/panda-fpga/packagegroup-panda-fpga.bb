DESCRIPTION = "Panda FPGA packages for a specific machine"

inherit packagegroup

RDEPENDS:${PN} = " \
    panda-fpga-loader \
    panda-fpga-no-fmc \
"
RDEPENDS:${PN}:append:pandabox = " \
    panda-fpga-slowfpga \
    panda-fpga-fmc-acq430 \
    panda-fpga-fmc-acq427 \
    panda-fpga-fmc-24vio \
    panda-fpga-fmc-lback-sfp-lback \
"

RDEPENDS:${PN}:append:xu5_st1 = " \
    panda-fpga-fmc-acq430 \
"
