# PandABlocks Docs — Target Map (v4)

Target structure after the rewrite. Merges inventory (01) + interviews (04-1…7) + issue #6,
with decisions D1–D10 and review items R1–R5 applied.

**Conventions**
- How-to titles/slugs use **imperative verb form** (e.g. *monitor*, not *monitoring*).
- Each repo's contribution doc lives at **`.github/CONTRIBUTING.md`**, *included* into `how-to/contribute`.
- Whole set converts **RST → MyST Markdown**; per-block `*_doc.rst` convert **in place under their module**.
- **Cross-repo links via mystmd xref:** meta-panda, FPGA, server and the new devcontainer repo are
  mystmd projects linked by xref (already planned). `PandABlocks-client` and `fastcs-PandABlocks`
  stay Sphinx this round and are reachable via intersphinx.
- Terminology: **"PandA Web Control"** only; never `malcolm`/`pymalcolm`/MalcolmJS in docs.

**Legend** — Disposition: `keep`/`rewrite`/`new`/`move`/`convert`/`delete`/`redirect`/`archive`.
Status: `writable-now` · `blocked: capture` · `blocked: verify` · `blocked: author` · `blocked: tooling`.

---

## meta-panda — canonical front door (top-level Diátaxis)

### Top-level
| Target | Description & audience | Disposition | Source | Status |
|---|---|---|---|---|
| `README.md` | What meta-panda is/publishes, fit in PandABlocks, pointers | new | Interview1 §5 | writable-now |
| `index.md` | Includes README + generates 4-quadrant TOC | rewrite | meta-panda `index.rst` | writable-now |
| `.github/CONTRIBUTING.md` | Contribution process; included into `how-to/contribute` | new | Interview1 §5 | writable-now |

### Tutorials
| Target | Description & audience | Disposition | Source | Status |
|---|---|---|---|---|
| `tutorials/tutorial0_connecting_to_web_control` | Connect to PandA Web Control at PandA IP:80, select root block, make a link; new users | move+rewrite | web-control `quick-start` | writable-now (reuse screenshots) |
| `tutorials/tutorial1_blinking_leds` | Wire PULSE+CLOCK to blink LEDs; new users | rewrite | meta-panda t1 | writable-now |
| `tutorials/tutorial2_position_capture` | PCAP capture modes; new users. Keep "next tutorial" promise | rewrite | meta-panda t2 | writable-now |
| `tutorials/tutorial3_position_compare` | Position compare/trigger pulses; new users | new | human screenshots+bullets → AI | blocked: capture |
| `tutorials/tutorial4_snake_scan` | SEQ table 2D snake scan; new users | new | human screenshots+bullets → AI | blocked: capture |

### How-to
| Target | Description & audience | Disposition | Source | Status |
|---|---|---|---|---|
| `how-to/quickstart` — "How to get a PandA on the network" | First network setup; operators. Fix `boot.txt`→`config.txt`; add `panda-config.txt` USB override | rewrite (merge) | meta-panda + rootfs quickstart | writable-now |
| `how-to/build` — "How to build the PandA image" | kas/Yocto build (canonical); devs. Absorbs KAS-container usage + `KAS_IMAGE_VERSION` explanation | rewrite (merge) | meta-panda `build.rst` + `run-container` (KAS part) | writable-now; KAS_IMAGE_VERSION = blocked: verify |
| `how-to/manual-build` | Manual Yocto/bitbake; devs. Fix manifest URL → `github.com/Xilinx/yocto-manifests`, branch `rel-v2023.2` | move+rewrite | meta-panda `tutorials/manual-build` | writable-now (branch bump post-5.0: verify) |
| `how-to/make-release` | Cut a firmware release; maintainers. Fix releases link → meta-panda | rewrite (de-dupe) | meta-panda `make-release` | writable-now |
| `how-to/packages` | Install IPK/opkg via USB or SSH; admins | rewrite | meta-panda `packages.rst` | writable-now |
| `how-to/upgrade-via-ssh` — "Upgrading a PandA over SSH" | Admins. Covers pre-5.0→5.x AND post-5.0; opkg-based; keep 24V FMC EEPROM (DLS-only, one-time) | rewrite | meta-panda `remote.rst` | writable-now; gap audit = blocked: verify |
| `how-to/upgrade-via-web-admin` — "Upgrading a PandA via the web admin interface" | Operators. + legacy pre-5.0 zpg path + fresh-SD-card install | rewrite | meta-panda `web-interface.rst` | partial; legacy zpg filename = blocked: verify |
| `how-to/use-web-control-to-set-up-a-panda` | Build/edit a design in Web Control: add/remove blocks, link, edit attributes (View/Edit, Dropdown, Text Input, Checkbox widgets); users | move+rewrite (folds attribute-widgets) | web-control `working_with_a_design` | writable-now (reuse screenshots); 4 missing widget screenshots + trailing sentence = blocked: capture |
| `how-to/save-restore-design` | Save/restore designs via Web Control; users | split | web-control `working_with_a_design` | writable-now (reuse screenshots) |
| `how-to/monitor-attribute-values` | View attribute values as live charts/tables; users | move+rewrite | web-control `monitoring_attribute_values` | writable-now (reuse screenshots) |
| `how-to/integrate-with-a-panda` (R1/R4) | Control a PandA programmatically: direct to TCP server, via the Python client (`PandABlocks-client`), or from EPICS/Tango (`fastcs-PandABlocks`). Covers **getting captured data out** (binary → HDF5/numpy); integrators/devs | new | Interview5; client + fastcs repos | writable-now (skeleton + links) |
| `how-to/test-firmware-changes` | devtool/kas → deploy → manual test, + FPGA override; devs | new | Interview5 §1–2 | writable-now |
| `how-to/choose-fpga-bitstream` | `APP` var in config.txt; scp→opkg install→systemctl restart; devs | new | Interview5 §10; Interview3 §4 | writable-now |
| `how-to/contribute` | Doc-authoring conventions (Diátaxis, markup, draft→AI-expand) + includes `.github/CONTRIBUTING.md`; absorbs github.io `update-tools`/`contribute`. Documents the xref/intersphinx link setup; contributors | new | Interview1 §4; github.io tooling | writable-now |

### Reference
| Target | Description & audience | Disposition | Source | Status |
|---|---|---|---|---|
| `reference/opkg` | opkg command quick-ref; admins | keep (→MyST) | meta-panda `opkg.rst` | writable-now |
| `reference/changes` | Breaking changes + migration per major bump, compat matrix embedded per section; admins/devs | new (consolidate) | github.io `migration_guide` + `release_compatibility` | writable-now; 3.0→4.0 = blocked: verify |
| `reference/machine-targets` | MACHINE values table (pandabox/xu5-s1/xu5-st1/zedboard) + links to hardware descriptions | new | Interview6 §A | partial; PandABrick = blocked: verify |
| `reference/glossary` | **Canonical** glossary (web-control + FPGA terms merged); all users | new (merge) | web-control + FPGA glossaries | writable-now |
| `reference/troubleshooting` (R2) | FAQ/troubleshooting: can't-connect, boot failures, "more than one FPGA image satisfied" error, upgrade failures; operators/admins | new | meta-panda `quickstart.rst` "Frequently Asked Questions" section (seed) | writable-now (seed); some entries = blocked: verify |

### Explanation
| Target | Description & audience | Disposition | Source | Status |
|---|---|---|---|---|
| `explanations/boot-process` | FIT image + rootfs.squashfs boot (canonical); devs | keep (→MyST) | meta-panda `boot-process.rst` | writable-now |
| `explanations/architecture` | How repos/firmware fit together; **points out integration options** (TCP / Python client / EPICS+Tango); all audiences | new | Interview1; cross-session pointers; client + fastcs repos | writable-now (skeleton); detail deferrable |
| `explanations/hardware-targets` | Per-target hardware (SoC/module, features); integrators | new | Interview6 §A | blocked: author |
| `explanations/decisions/*` | ADRs migrated from github.io | move | github.io ADRs 0001/0002 | writable-now |
| `explanations/web-control-ui-overview` | Tour of the four UI panels, Layout/Attribute views; users | move+rewrite | web-control `user_interface_overview` | writable-now (reuse screenshots) |
| `explanations/understanding-attribute-state` | What Processing/Update Error/Disconnected mean; users. **Recreate the 3 state icons** (material-ui glyphs, colours per source spec); no malcolm reference in docs | move+rewrite | web-control `understanding_attribute_state`; icon colours from DiamondLightSource/malcolmjs `attributeAlarm.component.js` | writable-now (Claude clones malcolmjs + recreates icons at execution) |

*Removed/absorbed:* duplicate `webcontrol/index`,`webcontrol/userguide/index`,`webcontrol/contents`,`webcontrol/userguide/contents`. `how-to/run-container` removed (KAS part → `how-to/build`; dev-container part → new PandABlocks-devcontainer repo).

---

## PandABlocks-devcontainer — NEW repo (standardised local dev)

| Target | Description & audience | Disposition | Source | Status |
|---|---|---|---|---|
| `README.md` + `index` | What the devcontainer is; how to use it for local dev; devs | new | Interview5 §1; meta-panda `run-container` (non-KAS part) | writable-now |
| `how-to/local-development` | Pull/run the devcontainer for build/test/doc; referenced by FPGA + server. Fix "reistry" typo | move+rewrite | meta-panda `run-container` | writable-now |

---

## PandABlocks-FPGA — block/target/CI docs

| Quadrant | Target | Description & audience | Disposition | Source | Status |
|---|---|---|---|---|---|
| — | `README.md` + `index` + `.github/CONTRIBUTING.md` | Module intro + 4-quadrant TOC + contribution doc | new/rewrite | Interview1 §5; FPGA `index.rst` | writable-now |
| Reference | `reference/blocks` | Autogenerated block listing; devs. Regenerate to consume md module docs | keep (regen) | FPGA `blocks.rst` | blocked: tooling (MyST gen) |
| Reference | `modules/*/*_doc.md` (×42) | Per-block docs (PULSE/CLOCK/PCAP/SEQ/COUNTER/LUT/…); live **under their module**; devs/users | convert (in place) | 42 `modules/*/*_doc.rst` | writable-now (mechanical RST→MD) |
| Reference | `reference/glossary` | Link to meta-panda canonical glossary | merge | FPGA `glossary.rst` | writable-now |
| Reference | `reference/vhdl-standard` | VHDL style standard; contributors | new | Interview1 §4 | blocked: author |
| How-to | `how-to/app` | Assemble blocks into an app (ini, build, query); app devs | rewrite (outdated) | FPGA `app.rst` | writable-now (verify runtime steps) |
| How-to | `how-to/block` | Writing a block; FPGA devs. Fill "Block VHDL entity" (LUT example); drop tables stub; defer "Writing docs" until MyST. **Not split** | rewrite | FPGA `block.rst` | partial; "Writing docs" = blocked: tooling |
| How-to | `how-to/testing` | Run test suites; devs. Travis → GitHub Actions (sim) + DLS GitLab (build) | rewrite | FPGA `testing.rst` | blocked: verify (maintainer) |
| How-to | `how-to/cocotb` | cocotb timing tests; devs. Keep "modules using IP unsupported" | rewrite | FPGA `cocotb.rst` | writable-now; IP assumption = blocked: verify |
| How-to | `how-to/build-fpga-image` | Build an FPGA image → .ipk → pointer to choose-bitstream (meta-panda); devs | new | Interview5 §10 | writable-now |
| How-to | `how-to/finedelay-test` | Fine-delay LVDSOUT test; hardware engineers | move | github.io `finedelay-test` (current) | writable-now |
| How-to | `how-to/local-development` | Pointer to PandABlocks-devcontainer; devs | new (link) | devcontainer repo | writable-now |
| How-to | `how-to/contribute` | Includes `.github/CONTRIBUTING.md`; contributors | rewrite | FPGA `contributing.rst` | writable-now |
| Explanation | `explanations/framework` | Autogeneration framework architecture; core devs | move+rewrite | FPGA `framework.rst` (outdated) | partial; needs refresh |

*Glossary:* FPGA `glossary.rst` merges into meta-panda canonical glossary; FPGA links to it.

---

## PandABlocks-server — TCP interface

| Quadrant | Target | Description & audience | Disposition | Source | Status |
|---|---|---|---|---|---|
| — | `README.md` + `index` + `.github/CONTRIBUTING.md` | Module intro + 4-quadrant TOC + contribution doc | new/rewrite | Interview1 §5; server `index.rst` | writable-now |
| Reference | `reference/commands` | ASCII command interface (spine of TCP ref); client devs. Includes `*IDN?` (unchanged v4.x; rootfs: field) | rewrite | server `commands.rst` | writable-now |
| Reference | `reference/fields` | Field types/attributes; client devs. Point to streaming-tables; keep MODE matrix | rewrite | server `fields.rst` | writable-now |
| Reference | `reference/capture` | Data-capture protocol/wire format; client devs. Keep ~60 MB/s + webcontrol caveat. **Link to meta-panda `how-to/integrate-with-a-panda`** for getting data out (R4) | rewrite | server `capture.rst` | writable-now (60MB/s = verify) |
| Reference | `reference/capture-options` | Canonical superset of capture options + "run `*CAPTURE.OPTIONS?` live" note | new | Interview5 §4 | partial; superset = blocked: verify |
| Reference | `reference/config` | config/registers/description files; firmware devs. config_d path OK | rewrite | server `config.rst` | writable-now |
| Reference | `reference/extension` | Extension server; extension devs | rewrite | server `extension.rst` (outdated) | blocked: verify |
| Reference | `reference/streaming-tables` | `<<`/`<<|` streaming for DMA tables, buffer sizes; client devs | new | Interview5 §8 | writable-now |
| Reference | `reference/support` | Supporting tools/LEDs; operators | rewrite | server `support.rst` | writable-now |
| Reference | `reference/c-standard` | C style standard; contributors | new | Interview1 §4 | blocked: author |
| Explanation | `explanations/architecture` | How the server is structured internally (TCP/config/data threads, block model); core devs | new | server code + docs | writable-now (skeleton); depth = blocked: author |
| How-to | `how-to/startup` | CLI args to start server; admins | rewrite | server `startup.rst` | writable-now |
| How-to | `how-to/building` | Build/test server (native sim-mode; make+gcc); devs. Point to PandABlocks-devcontainer for local dev | rewrite | server `building.rst` | writable-now; CONFIG syntax = blocked: verify |
| How-to | `how-to/contribute` | Includes `.github/CONTRIBUTING.md`; contributors | new | — | writable-now |

*Removed:* SDK cross-compile path (`pandablocks-sdk.rst` + "sdk installer in host" line) → replaced by meta-panda `how-to/test-firmware-changes`. `presentation-2016-05/*` → drop. `genindex` placeholders → drop.

---

## PandABlocks-rootfs — ARCHIVE
| Action | Detail |
|---|---|
| Disable Pages | Stop publishing rootfs docs |
| Migrate out | boot-process (done), quickstart (→ meta-panda merge), valid bits only |
| Retire | `building.md` (whole build guide), zpkg content |
| Fix dangling refs | Remove `how-to/remote.md` toctree entries in `index.md`/`how-to.md` |
| Keep | `README` pointing to meta-panda |

## PandABlocks.github.io — REDIRECT
| Action | Detail |
|---|---|
| Catch-all redirect | `pandablocks.github.io/` → `meta-panda/main/index.html` (single redirect) |
| Delete (migrated) | tutorials 1–4, `make-release`, `run-container`, `remote`, `web-interface`, `migration_guide`, `release_compatibility`, `standards`, `genindex` |
| Migrate first | ADRs `decisions/*` → meta-panda; `finedelay-test` → FPGA; `update-tools`/`contribute` → meta-panda `how-to/contribute` |

---

## Review items R1–R5 (resolved)
- **R1** Integration/client pointers → `how-to/integrate-with-a-panda` (TCP / Python client / EPICS+Tango via `fastcs-PandABlocks`, **not** the archived `PandABlocks-ioc`); linked from `explanations/architecture`.
- **R2** Troubleshooting → `reference/troubleshooting`, seeded from the quickstart FAQ.
- **R3** Cross-repo links → mystmd xref across the 3 core repos + devcontainer (already planned); `PandABlocks-client`/`fastcs-PandABlocks` reachable via intersphinx this round.
- **R4** Getting data out → folded into R1; cross-linked from server `reference/capture`.
- **R5** Versioned docs / version switcher → **GitHub issue** (infrastructure; not authored this round).

---

## Issue backlog (for GitHub issues, scoped ~few hours each)

**Human-capture:** Tutorial 3 screenshots+bullets · Tutorial 4 screenshots+bullets · web-control widget screenshots (View/Edit, Dropdown, Text Input, Checkbox) + finish trailing sentence.

**Verify-then-write:** 3.0→4.0 breaking changes · capture-options superset · extension server vs implementation · `*IDN?` v4.x · 60 MB/s figure · cocotb IP assumption · CONFIG syntax · PandABrick target · `KAS_IMAGE_VERSION` mapping · legacy updater zpg filename · testing.rst CI · Xilinx branch bump post-5.0.

**Author-from-scratch:** VHDL standard · C standard · hardware-target descriptions · server architecture (depth).

**Infrastructure:** versioned docs / version switcher (R5).
