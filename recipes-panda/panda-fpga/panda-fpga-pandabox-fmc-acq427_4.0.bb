require panda-fpga.inc

SRC_URI = "https://github.com/PandABlocks/meta-panda/releases/download/4.0alpha1/panda-fpga-pandabox-fmc-acq427@4.0-35-gb8f6de5-dirty.ipk"
SRC_URI[sha256sum] = "758865b09b287d4636ffcf0398e67805f1e056204048dbdc1e8c1cc9923d0c02"

do_install:append() {
    # Workaround to use the python package that contain the panda i2c tools
    sed -i 's|from i2c import|from pandai2c import|' ${D}/opt/share/panda-fpga-pandabox-fmc-acq427/extensions/fmc_acq427.py
}
