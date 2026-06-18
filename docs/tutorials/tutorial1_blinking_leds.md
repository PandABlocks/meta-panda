# Tutorial 1: Blinking LEDs

This tutorial introduces the basics of PandABlocks: how to wire blocks together
so that different LEDs flash at different rates.

## Prerequisites

- A PandA powered on and reachable in your browser
  (see [](tutorial0_connecting_to_web_control.md)).
- The `template_tutorial1_leds` design saved on your PandA (pre-loaded on all
  standard PandA images).

## Opening the web control

Navigate to `http://<panda-hostname>/` in your browser.
The welcome page has links for **Docs**, **Control** and **Admin** at the bottom.
Click **Control** to open the web control.

## Loading the tutorial design

The **Design** drop-down lists saved designs stored on the PandA.
Selecting one replaces the current block settings with the saved ones.

Select **template_tutorial1_leds** from the drop-down.
The blocks and wiring will change to:

```{image} ../images/tutorial1_layout.png
```

If you look at the front panel of the PandA you should see the first four TTL
output LEDs turn on sequentially, then turn off in reverse order.

## How the design works

The **CLOCK1** block generates a 50% duty-cycle pulse train with a 1 s period.
**PULSE1–4** each take this as an input trigger and produce a pulse with a
different width and delay.  The PULSE blocks act as a delay line, queuing pulses
until each delay expires.

Click on any PULSE block to see its settings:

```{image} ../images/tutorial1_pulse.png
```

:::{tip}
Increase a PULSE delay beyond 1 s and the **Queued** field will grow — the block
continues producing pulses at the correct delay.  If you increase the **Width**
beyond the period the block drops the pulse instead of merging it, reporting the
drop in the **Dropped** field.
:::

You can also click the **CLOCK1** block to adjust the input pulse period.

To explore further, try wiring pulse outputs to different TTLOUT blocks:
click the Palette icon, drag a **TTLOUT** block onto the canvas, then connect a
PULSE out port to the TTLOUT val port by dragging between them.

## The bit bus

All visible block ports are blue — they carry single boolean (bit) values.
You can view all bit values at once by clicking **Bits** in the left-hand panel:

```{image} ../images/tutorial1_bits.png
```

Scroll to the PULSE section to see the same flashing pattern as on the PandA
front panel.

:::{note}
The web control polls the PandA at 10 Hz, receiving the current value of each
bit and whether it has changed.  It displays the current value for signals
toggling below 5 Hz and a 5 Hz pulsing indicator for faster signals — so even
short pulses are visible.  Front-panel LEDs behave similarly, capped at 10 Hz.
:::

## Summary and next steps

You have loaded a saved design, inspected block parameters, and seen bit outputs
connected to hardware TTL outputs via TTLOUT blocks.

Continue with [](tutorial2_position_capture.md) to learn about position outputs
and data capture.
