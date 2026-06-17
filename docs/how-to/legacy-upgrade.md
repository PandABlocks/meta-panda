# Upgrading a PandA - Pre-5.0 to 5.x
The Web Admin interface lets you upgrade a PandA using only a browser and a
USB stick — no SSH or network file transfer required.

## Prerequisites

- Physical access to the PandA (to insert a USB stick).
- the legacy-updater package from
  [GitHub Releases](https://github.com/PandABlocks/meta-panda/releases).

## Upgrade procedure (zpkg → opkg)

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