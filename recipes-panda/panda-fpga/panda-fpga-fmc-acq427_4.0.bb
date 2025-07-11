require panda-fpga.inc

APP = "fmc_acq427"
SRC_URI:pandabox = "https://github.com/PandABlocks/PandABlocks-FPGA/releases/download/4.0/panda-fpga@PandABox-fmc_acq427-4.0.zpg;name=pandabox-fmc_acq427"
SRC_URI[pandabox-fmc_acq427.sha256sum] = "bec05e9bbc30bc4da92c8cc8be3fe59e465ec8722e025f437313aac04e7c831f"

do_install:append() {
    # Workaround to use the python package that contain the panda i2c tools
    sed -i 's|from i2c import|from pandai2c import|' ${D}/${fwdir}/extensions/fmc_acq427.py
}
