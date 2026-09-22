Boot Process
============

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

