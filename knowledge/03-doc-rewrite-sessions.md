# PandABlocks Docs Rewrite — Interview Sessions

This file splits the 34 owner questions from the gap analysis into **7 self-contained
sessions**. Each session embeds everything a fresh chat needs — the agreed target
architecture, the relevant duplications/gaps, and the questions — so you only ever
copy from here.

## How to use it

1. Start a **new chat** for each session.
2. Copy **everything under that session's "Paste into a fresh chat" heading** (from the
   instruction line down through the last question) and paste it in.
3. Answer one question at a time; you'll get a 2–4 bullet summary after each.
4. At the end of the session you'll get a single Markdown knowledge file for your repo.

## Session order

Structural first, then most user-facing → least user-facing (developer-facing last):

1. Documentation architecture & tutorials *(structural)*
2. Web-control UI docs *(user-facing)*
3. Deploy, upgrade & boot *(user-facing)*
4. Versioning & compatibility *(user-facing / ops)*
5. PandABlocks-server: interface, build & integration *(developer-facing)*
6. Firmware build & release *(developer-facing)*
7. FPGA repo: blocks, build, test & CI *(developer-facing)*

> Q34 from the gap analysis ("is there a single documentation home?") is **already
> resolved** by the target architecture below, so it is not re-asked.

---

## Session 1 — Documentation architecture & tutorials

### Paste into a fresh chat

I'm rewriting the documentation for the PandABlocks org. Work through the questions in
this message **one at a time**: ask a question, wait for my answer, then summarise my
answer in 2–4 bullet points before moving to the next. When all questions are answered,
compile every bullet point into a single Markdown knowledge file I can copy into my repo.

**Target documentation architecture (decided):**

- **meta-panda** — the front door and primary home: tutorials, architecture,
  hardware-target descriptions, web-control UI docs, most user-facing docs, plus
  developer docs for the Yocto firmware build. It assembles the firmware and ships an
  offline copy of the docs inside it, so it holds the majority.
- **PandABlocks-FPGA** — block-specific and target-specific docs; how to build, test and
  upgrade selected firmwares.
- **PandABlocks-server** — the TCP server interface; how to build, test and integrate.
- **PandABlocks-rootfs** — being archived; any still-valid content moves to meta-panda
  (the build has migrated to Yocto).
- **PandABlocks.github.io** — becoming a redirect to meta-panda.

**This session covers:** the front-door/landing structure, where tutorials live,
cross-repo duplication cleanup, contribution/standards pages, and navigation stubs.

**Relevant findings from the gap analysis:**

Duplications:
- Tutorials 1–4 exist in triplicate across FPGA, github.io and meta-panda. Tutorials 3 & 4
  are identical ~40/52-word stubs in all three; Tutorials 1 & 2 are full content
  (648/1167 words) in all three. Only the *status* differs (FPGA's 1 & 2 are outdated;
  github.io and meta-panda are current).
- `webcontrol/index.rst` and `webcontrol/userguide/index.rst` (meta-panda) are
  byte-identical (97 w each), as are the two `contents.rst` toctree files.
- github.io `update-tools.rst` and ADR `0002-switched-to-pip-skeleton.rst` both document
  the python3-pip-skeleton relationship. (github.io is being reduced to a redirect, so
  this likely retires with it.)
- Every repo carries near-identical empty section-wrapper / toctree stubs (`explanations`,
  `how-to`, `reference`, `tutorials`).

Gaps:
- Tutorials 3 (position compare) and 4 (snake scan) are never written; tutorial2's
  conclusion promises position compare "in the next tutorial", but it's never delivered.
- github.io `standards.rst` has a "Code Standards" heading with no body and no
  "Documentation Standards" section, despite the intro promising both.

**Questions:**

1. Tutorials 1–4 currently live in three repos. meta-panda is now the canonical home —
   should the FPGA and github.io copies be deleted, replaced with cross-links/redirects,
   or handled some other way?
2. Tutorials 3 (position compare) and 4 (snake scan) are stubs everywhere. Are they
   planned to be written? (They'll be hosted in meta-panda.)
3. `webcontrol/index.rst` vs `webcontrol/userguide/index.rst` are identical, as are the
   two `contents.rst` files. Which is the intended source, and can the duplicate be
   removed?
4. github.io `standards.rst` has an empty "Code Standards" heading and no "Documentation
   Standards" section. What standards should be documented, and where should they live now
   that github.io redirects to meta-panda — or should the page be dropped?
5. meta-panda `index.rst` simply `.. include::`s `../README.rst`. Now that meta-panda is
   the front door, should `index.rst` have its own landing-page introduction instead of
   including the README?

---

## Session 2 — Web-control UI docs

### Paste into a fresh chat

I'm rewriting the documentation for the PandABlocks org. Work through the questions in
this message **one at a time**: ask a question, wait for my answer, then summarise my
answer in 2–4 bullet points before moving to the next. When all questions are answered,
compile every bullet point into a single Markdown knowledge file I can copy into my repo.

**Target documentation architecture (decided):**

- **meta-panda** — the front door and primary home: tutorials, architecture,
  hardware-target descriptions, web-control UI docs, most user-facing docs, plus
  developer docs for the Yocto firmware build. It ships an offline copy of the docs inside
  the firmware, so it holds the majority.
- **PandABlocks-FPGA** — block- and target-specific docs; build, test, upgrade firmwares.
- **PandABlocks-server** — the TCP server interface; build, test, integrate.
- **PandABlocks-rootfs** — being archived; still-valid content moves to meta-panda.
- **PandABlocks.github.io** — becoming a redirect to meta-panda.

**This session covers:** the web-control / GUI documentation, which is destined for
meta-panda.

**Relevant findings from the gap analysis:**

Gaps:
- `understanding_attribute_state.rst` has `*GET IMAGE*` placeholders (Processing, Update
  Error, Disconnected) and references a "table above" of icons that isn't present.
- `working_with_a_design.rst` has several `*GET SCREENSHOT*` / `*GET SCREENHOST*`
  placeholders (View/Edit, Dropdown List, Text Input, Checkbox) and an unfinished sentence
  in the Text Input section ("shown in the .").
- Webcontrol install/launch is undocumented: the guide explains the GUI but never says how
  to install or start it, nor what host/port to use. Quick-start says
  `http://{malcolm host}/gui/` (e.g. `localhost:3000`); the network/web-admin docs imply
  the PandA's IP on port 80.
- The glossary uses `malcolm`, `pymalcolm`, "MalcolmJS", "Web Control" and "PandABox User
  Interface" interchangeably; the relationship is never explained.

**Questions:**

1. The web-control `quick-start.rst` says to connect at `http://{malcolm host}/gui/`
   (e.g. `localhost:3000`), but `quickstart.rst`/`web-interface.rst` say the web interface
   is reached at the PandA's IP/hostname (implying port 80). What is the correct URL and
   port for reaching the web-control GUI on a real PandA in 2026?
2. `understanding_attribute_state.rst` has `*GET IMAGE*` placeholders (Processing, Update
   Error, Disconnected) and references a missing "table above" of icons. Are the icons /
   table available to drop in?
3. `working_with_a_design.rst` has several `*GET SCREENSHOT*` placeholders and an
   unfinished sentence in the Text Input section. Are the source screenshots available,
   and what was the Text Input sentence meant to say?
4. The glossary uses `malcolm`, `pymalcolm`, "MalcolmJS", "Web Control" and "PandABox User
   Interface" interchangeably. Is the GUI still MalcolmJS/pymalcolm-based, and should the
   docs standardise on one name?

---

## Session 3 — Deploy, upgrade & boot

### Paste into a fresh chat

I'm rewriting the documentation for the PandABlocks org. Work through the questions in
this message **one at a time**: ask a question, wait for my answer, then summarise my
answer in 2–4 bullet points before moving to the next. When all questions are answered,
compile every bullet point into a single Markdown knowledge file I can copy into my repo.

**Target documentation architecture (decided):**

- **meta-panda** — the front door and primary home: tutorials, architecture,
  hardware-target descriptions, web-control UI docs, most user-facing docs, plus
  developer docs for the Yocto firmware build. It ships an offline copy of the docs inside
  the firmware, so it holds the majority.
- **PandABlocks-FPGA** — block- and target-specific docs; build, test, upgrade firmwares.
- **PandABlocks-server** — the TCP server interface; build, test, integrate.
- **PandABlocks-rootfs** — being archived; any still-valid content moves to meta-panda
  (the build has migrated to Yocto).
- **PandABlocks.github.io** — becoming a redirect to meta-panda.

**This session covers:** getting firmware and packages onto a PandA, network/boot
configuration, and the boot process. The user-facing how-to and boot explanation are
destined for meta-panda, which absorbs the rootfs upgrade/SSH material as rootfs is
archived.

**Relevant findings from the gap analysis:**

Duplications:
- `remote.rst` ("Updating a PandA via SSH") in github.io (471 w) and meta-panda (245 w)
  cover the same task (update rootfs, update packages, 24V EEPROM) but diverge on artifact
  names and tooling (zpkg / `boot-x.x.zip` vs opkg / `boot-{MACHINE}.tar.gz`). The
  24V-EEPROM section is near-verbatim in both.
- `web-interface.rst` ("Updating a PandA via web interface") in github.io (329 w) and
  meta-panda (240 w) duplicate the web-admin upgrade procedure, diverging on zpkg vs opkg
  artifacts.
- The `config.txt` network-config block plus "Web Interface" / "Web Admin" sections are
  duplicated between rootfs `quickstart.md` (564 w) and meta-panda `quickstart.rst`
  (817 w); meta-panda adds an FAQ.
- Boot process: a five-stage description appears in both rootfs `building.md`
  ("Boot Process") and meta-panda `boot-process.rst` — same five stages, but rootfs
  describes `imagefile.cpio.gz` + SD repartitioning while meta-panda describes a FIT image
  + `rootfs.squashfs`.
- Package management: rootfs `building.md` (zpkg) vs meta-panda `packages.rst` +
  `reference/opkg.rst` (opkg/ipk) — same concept (USB admin page or scp+CLI;
  list/install/remove/show), different tooling.

Gaps:
- rootfs `index.md` and `how-to.md` describe and toctree-include an "Updating a PandA via
  SSH" guide (`how-to/remote.md`) that does not exist in the rootfs docs.
- EEPROM / 24V FMC tooling: the `write_eeprom` + `ipmi_definition.ini` procedure appears
  in `remote.rst` but has no broader reference for which cards need it or how the
  bitstream-variant selection (IPMI EEPROM) works end to end.
- Pre-2.1 / legacy upgrade path: github.io `web-interface.rst` notes rootfs "< 2.1" needs
  `imagefile.cpio.gz`; meta-panda's version drops this note. Whether legacy upgrades are
  still supported, and where it's documented, is unclear.

**Questions:**

1. Package tooling: github.io `remote.rst`/`web-interface.rst` reference `panda-*.zpg` and
   `zpkg install`, while meta-panda `packages.rst`/`opkg.rst` use `.ipk` and
   `opkg install`. Which is correct for current firmware, and at which release did
   zpkg → opkg happen?
2. `quickstart.rst`'s FAQ says to write a static network config to a file called
   `boot.txt` on the SD card, but the rest of that doc (and rootfs `quickstart.md`) use
   `config.txt` / `panda-config.txt`. Which filename is correct? (`boot.txt` appears
   nowhere else.)
3. rootfs `index.md`/`how-to.md` toctree an "Updating a PandA via SSH" guide
   (`how-to/remote.md`) that doesn't exist. Since rootfs is being archived, should the SSH
   guide be (re)written in meta-panda and the rootfs references removed?
4. The 24V FMC EEPROM update is described as "PandA 3.0 requires…". Is it still required
   for v4.x installs, and is it a one-time migration step or per-install?
5. meta-panda `boot-process.rst` describes a FIT image + `rootfs.squashfs` boot, while
   rootfs `building.md` describes `imagefile.cpio.gz` + SD-card repartitioning. Is the
   cpio.gz/repartition flow fully superseded, and should `building.md`'s "Boot Process"
   section be retired, with the canonical boot explanation living in meta-panda?
6. github.io `web-interface.rst` notes rootfs "< 2.1" needs `imagefile.cpio.gz`;
   meta-panda drops this note. Are pre-2.1 upgrades still supported, and where should that
   be documented?

---

## Session 4 — Versioning & compatibility

### Paste into a fresh chat

I'm rewriting the documentation for the PandABlocks org. Work through the questions in
this message **one at a time**: ask a question, wait for my answer, then summarise my
answer in 2–4 bullet points before moving to the next. When all questions are answered,
compile every bullet point into a single Markdown knowledge file I can copy into my repo.

**Target documentation architecture (decided):**

- **meta-panda** — the front door and primary home: tutorials, architecture,
  hardware-target descriptions, web-control UI docs, most user-facing docs, plus
  developer docs for the Yocto firmware build.
- **PandABlocks-FPGA** — block- and target-specific docs; build, test, upgrade firmwares.
- **PandABlocks-server** — the TCP server interface; build, test, integrate.
- **PandABlocks-rootfs** — being archived; still-valid content moves to meta-panda.
- **PandABlocks.github.io** — becoming a redirect to meta-panda.

**This session covers:** which releases go together, migration between releases, and the
device identification string. This is cross-cutting reference material spanning meta-panda
(compatibility/migration) and the server (the `*IDN?` string).

**Relevant findings from the gap analysis:**

Duplications:
- github.io `migration_guide.rst` and `release_compatibility.rst` both address "which
  versions go together", from different angles.

**Questions:**

1. `migration_guide.rst` only covers 2.0 → 3.0, but `web-interface.rst` already mentions
   "From PandA v4.0". Are 3.0 → 4.0 (and later) migration notes needed, and who maintains
   them?
2. `release_compatibility.rst` stops at rootfs 3.0 / zpkg 3.0. With v4.x and the
   zpkg → opkg switch, what is the current compatibility matrix?
3. `commands.rst` shows `*IDN?` returning `SW: 1.1 … rootfs: PandA 1.1`. Is the
   identification-string format (and the `rootfs:` field introduced in 1.1) unchanged in
   v4.x?

---

## Session 5 — PandABlocks-server: interface, build & integration

### Paste into a fresh chat

I'm rewriting the documentation for the PandABlocks org. Work through the questions in
this message **one at a time**: ask a question, wait for my answer, then summarise my
answer in 2–4 bullet points before moving to the next. When all questions are answered,
compile every bullet point into a single Markdown knowledge file I can copy into my repo.

**Target documentation architecture (decided):**

- **meta-panda** — the front door and primary home: tutorials, architecture,
  hardware-target descriptions, web-control UI docs, most user-facing docs, plus
  developer docs for the Yocto firmware build.
- **PandABlocks-FPGA** — block- and target-specific docs; build, test, upgrade firmwares.
- **PandABlocks-server** — the TCP server interface; how to build, test and integrate.
- **PandABlocks-rootfs** — being archived; still-valid content moves to meta-panda.
- **PandABlocks.github.io** — becoming a redirect to meta-panda.

**This session covers:** the TCP server interface, building/integrating the server,
data-capture semantics, and config paths — all living in the PandABlocks-server repo.
Note: the host SDK used to build the server is produced by the meta-panda Yocto build
(covered in the Firmware build & release session).

**Relevant findings from the gap analysis:**

Duplications:
- Capture-mode table: the pos_out capture options appear in server `capture.rst`, server
  `fields.rst` (pos_out `CAPTURE` attribute) and meta-panda `tutorial2`; the three lists
  don't fully agree.

Gaps:
- No API reference: github.io `genindex.rst` is an empty placeholder and rootfs
  `reference.md` toctrees a `genindex` and "APIs" that don't exist. No authored
  API/interface reference exists anywhere in the current set.
- Host SDK installer: `pandablocks-sdk.rst` says "the sdk installer is also provided to
  use it in the host directly" but never says where to get it or how to run it.
- Streaming tables: server `fields.rst` documents the full `MODE` transition matrix
  (`<<`, `<<|`) but no page explains when or why a client would use streaming vs fixed
  tables.
- Extension server: server `config.rst` and FPGA `block.rst` reference the extension
  mechanism (`extension_read`/`extension_write`, extension `.py` files), but the only
  explainer (`extension.rst`) is marked outdated.

**Questions:**

1. server `building.rst` (CONFIG/make standalone build) vs meta-panda `pandablocks-sdk.rst`
   (Yocto SDK cross-compile): is the standalone build of PandABlocks-server still
   supported, or is the SDK the only sanctioned path?
2. `pandablocks-sdk.rst` says "the sdk installer is also provided to use it in the host
   directly" but gives no instructions. Where is the host installer and what are the steps
   to use it?
3. The `CONFIG` example in `pandablocks-sdk.rst` mixes `KERNEL_DIR=...` (no spaces) with
   `PYTHON = python3` (spaces around `=`). Which syntax does the server Makefile's `CONFIG`
   actually require?
4. Capture options disagree across pages: `capture.rst` lists
   No/Value/Diff/Sum/Mean/Min/Max/Min Max/Min Max Mean; `commands.rst` (`*CAPTURE.OPTIONS?`)
   lists Value/Diff/Sum/Mean/Min/Max/**StdDev** (no Min Max combos); `fields.rst` lists the
   Min Max combos but not Sum or StdDev; tutorial2 omits StdDev. What is the authoritative
   list for current firmware?
5. `capture.rst` states FRAMED RAW mode sustains ~60 MByte/s "when panda-webcontrol is not
   installed". Is this figure still accurate for current hardware/firmware?
6. server `config.rst` says config files load from `/opt/share/panda/config_d` on a PandA.
   With the move to Yocto/opkg, is that path still correct?

> While you're in this repo, three known gaps also belong here and are worth resolving if
> you have the information: the missing API/interface reference, a "streaming vs fixed
> tables" explainer, and the outdated extension-server explainer.

---

## Session 6 — Firmware build & release

### Paste into a fresh chat

I'm rewriting the documentation for the PandABlocks org. Work through the questions in
this message **one at a time**: ask a question, wait for my answer, then summarise my
answer in 2–4 bullet points before moving to the next. When all questions are answered,
compile every bullet point into a single Markdown knowledge file I can copy into my repo.

**Target documentation architecture (decided):**

- **meta-panda** — the front door and primary home: tutorials, architecture,
  hardware-target descriptions, web-control UI docs, most user-facing docs, plus
  **developer docs for the Yocto firmware build** (this session's home). It assembles the
  firmware and ships an offline copy of the docs inside it.
- **PandABlocks-FPGA** — block- and target-specific docs; build, test, upgrade firmwares.
- **PandABlocks-server** — the TCP server interface; build, test, integrate.
- **PandABlocks-rootfs** — being archived; any still-valid content moves to meta-panda
  (the build has migrated to Yocto).
- **PandABlocks.github.io** — becoming a redirect to meta-panda.

**This session covers:** building the firmware image (Yocto/kas), the release artifacts
and process, supported hardware targets, and the version scheme. The developer build docs
live in meta-panda; this session also decides the fate of the rootfs `building.md`.

**Relevant findings from the gap analysis:**

Duplications:
- `make-release.rst` is byte-identical in github.io and meta-panda (97 w); meta-panda's
  copy still links to `github.com/PandABlocks/PandABlocks.github.io/releases`.
- `run-container.rst` is identical in github.io and meta-panda (167 w; same
  REPO_DIR/VIVADO_DIR/BUILD_DIR volume mounts, same "reistry" typo).
- Building the image: three overlapping-but-divergent guides — rootfs `building.md`
  (Diamond rootfs builder + Xilinx SDK + `CONFIG` + zpkg), meta-panda `build.rst`
  (kas/Yocto) and meta-panda `manual-build.rst` (manual Yocto/bitbake).

Gaps:
- Supported MACHINE values: build docs mention `pandabox` (default), `xu5-s1`, `xu5-st1`
  and ZedBoard, but no reference page enumerates the supported targets or their
  differences. (Hardware-target descriptions are slated for the meta-panda front door.)
- kas image version ↔ firmware version: `build.rst` sets `KAS_IMAGE_VERSION="4.8"` with no
  explanation of how this relates to the PandA firmware release a user is trying to build.

**Questions:**

1. rootfs `building.md` describes building via the Diamond rootfs builder + Xilinx SDK +
   `CONFIG` + zpkg, while meta-panda `build.rst` describes kas/Yocto producing opkg/ipk.
   Which is the canonical build path for a new user in 2026, and should `building.md` be
   retired or marked legacy (it lives in the to-be-archived rootfs)?
2. Release artifacts: github.io `remote.rst` says download `boot-x.x.zip` containing
   `imagefile.cpio.gz`/`uImage`; meta-panda `remote.rst` says `boot-{MACHINE}.tar.gz`
   containing `rootfs.squashfs`/`Image`. What is the current release artifact name and
   format?
3. meta-panda `make-release.rst` links to
   `github.com/PandABlocks/PandABlocks.github.io/releases`. Should this point at the
   meta-panda releases page instead (copy-paste leftover)?
4. `manual-build.rst` uses Xilinx's internal `gitenterprise.xilinx.com` manifest on branch
   `rel-v2023.2`. Is that URL reachable by external users; if not, what is the public
   equivalent, and is `rel-v2023.2` still the target branch in 2026?
5. Both `make-release.rst` files instruct maintainers to use PEP440 version numbers and
   GitHub "Generate release notes". Given the firmware version scheme (2.0/3.0/4.0), is
   PEP440 the intended scheme for meta-panda/firmware releases, or only for the python
   (github.io) repo?

> While you're here, two known gaps belong in these build docs and are worth capturing if
> you have the answers: an enumerated reference of supported MACHINE targets and their
> differences, and an explanation of how `KAS_IMAGE_VERSION` maps to the firmware release.

---

## Session 7 — FPGA repo: blocks, build, test & CI

### Paste into a fresh chat

I'm rewriting the documentation for the PandABlocks org. Work through the questions in
this message **one at a time**: ask a question, wait for my answer, then summarise my
answer in 2–4 bullet points before moving to the next. When all questions are answered,
compile every bullet point into a single Markdown knowledge file I can copy into my repo.

**Target documentation architecture (decided):**

- **meta-panda** — the front door and primary home: tutorials, architecture,
  hardware-target descriptions, web-control UI docs, most user-facing docs, plus
  developer docs for the Yocto firmware build.
- **PandABlocks-FPGA** — block-specific and target-specific docs; how to build, test and
  upgrade selected firmwares (this session's home).
- **PandABlocks-server** — the TCP server interface; build, test, integrate.
- **PandABlocks-rootfs** — being archived; still-valid content moves to meta-panda.
- **PandABlocks.github.io** — becoming a redirect to meta-panda.

**This session covers:** block-specific and target-specific docs, the per-block reference,
and FPGA testing/CI — all living in the PandABlocks-FPGA repo.

**Relevant findings from the gap analysis:**

Gaps:
- `block.rst` placeholder sections: "Writing docs" (two RST directives, how to structure),
  "Block VHDL entity" (how to structure the VHDL entity), and "Tables will be defined here
  too" / `table` ("Tables are treated specially") are stubs with no content.
- Per-block reference missing: tutorials and server docs constantly reference PULSE, CLOCK,
  PCAP, COUNTER, SEQ, TTLOUT, ADDER, V2F, etc., but the only block listing (FPGA
  `blocks.rst`) is an outdated generated artifact, and the `modules/*/*_doc.rst` files
  aren't in the inventory. There is no current, authored "what each block does" page.
- V2F block is referenced (with an external paper link) in tutorial2 but is never defined
  or documented.

**Questions:**

1. `block.rst` has empty placeholder sections "Writing docs", "Block VHDL entity", and
   "Tables will be defined here too". Do you have the intended content, or should these be
   removed?
2. FPGA `testing.rst` says the Python tests run "as part of the Travis tests". Is CI still
   Travis (vs GitHub Actions), and is this page current?
3. FPGA `index.rst` routes block authors to `blocks.rst` (outdated, generated) and
   `app.rst` (outdated). Are these being regenerated/rewritten, or should the index point
   somewhere else?
4. `cocotb.rst` says "Modules using IP are currently unsupported" by the cocotb runner. Is
   that still true, and does it block testing any production blocks we should flag?

> Related gaps that belong in this repo and are worth resolving if you can: an authored
> per-block reference ("what each block does", covering PULSE/CLOCK/PCAP/COUNTER/SEQ/etc.),
> and a definition/doc for the V2F block referenced in tutorial2.

---

## Coverage map

Every Section 3 question and every duplication/gap is assigned to exactly one session.

| Session | Section 3 questions | Section 1 duplications | Section 2 gaps |
|---|---|---|---|
| 1 — Architecture & tutorials | 5, 6, 7, 17, 25 | 1, 11, 12, 13, 15 | 1, 6 |
| 2 — Web-control UI | 9, 15, 16, 24 | — | 4, 5, 10, 11 |
| 3 — Deploy, upgrade & boot | 2, 8, 10, 27, 29, 31 | 4, 5, 6, 7, 9 | 3, 17, 18 |
| 4 — Versioning & compatibility | 11, 12, 23 | 14 | — |
| 5 — Server | 13, 19, 20, 21, 22, 30 | 10 | 7, 12, 13, 14 |
| 6 — Firmware build & release | 1, 3, 4, 28, 33 | 2, 3, 8 | 15, 16 |
| 7 — FPGA | 14, 18, 26, 32 | — | 2, 8, 9 |

Q34 is resolved by the agreed architecture and is not asked.
