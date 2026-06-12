# Docs Rewrite Progress — meta-panda

Tracks every target page for this repo. Update the relevant line **in the same commit** as the file
it refers to. Statuses: ☐ todo · ◐ stub · ✅ converted · 🔍 needs-review · ⛔ blocked (→ issue #).
Page list expanded from `06-source-provenance-map.md`.

## Stage A — scaffold
- ✅ skeleton instantiated (title/github/logo swapped, apidoc + pip-tutorial + run-container removed)
- ✅ TOC + stubs for every target page present (33 stubs + 4 landing + index + decisions)
- ✅ `index.md` README-include + `how-to/contribute` CONTRIBUTING-include resolve
- ✅ xref/intersphinx wired + cross-link probe resolves in built output
- ☐ (FPGA only) — N/A for meta-panda
- ✅ `myst build` green (exit 0, no warnings/errors)
- ✅ Pages deploy wired — `.github/workflows/docs.yml` switched from Sphinx to `myst build` (see Notes)

## Tutorials
- ✅ tutorials/tutorial0_connecting_to_web_control — source: webcontrol/userguide/quick-start.rst — converted
- ✅ tutorials/tutorial1_blinking_leds — source: tutorials/tutorial1_blinking_leds.rst — converted
- ✅ tutorials/tutorial2_position_capture — source: tutorials/tutorial2_position_capture.rst — converted
- ⛔ tutorials/tutorial3_position_compare — source: tutorials/tutorial3_position_compare.rst (stub) — blocked: capture
- ⛔ tutorials/tutorial4_snake_scan — source: tutorials/tutorial4_snake_scan.rst (stub) — blocked: capture

## How-to
- ✅ how-to/quickstart — source: how-to/quickstart.rst + rootfs quickstart.md — merged; boot.txt→config.txt fixed; FAQ moved to reference/troubleshooting
- ✅ how-to/build — source: how-to/build.rst + run-container.rst (KAS) — merged; KAS_IMAGE_VERSION verify note added
- ✅ how-to/manual-build — source: tutorials/manual-build.rst — manifest URL fixed (Xilinx/yocto-manifests); post-5.0 branch verify noted
- ✅ how-to/make-release — source: how-to/make-release.rst — releases link fixed → meta-panda
- ✅ how-to/packages — source: how-to/packages.rst — converted
- ✅ how-to/upgrade-via-ssh — source: how-to/remote.rst — pre-5.0 + post-5.0 covered; 24V EEPROM DLS-only noted; gap audit verify noted
- ✅ how-to/upgrade-via-web-admin — source: how-to/web-interface.rst — pre-5.0 zpg path + fresh SD card install added; zpg filename verify noted
- ✅ how-to/use-web-control-to-set-up-a-panda — source: webcontrol/userguide/working_with_a_design.rst — converted (Prompt E); attribute widgets folded in; 4 widget subsections (View/Edit, Dropdown, Text Input, Checkbox) + trailing sentence kept as blocked: capture stub w/ issue link
- ✅ how-to/save-restore-design — source: working_with_a_design.rst (Saving/Opening) — split out (Prompt E); Saving a Design + Opening an Existing Design
- ✅ how-to/monitor-attribute-values — source: webcontrol/userguide/monitoring_attribute_values.rst — converted
- ✅ how-to/integrate-with-a-panda — source: NEW (Interview5; client + fastcs) — skeleton written; xref probe preserved
- ✅ how-to/test-firmware-changes — source: NEW (Interview5 §1-2) — authored
- ✅ how-to/choose-fpga-bitstream — source: NEW (Interview5 §10; Interview3 §4) — authored
- ✅ how-to/contribute — content merge from github.io + xref/intersphinx setup documented

## Reference
- ✅ reference/opkg — converted from reference/opkg.rst
- ⛔ reference/changes — source: github.io migration_guide.rst + release_compatibility.rst — blocked: verify (3.0->4.0)
- ✅ reference/machine-targets — NEW from Interview6 §A; PandABrick verify noted
- ✅ reference/glossary — canonical merge of webcontrol + FPGA glossaries; MyST {glossary} directive
- ✅ reference/troubleshooting — seeded from quickstart.rst FAQ (7 Qs); boot.txt→config.txt fixed

## Explanations
- ✅ explanations/boot-process — converted from explanations/boot-process.rst
- ✅ explanations/architecture — skeleton authored from Interview1; TCP/client/EPICS/data flow
- ⛔ explanations/hardware-targets — blocked: author
- ✅ explanations/web-control-ui-overview — converted from user_interface_overview.rst; screenshots reused
- ✅ explanations/understanding-attribute-state — 8 states described; 5 existing PNG icons referenced from _legacy_rst; 3 missing icons (Processing, Update Error, Invalid) pending Prompt C SVGs
- ✅ explanations/decisions + decisions/0001,0002,COPYME — kept from scaffold (no change)

## Blocked (issues raised)
Issues not yet created — Stage B (Prompt B) will create and link them. Blocked pages:
- ⛔ tutorials/tutorial3_position_compare — issue #12 — human-capture
- ⛔ tutorials/tutorial4_snake_scan — issue #12 — human-capture
- ⛔ reference/changes — issue #14 — verify (3.0->4.0)
- ⛔ explanations/hardware-targets — issue #19 — author
- ⛔ how-to/use-web-control-to-set-up-a-panda (widget screenshots + trailing sentence) — issue #13 — human-capture

- ⛔ reference/machine-targets (hardware details) — issue #15 — verify

- ⛔ how-to/build (KAS_IMAGE_VERSION) — issue #16 — verify

- ⛔ how-to/upgrade-via-web-admin (zpg filename) — issue #17 — verify

- ⛔ how-to/manual-build (Xilinx branch post-5.0) — issue #18 — verify

- ⛔ infrastructure: versioned docs / version switcher (R5) — issue #20 — infrastructure

## Notes
- **Legacy sources preserved.** The original Sphinx/RST tree was moved to `docs/_legacy_rst/`
  (not in the TOC, ignored by `myst build`) so Stage D/E conversion can read the cited source
  files in-tree at their `06` paths (under `docs/_legacy_rst/...`). They also remain on
  `origin/main` / `origin/rel-v2023.2`. Screenshots stay reusable in place there; tutorial
  screenshots also live at `docs/images/`. Delete `_legacy_rst/` once conversion is complete.
- **Logo / icon swap** already done upstream in the skeleton: `images/PandA-logo-for-black-background.svg`.
- **xref/intersphinx prototype.** `myst.yml project.references` currently activates only
  `PandABlocks-client` (deployed). The probe link in `how-to/integrate-with-a-panda` resolves in
  built output to `.../PandABlocks-client/main/reference/api.html#pandablocks.blocking.blockingclient`.
  The other core repos + devcontainer + fastcs are kept commented (their docs aren't published yet);
  uncomment in Stage F and upstream the block into python-copier-template.
- **Pages workflow.** `.github/workflows/docs.yml` is modelled on the python-copier-template-example
  `_docs.yml` (checkout@v5, sanitized `DOCS_VERSION`, `upload-artifact@v4` of `docs/_build` as `docs`,
  move to versioned `.github/pages/<version>/`, `make_switcher.py` → `switcher.json`, publish via
  peaceiris v4.0.0 pinned SHA with `keep_files: true`). Adaptations from the template: (1) build uses
  npm + mystmd (`myst build --html`) instead of `uv run tox -e docs` since meta-panda is a Yocto layer,
  not a Python/uv project; (2) `BASE_URL=/meta-panda/<version>` is set so assets resolve under the
  versioned Pages sub-path (the template's in-progress mystmd migration doesn't set it yet). Root
  branch is now **`main`**: publish is gated to `github.ref_name == 'main' || ref_type == 'tag'`, and
  `.github/pages/index.html` redirects to `./main/index.html`. Validated locally end-to-end with
  `DOCS_VERSION=main`. The version switcher is generated but wiring it into the theme is the deferred
  R5 (versioned docs) item.
