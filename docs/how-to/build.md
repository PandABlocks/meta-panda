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

3. Fetch the prebuilt FPGA packages and generate their recipes:

   ```bash
   ./fetch-fpga-ipks.py
   ```

   This downloads the `panda-fpga-ipks-<tag>.tar.gz` asset from the
   [PandABlocks-FPGA release](https://github.com/PandABlocks/PandABlocks-FPGA/releases)
   named in `fpga-release.txt`, unpacks the packages into `ipks/`, and writes a
   recipe for each one into `recipes-panda/panda-fpga-generated/`.  Neither
   directory is tracked in git — both are regenerated from scratch on every run.

   To build against a different release, either edit `fpga-release.txt` or pass
   `--release <tag>`.  To build against a locally built bitstream, drop its
   `.ipk` into `ipks/` and run `./fetch-fpga-ipks.py --no-download`, which
   regenerates the recipes from whatever `ipks/` holds without fetching
   anything.

4. Build the image.  `kas-container` pulls the required build container image
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

5. (Optional) Collect the output files, for example for pandabox:

   ```bash
   mkdir boot
   cp -Lf build/tmp/deploy/images/pandabox/fitImage-petalinux-initramfs-image-pandabox-pandabox \
       boot/image.ub
   cp -f build/tmp/deploy/images/pandabox/{rootfs.squashfs,boot.bin,boot.scr,target-defs} boot/
   zip boot-pandabox.zip boot/*
   ```

   Alternatively, the `build.sh` helper script runs both steps and collects
   everything for a specific machine in one go:

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

To build the FPGA app that can be used to make the firmware, see [Assemble blocks into an app](xref:PandABlocks-FPGA#assemble-app)