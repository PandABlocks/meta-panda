# Integrate with a PandA

A PandA exposes a plain TCP server on port 8888 (control) and port 8889
(data capture).  Several client libraries build on this interface:

| Approach | When to use |
|---|---|
| Direct TCP | Low-level scripting; quick one-off checks |
| PandABlocks-client (Python) | Python applications; preferred for new integrations |
| fastcs-PandABlocks (EPICS / Tango) | Control-system integrations via EPICS or Tango |

## Direct TCP

Connect to port 8888 to send commands and read responses:

```bash
nc <panda-hostname> 8888
```

See the
[PandABlocks-server commands reference](xref:PandABlocks-server/reference/commands)
for the command syntax.

Connect to port 8889 for the data capture stream:

```bash
nc <panda-hostname> 8889
```

Press Return; you will see `OK`.  After arming PCAP (in the web control or
via port 8888), data streams until you disarm.  See
[Tutorial 2](../tutorials/position_capture.md) for a worked example.

## Python client (`PandABlocks-client`)

[PandABlocks-client](xref:PandABlocks-client)
provides both a blocking and an asyncio client.

Install:

```bash
pip install pandablocks
```

### Blocking client

The [`BlockingClient`](xref:PandABlocks-client#pandablocks.blocking.BlockingClient)
is the simplest entry point:

```python
from pandablocks.blocking import BlockingClient

with BlockingClient("my-panda") as client:
    responses = client.send(["PCAP.ARM=1"])
```

### Data capture to HDF5 / numpy

PandABlocks-client includes helpers to read the binary capture stream and
write it to HDF5 or convert it to numpy arrays.  See the
[PandABlocks-client documentation](xref:PandABlocks-client)
for the `PcapHdf5Writer` and related utilities.

## EPICS and Tango via `fastcs-PandABlocks`

[fastcs-PandABlocks](https://github.com/DiamondLightSource/fastcs-PandABlocks)
wraps PandABlocks-client and exposes all PandA attributes as EPICS PVs or
Tango attributes via the [FastCS](https://github.com/DiamondLightSource/FastCS)
framework.

Refer to the fastcs-PandABlocks repository for installation and configuration
instructions.
