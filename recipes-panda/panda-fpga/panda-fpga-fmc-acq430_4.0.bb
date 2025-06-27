require panda-fpga.inc

APP = "fmc_acq430"
SRC_URI:pandabox = "https://github.com/PandABlocks/PandABlocks-FPGA/releases/download/4.0/panda-fpga@PandABox-fmc_acq430-4.0.zpg;name=pandabox-fmc_acq430"
SRC_URI[pandabox-fmc_acq430.sha256sum] = "35800c6fe5f2168e8059aafccee15365860ccb4f641907ab69e0aceb18b37be7"
# XU5 SoC on a ST1 board
SRC_URI:xu5_st1 = "https://github.com/PandABlocks/PandABlocks-FPGA/releases/download/4.0/panda-fpga@xu5_st1-fmc_acq430-4.0.zpg;name=xu5_st1-fmc_acq430"
SRC_URI[xu5_st1-fmc_acq430.sha256sum] = "a89fd750be8a8e91d4d33f0d0a09ead6f63057f6fa52d6310ee79c07a47c2a65"
