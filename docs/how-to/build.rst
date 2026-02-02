.. _build_doc:

Building the panda image
========================

1. Clone the ``meta-panda`` repo::

    git clone https://github.com/PandABlocks/meta-panda
    cd meta-panda

2. If you don't have kas, create a python venv and pip install it:

   ``python3 -m venv venv && . venv/bin/activate && pip install kas``

3. Build the panda image::

    export KAS_IMAGE_VERSION="4.8"
    kas-container build ./kas.yml

Environment variable ``KAS_MACHINE`` can be set to build for a different machine
(e.g. ``KAS_MACHINE='xu5-st1'``), the default machine built is pandabox.

The result will be under ``build/tmp/deploy/images/<machine>``

4. (optional) Collect the output files, e.g. for pandabox::

    mkdir boot
    cp -Lf build/tmp/deploy/images/pandabox/fitImage-petalinux-initramfs-image-pandabox-pandabox boot/image.ub
    cp -f build/tmp/deploy/images/pandabox/{rootfs.squashfs,boot.bin,boot.scr,target-defs} boot/
    zip boot-pandabox.zip boot/*


In order to simplify build even further, you can run the following script
that builds and collects everything required for a specific machine::

    ./build.sh <MACHINE> </path/to/workdir>

A boot zip file will be created in the current folder with all the output files.

Output Files
------------

``boot.bin``:
    This file is loaded by the Zynq stage-0 boot loader and contains a standard stage 1 boot loader together with U-Boot, which acts as the stage-2 boot loader.

``boot.scr``:
    U-Boot script that is run automatically and will run find and load
    `image.ub`.

``image.ub``:
    FIT image which contains the Linux kernel image, the device tree blob
    (describing hardware used) and the initramfs image loaded by U-Boot.

``rootfs.squashfs``:
    Final rootfs image containing a full linux system with every package
    required installed.

``config.txt``:
    This is designed to be user editable and contains network configuration settings.

``target-defs``:
    Target specific configuration functions.

Once this files are put in the SD card and inserted in the target, the linux
system will boot as expected, the first time will ask for a MAC address in
pandabox.
