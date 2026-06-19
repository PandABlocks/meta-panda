# Architecture

PandABlocks is a framework for building real-time signal processing and data
capture systems on Zynq FPGA hardware.  The system has four main layers:

## Layers

### FPGA firmware (PandABlocks-FPGA)

The FPGA runs a set of functional **blocks** — clock generators, counters,
pulse stretchers, position capture, lookup tables and more.  Each block
has typed input and output ports (bit bus, position bus) and a set of
configurable fields.  Block definitions live in the
[PandABlocks-FPGA](https://github.com/PandABlocks/PandABlocks-FPGA) repository.

### Server (PandABlocks-server)

The PandABlocks server runs on the Zynq ARM and exposes all block fields over
a plain TCP interface on port 8888 (control) and port 8889 (data capture).
The server is the sole point of contact for clients — it translates TCP
commands into register reads/writes to the FPGA.  The server lives in
[PandABlocks-server](https://github.com/PandABlocks/PandABlocks-server).

### Client libraries

Several client layers build on the TCP interface:

| Layer | Repo | Use case |
|---|---|---|
| Direct TCP | — | Low-level scripting, quick checks |
| Python client | [PandABlocks-client](xref:PandABlocks-client) | Python applications; preferred for new integrations |
| EPICS / Tango | [fastcs-PandABlocks](https://github.com/DiamondLightSource/fastcs-PandABlocks) | Control-system integrations |

See [](../how-to/integrate-with-a-panda.md) for step-by-step instructions.

### Firmware build (meta-panda)

The Yocto layer in this repository assembles the firmware image: it pulls the
rootfs, server, FPGA bitstreams and web-control packages together into a
bootable SD card image (see [](../how-to/build.md)).

## Data flow

```
  Detector / instrument hardware
          │
          ▼
  ┌──────────────┐
  │  FPGA blocks │  ← bit bus / position bus connections
  │  (Zynq PL)   │     configured via TCP server
  └──────┬───────┘
         │
  ┌──────▼───────┐   port 8888 (control)
  │  PandA server│ ─────────────────────────► clients
  │  (Zynq PS)   │   port 8889 (data stream)
  └──────────────┘
```

At trigger the server streams captured data over port 8889 in ASCII or binary
format.  Binary frames can be decoded to numpy arrays or written to HDF5 by
PandABlocks-client.

## Hardware targets

PandABlocks firmware runs on several Zynq-based hardware platforms — see
[](hardware-targets.md) for per-target descriptions and
[](../reference/machine-targets.md) for the `MACHINE` build strings.
