# Manually build the PandA image

:::{note}
This page describes a manual Yocto build without `kas-container`.  For the
recommended approach see [](build.md).
:::

The steps below can be run inside a Docker container (e.g. the `kas` image) if
the Yocto host dependencies are not available on your system.

## Steps

1. Initialise the Yocto source tree using `repo` and the Xilinx manifest:

   ```bash
   BRANCH="rel-v2023.2"
   repo init -u https://github.com/Xilinx/yocto-manifests.git -b $BRANCH
   repo sync
   ```

   :::{note}
   `rel-v2023.2` is the manifest branch used for current PandA 5.x builds.
   <!-- verify: PandABlocks/meta-panda#18 — confirm Xilinx manifest branch for post-5.0 -->
   :::

2. Load the Yocto build environment, passing the build directory as argument:

   ```bash
   . setupsdk build
   ```

3. Add the `meta-panda` layer:

   ```bash
   git clone https://github.com/PandABlocks/meta-panda ../sources/meta-panda
   bitbake-layers add-layer ../sources/meta-panda
   ```

4. In `conf/local.conf` set:

   ```makefile
   MACHINE = "pandabox"   # or e.g. "xu5
   DISTRO  = "panda-petalinux"
   ```

5. Build the image:

   ```bash
   bitbake panda-image
   ```

6. Collect the output files:

   ```bash
   mkdir boot
   cp -Lf tmp/deploy/images/pandabox/fitImage-petalinux-initramfs-image-pandabox-pandabox \
       boot/image.ub
   cp -f tmp/deploy/images/pandabox/{rootfs.squashfs,boot.bin,boot.scr,target-defs} boot/
   zip boot-pandabox.zip boot/*
   ```

See [](build.md) for a description of each output file.
