DESCRIPTION = "Panda FPGA packages for a specific machine"

inherit packagegroup

# The FPGA packages for the machines in the current PandABlocks-FPGA release --
# the bitstreams and the PandABox slow FPGA -- are generated from the ipks by
# fetch-fpga-ipks.py.  This is a require rather than an include so that
# forgetting step 1 of the build fails here, loudly, instead of silently
# producing an image with no bitstreams.
require recipes-panda/panda-fpga-generated/packagegroup-panda-fpga-apps.inc
