# How to get a PandA on the network

The SD card inside a PandA contains a `config.txt` file that controls networking
and other boot-time settings.  Below is the default file with all options
commented out:

```ini
# This file contains configuration settings.  In this file network and other
# settings can be adjusted.

# If ADDRESS and NETMASK are not both specified DHCP will be used instead.
# The ADDRESS field can be set to a four part dotted IP address followed by a
# network mask specification thus:
#
#   ADDRESS = 172.23.252.202
#   NETMASK = 255.255.240.0

# If the ADDRESS field has been set then the GATEWAY and DNS fields should be
# set:
#
#   GATEWAY = 172.23.240.254
#   DNS = 172.23.5.13 172.23.4.1 130.246.8.13

# Optionally the DNS search domain can be set:
#
#   DNS_SEARCH = diamond.ac.uk

# The NTP server or servers can be specified here:
#
#   NTP = 172.23.240.2 172.23.199.1

# The machine hostname can be specified here:
#
#   HOSTNAME = panda

# To skip loading any zpackages at startup, either for testing or as an
# override to recover from a faulty zpkg install:
#
#   NO_ZPKG
```

During startup the network is configured as follows:

- If `ADDRESS` and `NETMASK` are both set, a static IP is assigned.
  Set `GATEWAY` and `DNS` too; `NTP` is optional.
- Otherwise DHCP is attempted.  On success it sets IP, gateway, DNS and may
  set hostname.  If the DHCP server advertises NTP servers those take priority
  over the `NTP` key.
- If DHCP fails, ZeroConf is attempted.  If that also fails the PandA will not
  be reachable on the network.

In the default (all-commented) configuration the PandA contacts
`0.pool.ntp.org` and pool peers for time.

## Override file

If a static IP needs to be set without opening the SD card, use the USB
override mechanism:

Place a file named `panda-config.txt` on a USB drive and plug the drive into
the PandA **while it is booting**.  The PandA will read `panda-config.txt` from
the USB drive instead of `config.txt` from the SD card.

The override file uses the same format as `config.txt`, for example:

```ini
ADDRESS = 192.168.0.2
NETMASK = 255.255.255.0
GATEWAY = 192.168.0.254
HOSTNAME = mypanda
```

To make the USB settings permanent, use the **Show Network Configuration**
function in the Web Admin interface (described below), which writes the settings
back to `config.txt` on the SD card.

## Web interface

Once a PandA is on the network, navigate to its IP address or hostname in a
browser.  The home page provides links to:

- **Home** — summary of the web interface sections
- **Docs** — hardware, firmware and software documentation
- **Control** — the web control; wire functional blocks together, set parameters,
  save and load designs (requires the web-control package to be installed)
- **Admin** — install packages from USB, manage SSH keys, and other remote
  administration

## Web Admin

The Web Admin page provides the following functions:

- **System**
  - Reboot / Restart
  - Show `/var/log/messages`
  - Show Network Configuration
- **Packages**
  - List Installed Packages
  - Install Packages from USB
  - Install Rootfs from USB
- **SSH Keys**
  - Show Authorised SSH Keys
  - Append SSH keys from USB

Visit the relevant Web Admin page for instructions on each operation.

## Troubleshooting

See [](../reference/troubleshooting.md) for answers to common questions such as
configuring a static IP, disabling subnet validation, recovering from a
corrupted SD card, and overriding the FPGA bitstream variant.
