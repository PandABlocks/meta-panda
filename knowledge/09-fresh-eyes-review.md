# Fresh-eyes review of the docs branches (pre-push)

Read as: (1) a brand-new PandABox owner starting from the meta-panda index, assuming all
Stage-B issues eventually get done by a human; (2) a user doing typical tasks — updating
firmware, deploying a custom bitstream, writing a new FPGA block and adding it to an image.
Every claim was checked against the repo sources (Makefiles, `conf/machine/`, `server.c`,
legacy RST), not just read for style.

**Status update (2026-06-12):** everything fixable without user input has now been
**applied** to the working trees of all three repos. All three docs sites rebuild cleanly
(`myst build`: no errors, no new warnings) and `create-issues.sh` passes `bash -n` with all
of its sed/perl targets re-verified against the edited pages. What remains is listed in
[What's left](#whats-left) below.

## Overall verdict (unchanged)

The structure is right. Diátaxis split is clean, the meta-panda-as-root model works, the
tutorial sequence 0→1→2 is genuinely good, and the server reference quadrant is strong.
The big problems were concentrated in one factually wrong page (FPGA `build-fpga-image`),
one internally inconsistent page (server `streaming-tables` vs `fields`), and a handful of
accuracy errors — all now fixed.

---

## A. Factual errors — ALL FIXED ✅

### A1. FPGA `how-to/build-fpga-image.md` described a nonexistent kas/bitbake flow ✅ FIXED
**Rewritten from scratch** around the real flow verified against the Makefile:
`cp CONFIG.example CONFIG` → set `APP_NAME` (from `apps/*.app.ini`) and `VIVADO`/
`VIVADO_VER` (default 2023.2) → `make` (≡ `make ipk`; `make all-ipks` for every app) →
`build/panda-fpga-<app>_<version>_all.ipk` → `scp` + `opkg install` (or Web Admin).
Links to the dev-container setup and meta-panda deploy pages. *(Q2 confirmed by user:
make-only, no kas path — clarifying sentence added to the page.)*

### A2. FPGA `how-to/app.md` — wrong output format / variable ✅ FIXED
zpkg → `.ipk` (`panda-fpga-<app>_<version>_all.ipk`), `APPS = PandABox-no-fmc` →
`APP_NAME = pandabox-no-fmc`, added `make all-ipks` and a link to `build-fpga-image`.
*(The `*METADATA.APPNAME?` example was later user-confirmed as kebab-case following the
`.ipk` name and corrected to `pandabox-fmc-24vio` — see What's left #6.)*

### A3. meta-panda `reference/machine-targets.md` machine list ✅ FIXED
Table now matches `conf/machine/`: dropped nonexistent `xu5-s1`, added `pandabox2`.
`pandabrick` row de-flagged (it exists in-tree: `conf/machine/pandabrick.conf`); a verify
comment now sits on `xu5-st1` (support tier unknown). **`create-issues.sh` updated to
match**: I4 repurposed from "verify PandABrick" to "verify support tiers + details"
(its sed retargeted to the new comment), I8's machine list corrected.

### A4. server `streaming-tables.md` vs `fields.md` ✅ FIXED
- MODE transition table corrected to match `fields.md` and legacy `fields.rst`:
  `STREAMING` + `<` = Reject, `STREAMING_LAST` rejects all but `<0`, completed/`[HEALTH]`
  row added; prose about the implicit FPGA completed state restored.
- `B` description fixed (just base-64 content); the `left:right` format moved to a new,
  correct `FIELDS` entry.
- `LENGTH`/`MAX_LENGTH` now both say 32-bit **words** in both pages (fields.md summary
  table rows fixed too).

### A5. server `how-to/startup.md` ✅ FIXED
Second `-p` → `-P` *pid-file*; added `-r` *rootfs-version* (reported via `*IDN?`).
Verified against `server.c` getopt string and usage text.

### A6. Capture-option drift across three pages ✅ FIXED (verified against `pos_out.c`)
Ground truth from `server/pos_out.c` (`capture_option_info` + `nominal_capture_masks`):
individual options Value/Diff/Sum/Mean/Min/Max/StdDev (StdDev only listed when the FPGA
supports it); curated enums add No, Min Max, Min Max Mean, **Mean StdDev**.
`capture-options.md` is now the true superset (combinations + full enum list, caution
downgraded to a note); `capture.md` and `fields.md` gained the StdDev / Mean StdDev rows
so all three pages agree. **Bonus fix found en route:** `commands.md` omitted the
`METADATA` change group (`*CHANGES.METADATA` exists in `system_command.c`) — added to all
four places. **I14 in `create-issues.sh` slimmed** to a ~30-min live-server confirmation
(its sed replaced with a working perl substitution, dry-run tested).

### A7. meta-panda `integrate-with-a-panda.md` wrong link ✅ FIXED
Now points at the server commands reference (absolute Pages URL, Stage F swap comment).

### A8. `Image` vs `image.ub` ✅ FIXED (Q6 answered by source)
`build.sh:22` and `_make_boot.yml` copy the fitImage to **`image.ub`**; the boot archive
contains `boot.bin, boot.scr, image.ub, rootfs.squashfs, target-defs`. `upgrade-via-ssh.md`
corrected; all three pages now agree.

### A9. `modules/lut/lut_doc.md` truncated sentence ✅ FIXED
Restored the dropped cross-ref as a link to the server fields reference.

### A10. fields.md loose ends ✅ FIXED (Q7 answered by source)
- `*CHANGES.PARAM` → `*CHANGES.CONFIG` in both places. Verified: change groups in
  `config_server.h`/`system_command.c` are CONFIG/BITS/POSN/READ/ATTR/TABLE/METADATA
  (no PARAM); `param`/`time` classes use `CHANGE_IX_CONFIG` (`register.c:288`,
  `time.c:374`).
- enum `LABELS` attribute removed from the sub-type summary (no such attribute in the
  server source; labels come via `*ENUMS`).

## B. Web-control content provenance — ✅ RESOLVED (user confirmed against live UI)

User answers (2026-06-11): port colours are only **Boolean = Blue** and **Int32 =
Orange** (Motor/NDArray rows deleted); Exports/camelCase is correct; the method
execution log is correct but there is only a **single method: *Save*** on the Parent
Block (taking the design name as its input parameter); Auto Layout is accurate; the
save dialog field is labelled **Design Name** — "Filename" appears nowhere in the GUI.
All applied to `use-web-control-to-set-up-a-panda.md` and `save-restore-design.md`.
**I2 restored to screenshot-only scope** (verification checklist removed).

## C. Cross-link & asset integrity

### C1. Figures served from `docs/_legacy_rst/` ✅ FIXED
- meta-panda: all 19 referenced images copied to `docs/images/webcontrol/` and every
  reference repointed (tutorial0, use-web-control, web-control-ui-overview,
  monitor-attribute-values, understanding-attribute-state). Zero `_legacy_rst` image
  refs remain.
- FPGA: `build_arch.png` copied to `docs/images/` and `block.md` repointed.
- `_legacy_rst/` deletion is now safe (images-wise) in both repos.

### C2. Dead `meta-panda:` xrefs ✅ FIXED (Q8 decided: absolute URLs)
The only offenders were in `build-fpga-image.md`, which was rewritten using absolute
Pages URLs with `<!-- Stage F: swap to xref -->` comments (the same pattern server
`capture.md` already used). Repo-wide grep confirms no `(meta-panda:` links remain.

### C3. "Prompt C" runbook jargon in published page ✅ FIXED
`understanding-attribute-state.md` placeholders reworded to *(icon pending)*; the HTML
comments retain the `docs/images/attribute-state/<name>.svg` target paths so Prompt C can
still find them.

### C4. PandABlocks-devcontainer ✅ RESOLVED — decision changed to per-repo devcontainers
User decision (2026-06-11): **no separate PandABlocks-devcontainer repo.** Each repo
carries its own `.devcontainer/devcontainer.json` + Dockerfile, modelled on
python-copier-template (`ubuntu-devcontainer:noble` base, `developer` target), with
repo-specific tools to be added. meta-panda alone uses the kas base
(`ghcr.io/siemens/kas/kas:4.8`, matching `KAS_IMAGE_VERSION` in build.sh; placed at
`.devcontainer/Dockerfile` because the root `Dockerfile` is the existing rockylinux
FPGA-tools/CI container and must not be touched). Created in all three repos; all
doc pointers updated (FPGA `local-development.md`, server `building.md` tip,
meta-panda `contribute.md` xref table); commented `PandABlocks-devcontainer:`
reference keys removed from all three `myst.yml` files; runbook Stage F prompt and
one-time-setup step annotated as superseded.

## D. Structure & gaps

### D1. Root index Yocto-first framing ✅ FIXED
`README.md` (included by the index) now opens with three sentences of PandABlocks-level
framing — what a PandA is, what these docs cover, where component docs live — before the
`meta-panda`-layer paragraph.

### D2. Unboxing signpost ✅ FIXED
`tutorials.md` landing and tutorial 0 prerequisites now point users whose PandA isn't on
the network yet at `how-to/quickstart`.

### D3. meta-panda how-to TOC ordering ✅ FIXED
`docs/myst.yml` TOC rebanded: use (quickstart, use-web-control, save-restore, monitor,
integrate) → administer (upgrade ×2, packages, choose-fpga-bitstream) → develop (build,
manual-build, test-firmware-changes, make-release, contribute), with YAML comments
marking the bands.

### D4. FPGA block→deploy journey ✅ FIXED
`block.md` gained a "Next steps" section chaining block → app → build-fpga-image →
choose-fpga-bitstream; `how-to.md` landing gained a one-line pipeline overview.

### D5. `CLOCKS` vs `CLOCK1` ✅ FIXED (Q5 answered by source)
The shipped `template_tutorial1_leds.json` design uses `CLOCK1`/`CLOCK2`, and the firmware
module is `modules/clock` (no CLOCKS block). Tutorial 1 corrected to **CLOCK1** in both
places.

### D6. Minor batch — MOSTLY FIXED
- ✅ meta-panda glossary `App` entry now leads with `.ipk`, demotes zpkg to legacy; FPGA
  glossary `App` entry now says `.ipk`, and its `Zpkg` entry gained the legacy/replaced
  note.
- ⏳ `web-control-ui-overview.md` **Auto Layout** — folded into the extended I2 (see §B).
- ⏳ FPGA `framework.md` "needs a refresh" note still has no tracking issue (issues don't
  exist yet — could be linked after the script runs, or left for Stage F).
- ⏳ `finedelay-test.md` raw `PandABlocks.github.io` script URL — Stage F note unchanged.

## E. Issue-script changes made ✅

All applied to `create-issues.sh` (syntax-checked, every sed/perl target re-verified):
1. **I2** — title + body extended with the §B live-UI verification checklist.
2. **I4** — repurposed: machine list is now ground-truthed; remaining work is support
   tiers (xu5-st1/zedboard) and Notes-column details (pandabox2/pandabrick); sed
   retargeted to the new HTML comment in machine-targets.md.
3. **I8** — machine list corrected to `conf/machine/` ground truth.
4. **I14** — slimmed to a live-server confirmation of the now source-verified capture
   options; broken sed replaced with a tested perl substitution.

---

(whats-left)=
## What's left

| # | Item | Why it needs you |
|---|---|---|
| 1 | ~~§B web-control content~~ | ✅ Resolved — user confirmed against live UI, all trims applied (see §B). |
| 2 | ~~C4 devcontainer pointers~~ | ✅ Resolved — per-repo devcontainers created in all three repos (see C4). |
| 3 | ~~README machine list~~ | ✅ Resolved — user confirmed (2026-06-12) xu5-st1 and zedboard are dev-only. README stays at three; `machine-targets.md` notes the tier split; I4 slimmed to pandabox2/pandabrick hardware details only (sed retargeted, verified). |
| 4 | **framework.md refresh note** | Untracked "needs a refresh" flag — link to an issue after the script runs, or fold into Stage F. |
| 5 | **finedelay script URL** | Stage F item: if PandABlocks.github.io becomes a redirect, the raw script needs a new home. |
| 6 | ~~app.md `*METADATA.APPNAME?` example~~ | ✅ Resolved — user confirmed (2026-06-12): kebab-case, following the `.ipk` name (e.g. `panda-fpga-pandabox-fmc-acq430_4.2b1.ipk` → `pandabox-fmc-acq430`). Example corrected to `pandabox-fmc-24vio`; stale verify note removed. |

## Remaining questions

*All answered.* Q1 web control and Q4 devcontainer — user, see §B and C4. **Q2 (FPGA
build)** — user confirmed (2026-06-12): FPGA is strictly make-driven, producing the
`.ipk` with a custom script; no kas involved; meta-panda only *includes* that `.ipk`
in the system image. A clarifying sentence was added to `build-fpga-image.md`. Former
Q3 machine list, Q5 CLOCKS, Q6 image.ub, Q7 \*CHANGES group and Q8 interim links were
all resolved against repo sources — see A3, D5, A8, A10, C2 above.
