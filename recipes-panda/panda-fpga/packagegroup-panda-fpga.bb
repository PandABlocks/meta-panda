DESCRIPTION = "Panda FPGA packages for a specific machine"

inherit packagegroup

# The bitstream packages for the machines in the current PandABlocks-FPGA
# release are generated from the ipks by fetch-fpga-ipks.py.  This is a require
# rather than an include so that forgetting step 1 of the build fails here,
# loudly, instead of silently producing an image with no bitstreams.
require recipes-panda/panda-fpga-generated/packagegroup-panda-fpga-apps.inc

# Everything below is hand-maintained: the slow FPGA comes from a separate
# PandABlocks-slowFPGA release, and the experimental boards are not part of the
# ipk tarball.
RDEPENDS:${PN}:append:pandabox = " \
    panda-slowfpga \
"

RDEPENDS:${PN}:append:xu5 = " \
    panda-fpga-xu5-no-fmc \
"

RDEPENDS:${PN}:append:zedboard = " \
    panda-fpga-zedboard-no-fmc \
"
