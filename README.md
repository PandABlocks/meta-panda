# meta-panda

This layer contains recipes and configuration for the linux system running in
PandA.

- The machines provided are: `pandabox` and `xu5_st1`.
- The distro provided is `panda-petalinux`.
- The image provided is `panda-image`.

## Dependencies

This layer depends on:

- meta-poky
- meta-openembedded
- meta-xilinx
- meta-petalinux

## Quick Start

### Building Image

- Add layer meta-panda to you build
- Set the following variables in `conf/local.conf`
  - `MACHINE="pandabox"` or `MACHINE="xu5_s1"`
  - `DISTRO="panda-petalinux"`
- Build panda-image by running: `bitbake panda-image`

## Maintainers

- Famous Alele <famous.alele@diamond.ac.uk>
- Emilio Perez <emilio.perezjuarez@diamond.ac.uk>
