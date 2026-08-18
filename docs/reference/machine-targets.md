# Machine targets

This page lists the valid `MACHINE` values for building a PandA image and
describes the corresponding hardware.  Set `MACHINE` in `conf/local.conf` (for
manual builds) or via `KAS_MACHINE` (for kas builds).

| MACHINE | Hardware | Notes |
|---|---|---|
| `pandabox` | PandABox (default) | Zynq 7030; joint DLS/SOLEIL hardware; [Open Hardware](https://gitlab.com/ohwr/project/pandabox/-/wikis/home) |
| `pandabox2` | PandABox 2 | Zynq UltraScale+ MPSoC, ZU6CG ; DLS/SOLEIL hardware; Successor to PandABox |
| `pandabrick` | PandABrick | Zynq UltraScale+ MPSoC, ZU4CG |
| `xu5` | XU5 SoM on the ST1 board | Development only |
| `zedboard` | Zedboard | Development/testing platform |

The generally supported machines are `pandabox`, `pandabox2` and `pandabrick`;
`xu5-st1` and `zedboard` are development-only targets.

:::{note}
`pandabox` is the default machine built when `KAS_MACHINE` is not set.
:::

Per-target hardware descriptions (SoC, expansion connectors, FMC slots,
notable capabilities) are in [](../explanations/hardware-targets.md).
