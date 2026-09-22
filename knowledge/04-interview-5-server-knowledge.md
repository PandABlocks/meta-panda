# PandABlocks-server — Documentation Knowledge File (Session 5)

**Scope:** TCP server interface, building/integrating the server, data-capture
semantics, and config paths — all living in the **PandABlocks-server** repo, plus
related cross-repo docs that surfaced during the interview.

> Note: the SDK cross-compile path discussed in the old docs is being **removed**
> (see below), so several "decided" items below supersede current docs rather than
> describing them.

---

## 1. Building & testing the server

**Canonical workflow (largely not yet reflected in current docs):**

- **Standalone build = simulation-mode testing only.** Server changes are tested
  natively in **simulation mode** (docs live in the server repo). Requirements are
  only `make` and `gcc`; native build, no cross-compile.
- A forthcoming **`PandABlocks-devcontainer` image** will standardise this
  build/test/doc flow, with the **same flow mirrored in the FPGA repo**.
- **Live-system builds go through Yocto `devtool`**, which builds inside the **`kas`
  container** and deploys to a PandA for **manual testing**.
- **The SDK cross-compile path is being removed** — it is non-standard and not
  currently used anywhere. `pandablocks-sdk.rst`'s SDK workflow should be **retired**.

**Disposition of `pandablocks-sdk.rst`:**

- **Delete the SDK / host-installer content** (including the unexplained
  "the sdk installer is also provided to use it in the host directly" line — it goes
  with the rest).
- **Replace it with a new meta-panda doc: "How to test firmware changes on a PandA."**
- That new doc covers:
  - the **`devtool` flow** (build in `kas` container → deploy to a PandA for manual
    testing), and
  - the **FPGA override mechanism** (captured below).

---

## 2. FPGA override mechanism (context captured for the new meta-panda doc)

- Each **PandABlocks-FPGA `.ipk` ships an FPGA bitstream and declares a required FMC**,
  validated by checking selected **EEPROM** values. This links EEPROM population to
  firmware selection.
- meta-panda selects the correct FPGA image by:
  1. honouring the **`APP` variable in `config.txt`** if set;
  2. if unset, **auto-selecting the FPGA image whose FMC requirements are satisfied**
     per the EEPROM check;
  3. **erroring if more than one image** would be satisfied.

---

## 3. `CONFIG` file syntax (server Makefile)

- **Both syntaxes are believed to be supported** by the server Makefile's `CONFIG`
  (no-spaces `KERNEL_DIR=...` and spaced `PYTHON = python3`), since `CONFIG` is read
  as a Makefile include.
- **OPEN QUESTION — verify** against the actual Makefile before documenting.
- **No canonical `CONFIG` example finalised yet** — pending the syntax check.

---

## 4. Capture options (`*CAPTURE.OPTIONS?`)

**Disagreement across pages resolved as follows:**

- **Authoritative list = the superset of all four sources:**
  `No / Value / Diff / Sum / Mean / Min / Max / Min Max / Min Max Mean / StdDev`.
- **One canonical doc fully expands and defines each option** (the explainer page —
  exact filename **TBC**), and **all other pages reference it** rather than re-listing.
- That canonical doc carries a **note to run `*CAPTURE.OPTIONS?` on the live TCP
  server** to see which options the **current firmware/FPGA bitstream combination**
  actually supports.

Sources reconciled: `capture.rst`, `commands.rst` (`*CAPTURE.OPTIONS?`),
`fields.rst`, and meta-panda `tutorial2`.

---

## 5. Data-capture throughput (FRAMED RAW)

- The **~60 MByte/s** FRAMED RAW figure is **still accurate** for current
  hardware/firmware — retain as stated in `capture.rst`.
- **Keep the "when panda-webcontrol is not installed" caveat** — webcontrol
  contention remains the relevant limiting factor.

---

## 6. Config file paths

- **`/opt/share/panda/config_d` is still the correct config load path** on a PandA
  under Yocto/opkg — no change needed in `config.rst`.

---

## 7. TCP interface / API reference (Gap A — resolved)

- **The existing server docs are essentially the TCP reference already** — move them
  into a dedicated **reference section** with light reformatting, rather than
  authoring from scratch.
- **`commands.rst`** (and related server pages) become the **spine** of that reference
  section.
- The **empty `genindex` placeholders go away** — the rootfs `reference.md` toctree
  entries pointing at non-existent `genindex` / "APIs" are resolved by this
  consolidation (github.io `genindex.rst` placeholder likewise retired).

---

## 8. Streaming vs fixed tables (Gap B — resolved)

- The **`<<` / `<<|` streaming operators are used only for long, DMA-driven tables** —
  that's the distinguishing use case versus fixed tables.
- This deserves its **own page in the server docs**, explaining how streaming tables
  work, how to **choose buffer sizes**, etc.
- **`fields.rst` points to that new page** rather than carrying the explanation itself;
  it retains the `MODE` transition matrix as reference.

---

## 9. Extension server (Gap C — OPEN ITEM)

- **Recorded as an open item** — the extension-server explainer (`extension.rst`) must
  be **verified against the current implementation before rewriting**.
- The refresh should eventually cover: what the extension server is for; how
  `extension_read` / `extension_write` map to field access; how `.py` extension modules
  are loaded/registered; and where they live on the system.
- Until then, `config.rst` (server) and `block.rst` (FPGA) keep references pointing at
  the page flagged as outdated.

---

## 10. Related cross-repo docs & loose threads

**"How to build an FPGA image" (PandABlocks-FPGA repo):**

- Lives in the **FPGA repo**; the article ends with a produced **`.ipk`** file and a
  pointer onward to **"How to choose the FPGA bitstream"** in meta-panda.

**"How to choose the FPGA bitstream" (meta-panda):**

- Explains how the **`APP` variable in `config.txt`** works.
- Points back to the FPGA doc for making the image.
- Covers going live: **`scp` the file → `opkg install` → `systemctl restart`.**
- **Also referenced from "How to test firmware changes on a PandA"** (the new
  meta-panda doc from §1).

---

## Open items to verify before publishing

1. **`CONFIG` syntax (§3):** confirm the server Makefile accepts both spaced and
   non-spaced `=`; then settle on a canonical `CONFIG` example.
2. **Canonical capture-options explainer (§4):** identify which doc/file is the
   home for the fully-expanded option definitions.
3. **Extension server (§9):** verify `extension.rst` against current implementation
   before rewriting.
