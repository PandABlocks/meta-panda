# PandABlocks Docs — Source-Provenance Map

Per target page: the exact source file(s) and **sections** that feed it, so each Claude Code task is
self-contained. Word counts and section names are from a close-read of the current repos (heads of
`main`/default). Read alongside the target map (03) and Stage A spec (05).

## Corrections to v4 discovered during close-read (apply these)
- **Web-control source lives inside meta-panda** at `docs/webcontrol/userguide/*` — *not* a separate
  repo. (A `PandABlocks-webcontrol` repo exists but carries no published `docs/`.)
- **Tutorials are triplicated and byte-identical** across meta-panda, FPGA and github.io. Canonical =
  **meta-panda**; delete the FPGA and github.io copies. t1 (648w) and t2 (1167w) are real; **t3 (41w)
  and t4 (52w) are near-empty stubs** → `blocked: capture` confirmed.
- **`understanding_attribute_state` has EIGHT states** (Normal, Processing, Locally Edited, Update
  Error, Warning, Error, Invalid, Disconnected) + "Presenting Status Information" — the icon-recreation
  task covers all eight indicators, not three.
- **FPGA `reference/changelog.rst` is empty** (3 words) → maps to the Release-Notes `url:` slot; drop the file.
- **github.io `migration_guide.rst` only documents 2.0→3.0** — 3.0→4.0 is genuinely absent (the verify gap).
- FPGA `app`/`block`/`testing`/`cocotb` currently sit under `reference/`; D2 moves them to `how-to/`.
- The quickstart **FAQ (7 Qs)** is extracted out of `how-to/quickstart` into `reference/troubleshooting`.

Legend: `→` = becomes; `⊃` = extract subsection; `+` = merge; status as in 03.

---

## meta-panda

| Target | Source → sections | Action notes | Status |
|---|---|---|---|
| `tutorials/tutorial0_connecting_to_web_control` | `webcontrol/userguide/quick-start.rst` (376w, "Quick Start") | rewrite as tutorial0; reuse screenshots | writable-now |
| `tutorials/tutorial1_blinking_leds` | `tutorials/tutorial1_blinking_leds.rst` (648w) | rewrite | writable-now |
| `tutorials/tutorial2_position_capture` | `tutorials/tutorial2_position_capture.rst` (1167w) | rewrite; keep "next tutorial" promise | writable-now |
| `tutorials/tutorial3_position_compare` | `tutorials/tutorial3_position_compare.rst` (41w **stub**) | author from human screenshots+bullets | blocked: capture |
| `tutorials/tutorial4_snake_scan` | `tutorials/tutorial4_snake_scan.rst` (52w **stub**) | author from human screenshots+bullets | blocked: capture |
| `how-to/quickstart` ("How to get a PandA on the network") | `how-to/quickstart.rst` (817w: Getting a PandA on the network, Override file, Web Interface, Web Admin) + rootfs `how-to/quickstart.md` | merge; fix `boot.txt`→`config.txt` in *Override file*; add `panda-config.txt` USB override; **FAQ section moves to reference/troubleshooting** | writable-now |
| `how-to/build` ("How to build the PandA image") | `how-to/build.rst` (275w: Building the panda image, Output Files) + `how-to/run-container.rst` ⊃ KAS part (167w: Run in a container, Starting the container) | merge; fold in `KAS_IMAGE_VERSION` | partial; KAS_IMAGE_VERSION = blocked: verify |
| `how-to/manual-build` | `tutorials/manual-build.rst` | fix manifest URL → `Xilinx/yocto-manifests`, branch `rel-v2023.2` | writable-now (post-5.0 branch = verify) |
| `how-to/make-release` | `how-to/make-release.rst` | de-dupe vs github.io copy; fix releases link → meta-panda | writable-now |
| `how-to/packages` | `how-to/packages.rst` | →MyST | writable-now |
| `how-to/upgrade-via-ssh` ("Upgrading a PandA over SSH") | `how-to/remote.rst` (245w: Updating the rootfs, Update 24V eeprom) | keep 24V EEPROM as DLS-only one-time; cover pre-5.0 + post-5.0 | writable-now; gap audit = verify |
| `how-to/upgrade-via-web-admin` ("Upgrading a PandA via the web admin interface") | `how-to/web-interface.rst` (240w: Updating the rootfs) | + legacy pre-5.0 zpg path + fresh-SD-card install | partial; zpg filename = verify |
| `how-to/use-web-control-to-set-up-a-panda` | `webcontrol/userguide/working_with_a_design.rst` (4882w) ⊃ Adding/Removing a Block, Working with the Block Palette, Specifying Block Attributes (Types, Obtaining Info, Setting, **View/Edit, Dropdown, Text Input, Checkbox**, Exporting, Local vs Server, Attribute Change Lifecycle), Complex Attributes (Tables), Block Methods, Block Ports, Linking Blocks | folds the attribute-widgets; the 4 widget subsections need new screenshots | writable-now (reuse screenshots); widget screenshots + trailing sentence = blocked: capture |
| `how-to/save-restore-design` | `working_with_a_design.rst` ⊃ Saving a Design, Opening an Existing Design | split out of the above | writable-now (reuse screenshots) |
| `how-to/monitor-attribute-values` | `webcontrol/userguide/monitoring_attribute_values.rst` (991w: Working With Charts [Interactive, Enhanced, Exporting, Data Retrieval], Numerical Tables) | →how-to | writable-now (reuse screenshots) |
| `how-to/integrate-with-a-panda` | NEW (Interview5; `PandABlocks-client` + `fastcs-PandABlocks` repos) | author skeleton: TCP direct / Python client / EPICS+Tango via fastcs; covers data-out (binary→HDF5/numpy) | writable-now (skeleton+links) |
| `how-to/test-firmware-changes` | NEW (Interview5 §1–2); **replaces** `how-to/pandablocks-sdk.rst` (drop that) | author | writable-now |
| `how-to/choose-fpga-bitstream` | NEW (Interview5 §10; Interview3 §4); seed from quickstart FAQ "override FPGA bitstream variant" | author | writable-now |
| `how-to/contribute` | github.io `how-to/contribute.rst` + `how-to/update-tools.rst` (84w) + `reference/standards.rst` (17w: Code Standards) + `{include} .github/CONTRIBUTING.md` | merge doc-standards + tooling; document xref/intersphinx setup here | writable-now |
| `reference/opkg` | `reference/opkg.rst` | →MyST | writable-now |
| `reference/changes` | github.io `reference/migration_guide.rst` (119w: **only 2.0→3.0**) + `release_compatibility.rst` (32w) | consolidate per-major with compat embedded; **3.0→4.0 absent** | blocked: verify |
| `reference/machine-targets` | NEW (Interview6 §A) | MACHINE table + links to hardware-targets | partial; PandABrick = verify |
| `reference/glossary` | `webcontrol/userguide/glossary.rst` (732w) **+** FPGA `reference/glossary.rst` | canonical merge; others link here | writable-now |
| `reference/troubleshooting` | ⊃ `how-to/quickstart.rst` "Frequently Asked Questions" — 7 Qs: static network; disable sub-net validation; recover from catastrophic changes; load rootfs to RAM at boot; system freeze after FPGA load; override FPGA bitstream variant; authorise ssh public key | seed page; add boot/FMC/upgrade errors | writable-now (seed); some = verify |
| `explanations/boot-process` | `explanations/boot-process.rst` | keep →MyST | writable-now |
| `explanations/architecture` | NEW (Interview1) | skeleton; points to integration options | writable-now (skeleton) |
| `explanations/hardware-targets` | NEW (Interview6 §A) | per-target hardware | blocked: author |
| `explanations/web-control-ui-overview` | `webcontrol/userguide/user_interface_overview.rst` (1150w: Components, Principle views, Layout View, Attribute View, Panel Popping) | →explanation | writable-now (reuse screenshots) |
| `explanations/understanding-attribute-state` | `webcontrol/userguide/understanding_attribute_state.rst` (535w: **8 states** + Presenting Status Information) | recreate **8** state icons from malcolmjs colour spec; no malcolm in docs | writable-now (Claude recreates icons) |
| `explanations/decisions/*` | github.io `explanations/decisions/0001-record-architecture-decisions.rst`, `0002-switched-to-pip-skeleton.rst` | move | writable-now |
| `.github/CONTRIBUTING.md`, `README.md`, `index.md` | NEW (Interview1 §5) + meta-panda `index.rst` | scaffold | writable-now |
| **DROP** | `webcontrol/index.rst`, `webcontrol/contents.rst`, `webcontrol/userguide/index.rst`, `webcontrol/userguide/contents.rst`, `how-to/pandablocks-sdk.rst`, `how-to/run-container.rst` (after split) | intros→front door, TOCs→quadrants | — |

---

## PandABlocks-FPGA

| Target | Source → sections | Action notes | Status |
|---|---|---|---|
| `reference/blocks` | `blocks.rst` (autogenerated listing) | regenerate to consume md module docs | blocked: tooling |
| `modules/*/*_doc.md` (×42) | `modules/*/*_doc.rst` (×42, beside `.block.ini`/`.timing.ini`) | mechanical RST→MD **in place**; surfacing = §5 open question (symlink vs out-of-tree) | writable-now |
| `how-to/app` | `reference/app.rst` (364w: App ini [`.`,`[BLOCK]`], App build process, Querying at runtime) | →how-to; verify runtime steps | writable-now |
| `how-to/block` | `reference/block.rst` (1610w: Architecture, Modules, Block ini, Block Simulation, Timing ini, Target ini, Writing docs, Block VHDL entity) | →how-to; **not split**; fill *Block VHDL entity* (LUT example); defer *Writing docs* until MyST | partial; "Writing docs" = blocked: tooling |
| `how-to/testing` | `reference/testing.rst` (274w: Python tests, HDL tests) | Travis → GitHub Actions (sim) + DLS GitLab (build) | blocked: verify |
| `how-to/cocotb` | `reference/cocotb.rst` (742w: About, Running, Results [Timing/Waveforms/Coverage], How It Works, Writing Tests for New Modules) | keep "modules using IP unsupported" | writable-now; IP note = verify |
| `how-to/build-fpga-image` | NEW (Interview5 §10) | build → .ipk → pointer to meta-panda choose-bitstream | writable-now |
| `how-to/finedelay-test` | github.io `how-to/finedelay-test.rst` (183w) | move | writable-now |
| `how-to/local-development` | NEW (pointer to PandABlocks-devcontainer) | link | writable-now |
| `how-to/contribute` | `reference/contributing.rst` → `.github/CONTRIBUTING.md` + `{include}` | →how-to | writable-now |
| `explanations/framework` | `reference/framework.rst` (500w: Softblocks, Wrappers, Config_d entries, Test benches) | →explanation; refresh (outdated) | partial |
| `reference/glossary` | `reference/glossary.rst` → merge into meta-panda canonical | FPGA links to canonical | writable-now |
| `reference/vhdl-standard` | NEW (Interview1 §4) | author | blocked: author |
| `README.md`, `index.md` | FPGA `index.rst` | scaffold | writable-now |
| **DROP** | `reference/changelog.rst` (empty, 3w) → Release-Notes `url:` slot; FPGA + github.io tutorial copies | — | — |

---

## PandABlocks-server

| Target | Source → sections | Action notes | Status |
|---|---|---|---|
| `reference/commands` | `commands.rst` (1984w: Configuration Commands, System Commands) | spine of TCP ref; keep `*IDN?` (unchanged v4.x) | writable-now |
| `reference/fields` | `fields.rst` (2671w: Field Types, Field Sub-Types, Summary of Sub-Types, Summary of Attributes) | keep MODE matrix; point to streaming-tables | writable-now |
| `reference/capture` | `capture.rst` (1460w: Capture Configuration, Data Capture Port ⊃ Capture Options, Data Transport Formatting, Data Header, Experiment Completion, High performance mode, Examples) | keep ~60 MB/s + webcontrol caveat; **link to meta-panda integrate-with-a-panda** for data-out | writable-now; 60MB/s = verify |
| `reference/capture-options` | ⊃ `capture.rst` "Capture Options" + Interview5 §4 superset | "run `*CAPTURE.OPTIONS?` live" note | partial; superset = verify |
| `reference/config` | `config.rst` (1198w: config [Field type/subtype], registers [+ extension syntax], description) | →MyST | writable-now |
| `reference/extension` | `extension.rst` (739w: Extension Modules, Injected Values) | verify vs implementation | blocked: verify |
| `reference/streaming-tables` | NEW (Interview5 §8) | `<<` / `<<|`, buffer sizes | writable-now |
| `reference/support` | `support.rst` (391w: Useful Tools, Panda Status LEDs) | →MyST | writable-now |
| `reference/c-standard` | NEW (Interview1 §4) | author | blocked: author |
| `explanations/architecture` | NEW (server code + docs) | skeleton (TCP/config/data threads, block model); depth later | writable-now (skeleton); depth = blocked: author |
| `how-to/startup` | `startup.rst` (501w: Starting Panda Server) | →how-to | writable-now |
| `how-to/building` | `building.rst` (493w: Dependencies, CONFIG file, Build Targets, Generated Files) | point to devcontainer for local dev | writable-now; CONFIG syntax = verify |
| `how-to/contribute` | NEW + `{include} .github/CONTRIBUTING.md` | →how-to | writable-now |
| `README.md`, `index.md` | server `index.rst` | scaffold | writable-now |
| **DROP** | `presentation-2016-05/*` (building/panda/server); SDK cross-compile path (replaced by meta-panda test-firmware-changes) | — | — |

---

## PandABlocks-rootfs — archive
- `how-to/quickstart.md` → merged into meta-panda `how-to/quickstart` (network setup).
- `how-to/building.md` → retire (whole build guide superseded).
- boot-process already migrated to meta-panda.
- Disable Pages; remove dangling `how-to/remote.md` toctree entries in `index.md`/`how-to.md`; `README` → meta-panda.

## PandABlocks.github.io — redirect (migrate first, then single redirect)
- `explanations/decisions/0001`, `0002-switched-to-pip-skeleton` → meta-panda `explanations/decisions/`.
- `how-to/finedelay-test` → FPGA.
- `how-to/update-tools` + `how-to/contribute` + `reference/standards` → meta-panda `how-to/contribute`.
- `reference/migration_guide` + `reference/release_compatibility` → meta-panda `reference/changes`.
- **Delete (migrated/dupes):** `tutorials/*`, `how-to/make-release`, `how-to/remote`, `how-to/web-interface`, `how-to/run-container`, `reference/genindex`, `how.rst`, `tutorial.rst`.
- Catch-all redirect `pandablocks.github.io/` → `meta-panda/main/index.html`.
