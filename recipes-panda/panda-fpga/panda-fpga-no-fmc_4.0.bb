require panda-fpga.inc

APP = "no-fmc"
# PandABox
PANDABOX_NO_FMC_ZPG_URL= "https://github.com/PandABlocks/PandABlocks-FPGA/releases/download/4.0/panda-fpga@PandABox-no-fmc-4.0.zpg;name=pandabox-no-fmc"
PANDABOX_NO_FMC_ZPG_SHA256 = "654dee4d8e83c35fcec7ddc98929884eb379d528f1b5af3da399bf913cea9c08"
SRC_URI:pandabox = "${@d.getVar('FPGA_ZPG') or d.expand('${PANDABOX_NO_FMC_ZPG_URL}')}"
SRC_URI[pandabox-no-fmc.sha256sum] = "${@d.getVar('FPGA_ZPG_SHA256') or d.expand('${PANDABOX_NO_FMC_ZPG_SHA256}')}"
# XU5 SoC on a ST1 board
XU5_ST1_NO_FMC_ZPG_URL = "https://github.com/PandABlocks/PandABlocks-FPGA/releases/download/4.0/panda-fpga@xu5_st1-no-fmc-4.0.zpg;name=xu5_st1-no-fmc"
XU5_ST1_NO_FMC_ZPG_SHA256 = "2ad34d021f51a7284afc7303ef018c203718dd3f3dcfb82b04fae1ce70b6c1e2"
SRC_URI:xu5_st1-no-fmc = "${@d.getVar('FPGA_ZPG') or d.expand('${XU5_ST1_NO_FMC_ZPG_URL}')}"
SRC_URI[xu5_st1-no-fmc.sha256sum] = "${@d.getVar('FPGA_ZPG_SHA256') or d.expand('${XU5_ST1_NO_FMC_ZPG_SHA256}')}"
