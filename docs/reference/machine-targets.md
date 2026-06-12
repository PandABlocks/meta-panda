# Machine targets

This page lists the valid `MACHINE` values for building a PandA image and
describes the corresponding hardware.  Set `MACHINE` in `conf/local.conf` (for
manual builds) or via `KAS_MACHINE` (for kas builds).

| MACHINE | Hardware | Notes |
|---|---|---|
| `pandabox` | PandABox (default) | Zynq 7030; joint DLS/SOLEIL hardware; [Open Hardware](https://www.ohwr.org/projects/pandabox/wiki) |
| `pandabox2` | PandABox 2 | Successor to PandABox |
| `pandabrick` | PandABrick | <!-- verify: notes/details for pandabox2 and pandabrick --> |
| `xu5-st1` | ZynqMP-based target (XU5 SoM) | Development only |
| `zedboard` | Zedboard | Development/testing platform |

The generally supported machines are `pandabox`, `pandabox2` and `pandabrick`;
`xu5-st1` and `zedboard` are development-only targets.

:::{note}
`pandabox` is the default machine built when `KAS_MACHINE` is not set.
:::

Per-target hardware descriptions (SoC, expansion connectors, FMC slots,
notable capabilities) are in {doc}`../explanations/hardware-targets`.
