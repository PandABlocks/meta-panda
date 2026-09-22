# The boot process

The boot process on a Zynq-based PandA proceeds through five stages:

0. **Stage-0 boot loader (hard-wired in Zynq)**
   Reads `boot.bin` from the SD card into memory and passes control to the
   stage-1 loader.

1. **Stage-1 boot loader (inside `boot.bin`)**
   Loads U-Boot from `boot.bin`.

2. **Stage-2 boot loader: U-Boot**
   Runs the boot script (`boot.scr`) which locates the FIT image (`image.ub`),
   checks its integrity, and boots the Linux kernel.

3. **Kernel initialisation**
   The kernel initialises hardware resources and then unpacks the initramfs
   image contained inside the FIT image.  The `init` script within the
   initramfs is executed.

4. **Initramfs init script**
   Checks the configuration (including network settings from `config.txt`),
   prompts for a MAC address if one has not been set, and mounts the main
   rootfs image (`rootfs.squashfs`).

5. **Rootfs init system**
   The target system starts by running the init system inside the mounted
   rootfs image.  PandA services (TCP server, web interface) are started here.

## Key files on the SD card

| File | Role |
|---|---|
| `boot.bin` | Stage-0/1 boot loader + U-Boot |
| `boot.scr` | U-Boot boot script |
| `image.ub` | FIT image: kernel + device tree + initramfs |
| `rootfs.squashfs` | Main Linux rootfs |
| `config.txt` | Network and boot configuration (user-editable) |
| `target-defs` | Target-specific configuration functions |
