require panda-fpga.inc

APP = "no-fmc"
# PandABox
SRC_URI:pandabox = "https://github.com/PandABlocks/PandABlocks-FPGA/releases/download/4.0/panda-fpga@PandABox-no-fmc-4.0.zpg;name=pandabox-no-fmc"
SRC_URI[pandabox-no-fmc.sha256sum] = "654dee4d8e83c35fcec7ddc98929884eb379d528f1b5af3da399bf913cea9c08"
# XU5 SoC on a ST1 board
SRC_URI:xu5_st1 = "https://github.com/PandABlocks/PandABlocks-FPGA/releases/download/4.0/panda-fpga@xu5_st1-no-fmc-4.0.zpg;name=xu5_st1-no-fmc"
SRC_URI[xu5_st1-no-fmc.sha256sum] = "2ad34d021f51a7284afc7303ef018c203718dd3f3dcfb82b04fae1ce70b6c1e2"
