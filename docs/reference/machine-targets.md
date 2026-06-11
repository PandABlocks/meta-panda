# Machine targets

This page lists the valid `MACHINE` values for building a PandA image and
describes the corresponding hardware.  Set `MACHINE` in `conf/local.conf` (for
manual builds) or via `KAS_MACHINE` (for kas builds).

| MACHINE | Hardware | Notes |
|---|---|---|
| `pandabox` | PandABox (default) | Zynq 7030; joint DLS/SOLEIL hardware; [Open Hardware](https://www.ohwr.org/projects/pandabox/wiki) |
| `xu5-st1` | ZynqMP-based target | — |
| `xu5-s1` | ZynqMP-based target | — |
| `zedboard` | Zedboard | Development/testing platform |
| `pandabrick` | PandABrick | <!-- verify: confirm whether PandABrick is a supported MACHINE in current releases --> |

:::{note}
`pandabox` is the default machine built when `KAS_MACHINE` is not set.
:::

Per-target hardware descriptions (SoC, expansion connectors, FMC slots,
notable capabilities) are in {doc}`../explanations/hardware-targets`.
