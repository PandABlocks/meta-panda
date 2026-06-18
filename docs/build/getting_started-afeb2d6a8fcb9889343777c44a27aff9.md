# Tutorial 0: Getting Started

In this tutorial you will setup your PandA; configure it so you can find it on the network, understand the web interface, and upgrade to the latest firmware.

## Prerequisites

- A PandA that is powered on and connected to your network.

## Getting on the network

By default the PandA uses DHCP — no configuration needed. Simply connect it
to your network and power it on.

If you need a static IP instead, see [](../how-to/setup-without-dhcp.md).

Once it has an address, confirm it's reachable by navigating to:

```
http://<panda-hostname>/
```

where `<panda-hostname>` is the IP address or hostname of your PandA, you should see the PandA web interface home page.

## Web interface overview

The home page has four sections:

- **Home** — summary of the web interface sections
- **Docs** — hardware, firmware and software documentation
- **Control** — the web control; wire functional blocks together, set parameters,
  save and load designs (requires the web-control package to be installed)
- **Admin** — install packages from USB, manage SSH keys, and other remote
  administration

```{figure} ../images/webcontrol/starting-ui.png
:align: center

The initial web control screen
```

## Upgrading the firmware

Make sure your PandA has the latest firmware. From the web admin page:

1. Click **Admin** in the bottom banner.
2. Check your current version under **Version Information**.
3. If your PandA needs upgrading you can do so with one of the following guides. Make sure to check whether you are need to follow instructions under **pre-5.0 to 5.x** or **5.0 or later to 5.x**:
   - If you want to upgrade via the web admin interface — see [](../how-to/upgrade-via-web-admin.md).
   - If you want to upgrade via SSH — see [](../how-to/upgrade-via-ssh.md).

## Troubleshooting

See [](../reference/troubleshooting.md) for answers to common questions such as
configuring a static IP, disabling subnet validation, recovering from a
corrupted SD card, and overriding the FPGA bitstream variant.

## Next steps

You have now setup your PandA and upgraded to the latest firmware. Continue with:

- [](../how-to/connecting_to_web_control.md) — drive some output bits and see real
  hardware changes.
