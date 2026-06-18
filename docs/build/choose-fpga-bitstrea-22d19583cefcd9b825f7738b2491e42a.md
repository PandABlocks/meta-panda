# Choose the FPGA bitstream

Each PandABlocks-FPGA `.ipk` package ships an FPGA bitstream and declares
which FMC hardware it requires.  On boot, meta-panda selects the bitstream
to load as follows:

1. If the `APP` variable is set in `config.txt`, that bitstream is used.
2. Otherwise the PandA reads the FMC EEPROM and auto-selects the bitstream
   whose FMC requirements match.
3. If more than one installed bitstream would satisfy the EEPROM check, the
   PandA reports an error.

## Automatic selection

Leave `APP` unset in `config.txt`.  The PandA will select the bitstream that
matches the FMC card detected at boot.  If no FMC EEPROM is found, the
`no-fmc` variant is used.

## Manual override via `APP`

To force a specific bitstream, add `APP=<variant>` to `config.txt` on the SD
card:

```ini
APP = pandabox-fmc-acq430
```

The `APP` variable takes effect only if the corresponding FPGA variant package
is installed.  Available variant names are listed in the package names visible
in the web admin (**Packages → List Installed Packages**).

### USB override (no SD card access needed)

To override without opening the PandA, add `APP=<variant>` to
`panda-config.txt` on a USB stick and plug it in while the PandA boots:

```ini
APP = pandabox-fmc-acq430
```

See [](quickstart.md) for full details of the USB override mechanism.

## Installing a new bitstream package

```bash
scp panda-fpga-<variant>_<version>.ipk root@<panda-hostname>:/tmp/
ssh root@<panda-hostname> opkg install /tmp/panda-fpga-<variant>_<version>.ipk
ssh root@<panda-hostname> reboot
```

To build a custom bitstream package from source, see the
[PandABlocks-FPGA documentation](https://github.com/PandABlocks/PandABlocks-FPGA).
