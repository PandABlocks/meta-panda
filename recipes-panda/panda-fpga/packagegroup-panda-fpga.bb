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

RDEPENDS:${PN}:append:pandabox2 = " \
    panda-fpga-pandabox2-no-fmc \
    panda-fpga-pandabox2-fmc-acq430 \
    panda-fpga-pandabox2-fmc-lback-sfp-sync \
"

RDEPENDS:${PN}:append:pandabrick = " \
    panda-fpga-pandabrick \
"

RDEPENDS:${PN}:append:xu5 = " \
    panda-fpga-xu5-no-fmc \
"

RDEPENDS:${PN}:append:zedboard = " \
    panda-fpga-zedboard-no-fmc \
"
