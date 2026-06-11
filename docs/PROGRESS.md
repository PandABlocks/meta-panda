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
- ◐ how-to/use-web-control-to-set-up-a-panda — source: webcontrol/userguide/working_with_a_design.rst — SKIP (Prompt E)
- ◐ how-to/save-restore-design — source: working_with_a_design.rst (Saving/Opening) — SKIP (Prompt E split)
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
- ◐ explanations/boot-process — source: explanations/boot-process.rst — writable-now
- ◐ explanations/architecture — source: NEW (Interview1) — writable-now (skeleton)
- ⛔ explanations/hardware-targets — source: NEW (Interview6 §A) — blocked: author
- ◐ explanations/web-control-ui-overview — source: webcontrol/userguide/user_interface_overview.rst — writable-now
- ◐ explanations/understanding-attribute-state — source: webcontrol/userguide/understanding_attribute_state.rst — writable-now (8 icons via Prompt C)
- ✅ explanations/decisions + decisions/0001,0002,COPYME — kept byte-for-byte from skeleton (ADR migration of 0002-switched-to-pip-skeleton is a later `move` task)

## Blocked (issues raised)
Issues not yet created — Stage B (Prompt B) will create and link them. Blocked pages:
- ⛔ tutorials/tutorial3_position_compare — issue #TBD — human-capture
- ⛔ tutorials/tutorial4_snake_scan — issue #TBD — human-capture
- ⛔ reference/changes — issue #TBD — verify (3.0->4.0)
- ⛔ explanations/hardware-targets — issue #TBD — author
- ⛔ how-to/use-web-control-to-set-up-a-panda (4 widget screenshots + trailing sentence) — issue #TBD — capture

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
