DESCRIPTION = "Panda FPGA packages for a specific machine"

inherit packagegroup

RDEPENDS:${PN} = " \
    panda-fpga-boot \
    panda-fpga-loader \
    panda-fpga-doc \
"
RDEPENDS:${PN}:append:pandabox = " \
    panda-fpga-pandabox-no-fmc \
    panda-slowfpga \
    panda-fpga-pandabox-fmc-24vio \
    panda-fpga-pandabox-fmc-acq427 \
    panda-fpga-pandabox-fmc-acq430 \
    panda-fpga-pandabox-fmc-lback-sfp-lback \
"

RDEPENDS:${PN}:append:xu5_st1 = " \
    panda-fpga-xu5-st1-no-fmc \
    panda-fpga-xu5-st1-fmc-acq430 \
"
