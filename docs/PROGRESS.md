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
- ☐ Pages deploy green — existing `.github/workflows/docs.yml` still builds Sphinx; needs switch to `myst build` (see Notes)

## Tutorials
- ◐ tutorials/tutorial0_connecting_to_web_control — source: webcontrol/userguide/quick-start.rst — writable-now
- ◐ tutorials/tutorial1_blinking_leds — source: tutorials/tutorial1_blinking_leds.rst — writable-now
- ◐ tutorials/tutorial2_position_capture — source: tutorials/tutorial2_position_capture.rst — writable-now
- ⛔ tutorials/tutorial3_position_compare — source: tutorials/tutorial3_position_compare.rst (stub) — blocked: capture
- ⛔ tutorials/tutorial4_snake_scan — source: tutorials/tutorial4_snake_scan.rst (stub) — blocked: capture

## How-to
- ◐ how-to/quickstart — source: how-to/quickstart.rst + rootfs quickstart.md — writable-now
- ◐ how-to/build — source: how-to/build.rst + run-container.rst (KAS) — writable-now (KAS_IMAGE_VERSION = verify)
- ◐ how-to/manual-build — source: tutorials/manual-build.rst — writable-now (post-5.0 branch = verify)
- ◐ how-to/make-release — source: how-to/make-release.rst — writable-now
- ◐ how-to/packages — source: how-to/packages.rst — writable-now
- ◐ how-to/upgrade-via-ssh — source: how-to/remote.rst — writable-now (gap audit = verify)
- ◐ how-to/upgrade-via-web-admin — source: how-to/web-interface.rst — partial (zpg filename = verify)
- ◐ how-to/use-web-control-to-set-up-a-panda — source: webcontrol/userguide/working_with_a_design.rst — writable-now (widget screenshots = capture) [Prompt E]
- ◐ how-to/save-restore-design — source: working_with_a_design.rst (Saving/Opening) — writable-now [Prompt E split]
- ◐ how-to/monitor-attribute-values — source: webcontrol/userguide/monitoring_attribute_values.rst — writable-now
- ◐ how-to/integrate-with-a-panda — source: NEW (Interview5; client + fastcs) — writable-now (skeleton). Holds the Stage A xref probe.
- ◐ how-to/test-firmware-changes — source: NEW (Interview5 §1-2) — writable-now
- ◐ how-to/choose-fpga-bitstream — source: NEW (Interview5 §10; Interview3 §4) — writable-now
- ✅ how-to/contribute — source: `{include} .github/CONTRIBUTING.md` — scaffold include resolves (content merge later)

## Reference
- ◐ reference/opkg — source: reference/opkg.rst — writable-now
- ⛔ reference/changes — source: github.io migration_guide.rst + release_compatibility.rst — blocked: verify (3.0->4.0)
- ◐ reference/machine-targets — source: NEW (Interview6 §A) — partial (PandABrick = verify)
- ◐ reference/glossary — source: webcontrol glossary.rst + FPGA glossary.rst — writable-now (canonical merge)
- ◐ reference/troubleshooting — source: quickstart.rst FAQ (7 Qs) — writable-now (seed)

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
- **Pages workflow.** `.github/workflows/docs.yml` still runs `python3 -m sphinx`. It must be switched
  to `myst build` for the new docs to deploy (Stage A spec §8). Left for a follow-up so this scaffold
  PR stays docs-only; flagged here and in the PR.
