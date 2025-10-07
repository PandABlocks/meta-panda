Building the Root File System
=============================

Output Files
------------

When built the following files are placed in `$(BOOT_IMAGE)` (see `CONFIG` to define this):

`boot.bin`:
    This file is loaded by the Zynq stage-0 boot loader and contains a standard stage 1 boot loader together with U-Boot, which acts as the stage-2 boot loader.

`boot.scr`:
    U-Boot script that is run automatically and will run find and load
    `image.ub`.

`image.ub`:
    FIT image which contains the Linux kernel image, the device tree blob
    (describing hardware used) and the initramfs image loaded by U-Boot.

`rootfs.squashfs`:
    Final rootfs image containing a full linux system with every package
    required installed.

`config.txt`:
    This is designed to be user editable and contains network configuration settings.

`target-defs`:
    Target specific configuration functions.

Boot Process
------------

The boot process is as follows:

0. The stage-0 boot loader is hard wired into Zynq. This loads boot.bin from the
   SD card into memory and executes the next step.

1. The stage-1 boot loader loads U-Boot from the boot.bin file.

2. The stage-2 boot loader is U-Boot. This runs the boot script which will find
   the FIT image, will check integrity and boot the linux kernel.

3. The kernel initialises hardware resources and then prepares the initial file
   system image (i.e. the initramfs image contained inside the FIT image),
   then, the init script in this image is executed.

4. The initial init script checks the configuration and prompts for a MAC
   address if necessary, it will also mount the rootfs image.

5. Finally the target system is executed by running the init system inside the
   rootfs image.

Preparing SD for Install
------------------------

To install a fresh PandA system:

1. Obtain a formatted empty SD card. A minimum size of 2GB is recommended.

2. Place the following files on the SD card (from rootfs build):

`boot.bin`
`boot.scr`
`image.ub`
`rootfs.squashfs`
`target-defs`
`config.txt`

3. Allocate MAC address to target system. These need to be purchased in blocks.

## Panda System First Boot

It is wise to boot PandA for the first time with an connected serial console, particularly if the MAC file has not been written. If no MAC file has been specified then on boot the serial console will prompt for a MAC address to be specified::

    Enter MAC address:

The SD card will then be repartitioned, the content of `imagefile.cpio.gz` will be installed and this file is deleted.

The installation process takes a couple of minutes or so, depending somewhat on the speed of the SD card.

The serial port parameters are 115200n8.

IPK Packages (opkg)
---------------------

IPK files will be used for managing all application software. These packages are
managed with the command opkg.

 The name of a ipk file must be of the form package_version.ipk, where package
 is the package name and version identifies the package version.

Installing IPK Files
---------------------

There are two ways to maintain installed software:

1. The simplest is via the Administration web page:
  - First place the .ipk files to install on a USB stick.
  - Insert USB stick into PandA
  - Select “Install ipk files from USB” from admin page
  - Navigate to appropriate location and select package(s) to install
  - Click on “Install Selected”

2. Alternatively files can be copied directly to PandA and installed via a script, for example:

.. code::
    scp panda-fpga_version.ipk root@panda:/tmp
    ssh root@panda opkg install /tmp/panda-fpga_version.ipk

`opkg` Command
--------------

`opkg list-installed`:
    Lists all installed packages

`opkg install package ...`:
    Installs or replaces named packages

`opkg remove package ...`:
    Removes named packages

`opkg files package ...`:
    Shows files in named packages

`opkg help`:
    Show this list of options
