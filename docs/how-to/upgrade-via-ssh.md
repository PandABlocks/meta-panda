# Upgrading a PandA over SSH

SSH access lets you upgrade a PandA without physical access, and is
particularly useful for upgrading multiple PandAs in one scripted pass.

## Prerequisites

SSH must be authorised on the PandA.  You can either:

- Place an `authorized_keys` file on the SD card before first boot, or
- Load SSH keys from a USB stick via the Web Admin interface
  (**SSH Keys → Append SSH keys from USB**).

:::{warning}
A PandA has only a single `root` user.  Remote operations run as root and can
break the system if commands are wrong — take care.
:::

## Post-5.0 upgrade (opkg / `.ipk`)

Download the `boot-{MACHINE}.tar.gz` release archive from
[GitHub Releases](https://github.com/PandABlocks/meta-panda/releases) and
extract it locally.  Then copy the files to the PandA and reboot:

```bash
ssh root@<panda-hostname> rm /boot/rootfs.squashfs
scp boot-{MACHINE}/* root@<panda-hostname>:/boot
ssh root@<panda-hostname> sync
```

The `/boot` directory on the PandA should contain:

- `boot.bin`
- `boot.scr`
- `image.ub`
- `rootfs.squashfs`
- `target-defs`

Power-cycle the PandA; it will install the new rootfs on next boot.

<!-- verify: audit for any further content gaps in the post-5.0 path -->

## Pre-5.0 to 5.x upgrade (zpkg → opkg)

If your PandA is running a pre-5.0 release (zpkg-based), follow the
web-admin upgrade path first ([](upgrade-via-web-admin.md)) to move to a
5.x base image before attempting SSH-based updates.

## Update the 24V FMC EEPROM (DLS-specific, one-time)

:::{note}
This step applies **only to users of the 24V FMC card produced by Diamond
Light Source**.  If you do not have this card you can skip this section
entirely.
:::

From PandA 3.0 onwards the 24V FMC EEPROM must be populated once with
hardware metadata.  This is a permanent, one-time write:

1. Find the `ipmi_definition.ini` for your 24V FMC card
   (in the
   [`modules/fmc_24vio/`](https://github.com/PandABlocks/PandABlocks-FPGA/blob/master/modules/fmc_24vio/ipmi_definition.ini)
   directory of the FPGA repo).
2. Copy it to the PandA:

   ```bash
   scp ipmi_definition.ini root@<panda-hostname>:/tmp/
   ```

3. Write the EEPROM:

   ```bash
   ssh root@<panda-hostname> /opt/bin/write_eeprom /tmp/ipmi_definition.ini
   ```

   The script reads back the EEPROM after writing to confirm the content
   matches.
