# meta-panda

PandA is a programmable logic box for synchronised triggering and position
capture in scientific experiments. You configure it by wiring together
functional blocks in its FPGA — from a web browser or over a simple TCP
protocol — and capture timestamped position data from it at high speed.

This site is the root of the PandABlocks documentation: it covers getting a
PandA on the network, using the Web Control, capturing data, administering and
upgrading a PandA, and building its firmware and software. Documentation for
the individual components (FPGA framework, TCP server, Python client, EPICS /
Tango integration) is linked throughout.

This repository itself is the `meta-panda` layer: the Yocto recipes and
configuration for building the Linux system that runs on a PandA.

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
