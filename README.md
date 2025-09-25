# meta-panda

This layer contains recipes and configuration for the linux system running in
PandA.

- The machines provided are: `pandabox` and `xu5-st1`.
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

#### Easy way
Use kas, if you don't have it, create a python venv and pip install it.
Then you just need to run: `kas-container build ./kas.yml`

The result will be under `build/tmp/deploy/images/pandabox` and the required
files can be gathered and compressed for an easier delivery:

```bash
mkdir boot
cp -Lf build/tmp/deploy/images/pandabox/fitImage-petalinux-initramfs-image-pandabox-pandabox boot/image.ub
cp -f build/tmp/deploy/images/pandabox/{rootfs.squashfs,boot.bin,boot.scr,target-defs} boot/
zip boot-pandabox.zip boot/*
```

There are a some environment variables that you might want to set:
- `KAS_MACHINE`: the default machine built is pandabox, if you want to build for
  a different machine, set this variable to the machine name, e.g.
  `KAS_MACHINE='xu5-st1'`.
- `KAS_CONTAINER_IMAGE`: we are using the kas image by default, currently
  `ghcr.io/siemens/kas/kas:4.7`, but can be overridden with this variable.

#### Manual way
- Add layer meta-panda to you build
- Set the following variables in `conf/local.conf`
  - `MACHINE="pandabox"` or `MACHINE="xu5-s1"`
  - `DISTRO="panda-petalinux"`
- Build panda-image by running: `bitbake panda-image`

See script [build-example.sh](./build-example.sh) for more details.

## Maintainers

- Famous Alele <famous.alele@diamond.ac.uk>
- Emilio Perez <emilio.perezjuarez@diamond.ac.uk>
