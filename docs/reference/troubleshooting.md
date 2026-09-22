# Troubleshooting

## Networking

### How do I configure a static IP address?

By default PandA uses DHCP.  To set a static address, edit `config.txt` on the
SD card and uncomment or add the relevant lines:

```ini
ADDRESS = 192.168.0.2
NETMASK = 255.255.255.0
GATEWAY = 192.168.0.254
HOSTNAME = mypanda
```

See [](../how-to/setup-without-dhcp.md) for the full `config.txt` format and the USB
override mechanism (no SD card access required).

### How do I disable subnet validation in the web control?

Create an empty file called `no-subnet-validation` under `state/options/` on
the SD card.

### How do I authorise a public SSH key?

Add the public key to a file named `authorized_keys` on the SD card, or load
it from a USB stick via **Web Admin → SSH Keys → Append SSH keys from USB**.

## Boot and recovery

### How do I recover from a catastrophic configuration change?

Remove the file `changes.ext4` from the SD card.  This discards all
configuration changes and resets the PandA to factory defaults.

### How do I load the full rootfs to RAM at boot?

Create an empty file called `to-ram` on the SD card.

:::{warning}
On some targets (such as ZedBoard) loading to RAM may cause the server to fail
because the driver cannot allocate sufficient DMA buffers.
:::

### What do I do if the system freezes after loading the FPGA?

Create an empty file called `no-fpga` on the SD card.  The FPGA loader will
skip loading the bitstream, which lets you try alternative bitstreams manually.

## FPGA bitstream

### How do I override the FPGA bitstream variant used?

By default PandA reads the FMC EEPROM and selects the bitstream whose FMC
requirements are satisfied.  If no EEPROM is found the `no-fmc` variant is
used.

To force a specific bitstream, set `APP` in `config.txt`:

```ini
APP = pandabox-fmc-acq430
```

This takes effect only if the corresponding FPGA variant package is installed.
See [](../how-to/choose-fpga-bitstream.md) for the full bitstream selection
mechanism.
