# meta-panda

The `meta-panda` layer contains the Yocto recipes and configuration for building the
Linux system that runs on a PandA.

- Machines provided: `pandabox`, `pandabox2`, `pandabrick`
- Distro provided: `panda-petalinux`
- Image provided: `panda-image`

The Linux system brings up the network from a `config.txt` file on the SD card, runs an
SSH server for debugging access, programs the FPGA and runs services such as the TCP
server and Web Control, and serves a Web Admin interface on port 80 for installing and
removing packages and adding SSH keys.

<!-- README only content. Anything below this line will be excluded from the index page -->

## Where to find things

| | |
|---|---|
| Source code | <https://github.com/PandABlocks/meta-panda> |
| Documentation | <https://PandABlocks.github.io/meta-panda> |
| Releases | <https://github.com/PandABlocks/meta-panda/releases> |
