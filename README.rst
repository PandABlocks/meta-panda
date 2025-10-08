meta-panda
==========

The layer meta-panda contains yocto recipes and configuration for building the
linux system running in PandA.

- The machines provided are: `pandabox` and `xu5-st1`.
- The distro provided is `panda-petalinux`.
- The image provided is `panda-image`.

============== ===================================================
Source code    https://github.com/PandABlocks/meta-panda
Documentation  https://PandABlocks.github.io/meta-panda
Changelog      https://github.com/PandABlocks/meta-panda/releases
============== ===================================================

What does the panda linux system do?
====================================

The linux system sets up a number of services on it:

- Bringing up the network as specified in a config.txt file on the SD card
- Running an SSH server that allows debugging access to those who have their public keys on the PandA
- Programming the FPGA and running services like the TCP server and Web Control as specified in packages
- Running a Web Admin server on port 80 that allows IPK files to allow the installation and removal of packages, and addition of SSH keys from the USB stick
