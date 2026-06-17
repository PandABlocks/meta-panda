# Upgrading a PandA via the web admin interface

The Web Admin interface lets you upgrade a PandA using only a browser and a
USB stick — no SSH or network file transfer required.

## Prerequisites

- Physical access to the PandA (to insert a USB stick).
- The new firmware archive downloaded from
  [GitHub Releases](https://github.com/PandABlocks/meta-panda/releases).

## 5.0 or later to 5.x (opkg / `.ipk`)

1. Download the `boot-{MACHINE}.tar.gz` archive for your machine type.
   There is no need to unzip it.
2. Copy the archive to a USB stick.
3. Insert the USB stick into the USB port on the back of the PandA.
4. Open a browser and navigate to `http://<panda-hostname>/`.
5. Click **Admin** in the bottom banner.
6. Note the current version shown in the Version section.
7. Under **Admin Commands → Packages**, click **Install Rootfs from USB**.
8. Select your `boot-{MACHINE}.tar.gz` file from the list and follow the
   on-screen instructions.

:::{note}
If you are installing a major rootfs upgrade it is recommended to uninstall
all installed zpkgs/ipkgs **before** upgrading. An option to do this is offered
as part of the rootfs install flow.
:::

9. Under **Admin Commands → System → Reboot/Restart**, click **Reboot Now** to restart the PandA; it will apply the new rootfs on next boot.

## Pre-5.0 to 5.x upgrade (zpkg → opkg)

Pre-5.0 PandAs use a legacy zpkg-based firmware format. To upgrade to a
5.x release:

1. Download the legacy-updater package.
2. Copy the updater package `legacyupgrader@pandabox-{VERSION}.zpg`to a USB stick.
3. Insert the USB stick into the USB port on the back of the PandA.
4. Open a browser and navigate to `http://<panda-hostname>/`.
5. Click **Admin** in the bottom banner.
6. Note the current version shown in the Admin tab landing page.
7. Under **Admin Commands → Packages**, click **Install Packages from USB**.
8. Select the `legacyupgrader@pandabox-{VERSION}.zpg` file from the list, click install, and wait for the installaton to finish.
9. Under **Admin Commands → System → Reboot/Restart**, click **Reboot Now** to restart the PandA; it will apply the new firmware on next boot.

## Fresh SD card install

If the PandA cannot be reached over the network or the rootfs is corrupted,
install from a fresh SD card:

1. Download the `boot-{MACHINE}.tar.gz` archive from
   [GitHub Releases](https://github.com/PandABlocks/meta-panda/releases).
2. Extract the archive and copy all files to a freshly formatted SD card
   (FAT32).
3. Optionally add a `config.txt` with network settings
   (see {doc}`quickstart`).
4. Insert the SD card into the PandA and power on.
