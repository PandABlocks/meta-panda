# How to build the PandA boot image

## Prerequisites

- [kas](https://kas.readthedocs.io/) installed, or Docker / Podman available
  so that `kas-container` can pull and run the build container automatically.
- A clone of the `meta-panda` repository.

## Build steps

1. Clone the repository:

   ```bash
   git clone https://github.com/PandABlocks/meta-panda
   cd meta-panda
   ```

2. If `kas` is not already installed, create a virtual environment and install
   it:

   ```bash
   python3 -m venv venv && . venv/bin/activate && pip install kas
   ```

3. Build the image.  `kas-container` pulls the required build container image
   automatically — no manual Docker setup is needed:

   ```bash
   export KAS_IMAGE_VERSION="4.8"
   kas-container build ./kas.yml
   ```

   :::{note}
   `KAS_IMAGE_VERSION` pins the version of the build container.  Check the
   `meta-panda` release notes or the `kas.yml` file for the value appropriate
   to the version you are building. <!-- verify: PandABlocks/meta-panda#16 — confirm KAS_IMAGE_VERSION values -->
   :::

   To target a different machine set `KAS_MACHINE`, e.g.:

   ```bash
   KAS_MACHINE=xu5-st1 kas-container build ./kas.yml
   ```

   The default machine is `pandabox`.  Output lands under
   `build/tmp/deploy/images/<machine>`.

4. (Optional) Collect the output files, for example for pandabox:

   ```bash
   mkdir boot
   cp -Lf build/tmp/deploy/images/pandabox/fitImage-petalinux-initramfs-image-pandabox-pandabox \
       boot/image.ub
   cp -f build/tmp/deploy/images/pandabox/{rootfs.squashfs,boot.bin,boot.scr,target-defs} boot/
   zip boot-pandabox.zip boot/*
   ```

   Alternatively, the `build.sh` helper script builds and collects everything
   for a specific machine in one step:

   ```bash
   ./build.sh <MACHINE> </path/to/workdir>
   ```

   A `boot-<machine>.zip` file is created in the current directory.


## Output files

| File | Description |
|---|---|
| `boot.bin` | Zynq stage-0 boot loader + U-Boot (stage-2) |
| `boot.scr` | U-Boot script that locates and loads `image.ub` |
| `image.ub` | FIT image: Linux kernel + device tree + initramfs |
| `rootfs.squashfs` | Full Linux rootfs with all packages installed |
| `config.txt` | User-editable network and boot configuration |
| `target-defs` | Target-specific configuration functions |

Copy these files to the SD card and insert it in the target; the system will
boot normally.  On the first boot of a pandabox you will be prompted for a MAC
address.

To build the FPGA bitstream that can be used to make the firmware, see [PandABlocks-FPGA documentation](https://pandablocks.github.io/PandABlocks-FPGA/docs/)