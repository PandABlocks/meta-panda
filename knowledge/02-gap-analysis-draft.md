# Documentation Gap Analysis (Draft)

Scope: based on `knowledge/01-inventory.md` and a full read of every doc file
marked **current** or **partial** across the five repos (PandABlocks-FPGA,
PandABlocks-server, PandABlocks-rootfs, PandABlocks.github.io, meta-panda).
Files marked *outdated* were not re-read and are referenced only where a current
page points at them.

---

## Section 1 — Duplications

Pages (or large sections) that cover the same topic in more than one place.

1. **Tutorials 1–4 exist in triplicate.** `tutorials/tutorial1_blinking_leds`,
   `tutorial2_position_capture`, `tutorial3_position_compare`,
   `tutorial4_snake_scan` are present in **PandABlocks-FPGA**,
   **PandABlocks.github.io**, and **meta-panda**. Tutorials 3 and 4 are the same
   ~40/52-word stub in all three repos (identical wording). Tutorials 1 and 2
   are the same 648/1167-word content in all three. Only the *status* differs
   (FPGA's 1 & 2 are marked outdated; github.io and meta-panda are current).

2. **"Make a release"** — `how-to/make-release.rst` is byte-for-byte identical
   in **PandABlocks.github.io** and **meta-panda** (both 97 words). Notably
   meta-panda's copy still links to
   `github.com/PandABlocks/PandABlocks.github.io/releases` (see Q4).

3. **"Run in a container"** — `how-to/run-container.rst` is identical in
   **PandABlocks.github.io** and **meta-panda** (both 167 words, same REPO_DIR /
   VIVADO_DIR / BUILD_DIR volume-mount instructions, same "reistry" typo).

4. **"Updating a PandA via SSH"** — `how-to/remote.rst` in
   **PandABlocks.github.io** (471 w) and **meta-panda** (245 w) cover the same
   task (update rootfs, update packages, 24V EEPROM). They diverge on artifact
   names and package tooling (zpkg/`boot-x.x.zip` vs opkg/`boot-{MACHINE}.tar.gz`).
   The 24V-EEPROM section is duplicated almost verbatim between them.

5. **"Updating a PandA via web interface"** — `how-to/web-interface.rst` in
   **PandABlocks.github.io** (329 w) and **meta-panda** (240 w) duplicate the
   same web-admin upgrade procedure, again diverging on zpkg vs opkg artifacts.

6. **"Getting a PandA on the network" / quickstart** — the `config.txt`
   network-configuration block, "Web Interface", and "Web Admin" sections are
   duplicated between **PandABlocks-rootfs** `how-to/quickstart.md` (564 w) and
   **meta-panda** `how-to/quickstart.rst` (817 w). meta-panda adds an FAQ
   section; otherwise the shared content is near-identical.

7. **Boot process** — the five-stage boot description appears in both
   **PandABlocks-rootfs** `how-to/building.md` ("Boot Process" section) and
   **meta-panda** `explanations/boot-process.rst`. Same five stages, but rootfs
   describes `imagefile.cpio.gz` + SD repartitioning while meta-panda describes a
   FIT image + `rootfs.squashfs`.

8. **Building the image** — two overlapping-but-divergent build guides:
   **PandABlocks-rootfs** `how-to/building.md` (Diamond rootfs builder + Xilinx
   SDK + `CONFIG` + zpkg) vs **meta-panda** `how-to/build.rst` (kas/Yocto) and
   **meta-panda** `tutorials/manual-build.rst` (manual Yocto/bitbake). Three
   documents answer "how do I build the PandA image?" with different toolchains.

9. **Package management** — **PandABlocks-rootfs** `how-to/building.md`
   ("Installing zpkg Files" + "zpkg Command") vs **meta-panda**
   `how-to/packages.rst` + `reference/opkg.rst`. Same concept (install via USB
   admin page or scp+CLI; list/install/remove/show commands), zpkg vs opkg/ipk.

10. **Capture-mode table** — the pos_out capture options
    (No/Value/Diff/Sum/Mean/Min/Max/Min Max/Min Max Mean) appear three times:
    **PandABlocks-server** `docs/capture.rst`, **PandABlocks-server**
    `docs/fields.rst` (pos_out `CAPTURE` attribute), and **meta-panda**
    `tutorials/tutorial2_position_capture.rst`. The three lists do not fully
    agree (see Q21).

11. **Webcontrol "Introduction"** — `webcontrol/index.rst` and
    `webcontrol/userguide/index.rst` (both in meta-panda) are byte-for-byte
    identical (97 w each).

12. **Webcontrol "Contents"** — `webcontrol/contents.rst` and
    `webcontrol/userguide/contents.rst` (both meta-panda) are byte-for-byte
    identical toctree pages.

13. **pip-skeleton / tooling** — **PandABlocks.github.io**
    `how-to/update-tools.rst` and ADR `0002-switched-to-pip-skeleton.rst` both
    document the python3-pip-skeleton relationship.

14. **Version/compatibility** — **PandABlocks.github.io**
    `reference/migration_guide.rst` and `reference/release_compatibility.rst`
    both address "which versions go together", from different angles.

15. **Navigation toctree stubs** — every repo carries near-identical empty
    section wrappers: `explanations(.rst/.md)`, `how-to(.rst/.md)` / `how.rst`,
    `reference(.rst/.md)`, `tutorials(.rst/.md)` / `tutorial.rst`. rootfs,
    github.io and meta-panda each have their own set with the same boilerplate.

---

## Section 2 — Apparent gaps

Topics referenced but never fully documented (in the current/partial set).

1. **Tutorials 3 & 4 are never written.** Both are intro-paragraph stubs in all
   three repos. tutorial2's conclusion explicitly promises "In the next tutorial
   we will read about how to use position compare…", but position compare and
   snake scan are never delivered.

2. **`block.rst` placeholder sections.** "Writing docs" ("Two RST directives,
   how to structure"), "Block VHDL entity" ("How to structure the VHDL entity"),
   and "Tables will be defined here too" / `table` ("Tables are treated
   specially") are stubs with no real content.

3. **rootfs SSH-update guide is missing but linked.** `index.md` and `how-to.md`
   in **PandABlocks-rootfs** describe and toctree-include an "Updating a PandA
   via SSH" guide (`how-to/remote.md`), but no `remote.md` exists in the rootfs
   docs — only `building.md` and `quickstart.md` do.

4. **Webcontrol attribute-state icons missing.** `understanding_attribute_state.rst`
   has `*GET IMAGE*` placeholders for Processing, Update Error, and Disconnected
   states, and references a "table above" of icons that is not present on the
   page.

5. **Webcontrol design screenshots missing.** `working_with_a_design.rst` has
   several `*GET SCREENSHOT*` / `*GET SCREENHOST*` placeholders (View/Edit,
   Dropdown List, Text Input, Checkbox) and an unfinished sentence in the Text
   Input section ("shown in the .").

6. **Standards undocumented.** github.io `reference/standards.rst` has a "Code
   Standards" heading with no body and no "Documentation Standards" section,
   despite the intro promising both.

7. **No API reference.** github.io `reference/genindex.rst` is an empty
   placeholder, and rootfs `reference.md` toctrees a `genindex` and "APIs" that
   do not exist. No actual API documentation is present anywhere in the set.

8. **Per-block reference missing from the inventoried set.** Tutorials and
   server docs constantly reference PULSE, CLOCK, PCAP, COUNTER, SEQ, TTLOUT,
   ADDER, V2F, etc., but the only block listing (FPGA `blocks.rst`) is an
   outdated generated artifact, and the `modules/*/*_doc.rst` files are not part
   of the inventory. There is no current, authored "what each block does" page.

9. **V2F block** is referenced (with an external paper link) in tutorial2 but is
   never defined or documented.

10. **Webcontrol install/launch is undocumented.** The webcontrol guide explains
    the GUI thoroughly but never says how to install or start the webcontrol /
    Malcolm server, nor what host/port to use (quick-start says
    `http://{malcolm host}/gui/`, e.g. `localhost:3000`; the network/web-admin
    docs imply the PandA's IP on port 80). See Q9.

11. **Malcolm ↔ webcontrol relationship.** The glossary references `malcolm`,
    `pymalcolm`, "MalcolmJS", "Web Control" and "PandABox User Interface"
    interchangeably; the relationship between these is never explained.

12. **Host SDK installer.** `pandablocks-sdk.rst` states "the sdk installer is
    also provided to use it in the host directly" but never says where to get it
    or how to run it.

13. **Streaming tables.** server `fields.rst` documents the full `MODE`
    transition matrix for streaming tables (`<<`, `<<|`) but no page explains
    when or why a client would use streaming vs fixed tables.

14. **Extension server.** server `config.rst` and FPGA `block.rst` reference the
    extension mechanism (`:ref:`extension``, `extension_read`/`extension_write`,
    extension `.py` files), but the only explainer (`extension.rst`) is marked
    outdated.

15. **Supported MACHINE values.** Build docs mention `pandabox` (default),
    `xu5-s1`, `xu5-st1`, and ZedBoard, but no reference page enumerates the
    supported targets or their differences.

16. **kas image version ↔ firmware version.** `build.rst` sets
    `KAS_IMAGE_VERSION="4.8"` with no explanation of how this relates to the
    PandA firmware release a user is trying to build.

17. **EEPROM / 24V FMC tooling.** The `write_eeprom` + `ipmi_definition.ini`
    procedure appears in remote.rst but has no broader reference for which cards
    need it or how the bitstream-variant selection (IPMI EEPROM) works end to end.

18. **Pre-2.1 / legacy upgrade path.** github.io web-interface.rst carries a note
    about rootfs "< 2.1" needing `imagefile.cpio.gz`; meta-panda's version drops
    it. Whether legacy upgrades are still supported, and where that's documented,
    is unclear.

---

## Section 3 — Questions for the owner

Numbered, specific. Cap is 50; there are 34 below.

1. The rootfs `building.md` describes building via the Diamond rootfs builder +
   Xilinx SDK + `CONFIG` + zpkg, while meta-panda `build.rst` describes building
   via kas/Yocto producing opkg/ipk packages. Which is the canonical build path
   for a new user in 2026, and is `building.md` now obsolete (should it be
   retired or marked legacy)?

2. Package tooling: github.io `remote.rst`/`web-interface.rst` still reference
   `panda-*.zpg` and `zpkg install`, while meta-panda `packages.rst`/`opkg.rst`
   use `.ipk` and `opkg install`. Which is correct for current firmware, and at
   which release did zpkg → opkg happen?

3. Release artifacts: github.io `remote.rst` says download `boot-x.x.zip`
   containing `imagefile.cpio.gz`/`uImage`; meta-panda `remote.rst` says
   `boot-{MACHINE}.tar.gz` containing `rootfs.squashfs`/`Image`. What is the
   current release artifact name and format?

4. meta-panda `how-to/make-release.rst` links to
   `github.com/PandABlocks/PandABlocks.github.io/releases`. Should this point at
   the meta-panda releases page instead (copy-paste leftover)?

5. Tutorials 1–4 exist in three repos (FPGA, github.io, meta-panda). Which repo
   is meant to be the canonical home, and should the other copies be deleted or
   replaced with cross-links?

6. Tutorials 3 (position compare) and 4 (snake scan) are stubs everywhere. Are
   these planned to be written, and which repo should host the finished versions?

7. `webcontrol/index.rst` and `webcontrol/userguide/index.rst` are identical, as
   are the two `contents.rst` files. Which is the intended source, and can the
   duplicate be removed?

8. quickstart.rst's FAQ says to write a static network config to a file called
   `boot.txt` on the SD card, but the rest of that doc (and rootfs
   `quickstart.md`) uses `config.txt` / `panda-config.txt`. Which filename is
   correct? (`boot.txt` is mentioned nowhere else.)

9. The webcontrol `quick-start.rst` says to connect at `http://{malcolm host}/gui/`
   e.g. `localhost:3000`, but `quickstart.rst`/`web-interface.rst` say the web
   interface is reached at the PandA's IP/hostname (implying port 80). What is
   the correct URL and port for reaching the webcontrol GUI on a real PandA in
   2026?

10. rootfs `index.md` and `how-to.md` describe and toctree-include an "Updating a
    PandA via SSH" guide (`how-to/remote.md`), but that file does not exist in
    the rootfs docs. Should it be created, or should the references be removed
    because the SSH guide now lives only in github.io/meta-panda?

11. `migration_guide.rst` only covers 2.0 → 3.0, but `web-interface.rst` already
    mentions "From PandA v4.0". Are 3.0 → 4.0 (and later) migration notes needed,
    and who maintains them?

12. `release_compatibility.rst` stops at rootfs 3.0 / zpkg 3.0. With v4.x and the
    zpkg → opkg switch, what is the current compatibility matrix?

13. server `building.rst` (CONFIG/make standalone build) vs meta-panda
    `pandablocks-sdk.rst` (Yocto SDK cross-compile): is the standalone build of
    PandABlocks-server still supported, or is the SDK the only sanctioned path?

14. `block.rst` has empty placeholder sections "Writing docs", "Block VHDL
    entity", and "Tables will be defined here too". Do you have the intended
    content, or should these be removed?

15. `understanding_attribute_state.rst` has `*GET IMAGE*` placeholders
    (Processing, Update Error, Disconnected) and references a "table above" that
    isn't present. Are the missing icons / table available to drop in?

16. `working_with_a_design.rst` has several `*GET SCREENSHOT*` placeholders and
    an unfinished sentence in the Text Input section. Are the source screenshots
    available, and what was the Text Input sentence meant to say?

17. github.io `standards.rst` has a "Code Standards" heading with no body and no
    "Documentation Standards" section. What standards should be documented here,
    or should the page be dropped?

18. FPGA `testing.rst` says the Python tests run "as part of the Travis tests".
    Is CI still Travis (vs GitHub Actions), and is this page current?

19. `pandablocks-sdk.rst` says "the sdk installer is also provided to use it in
    the host directly" but gives no instructions. Where is the host installer and
    what are the steps to use it?

20. The `CONFIG` example in `pandablocks-sdk.rst` mixes `KERNEL_DIR=...` (no
    spaces) with `PYTHON = python3` (spaces around `=`). Which syntax does the
    server Makefile's `CONFIG` actually require?

21. Capture options disagree across three pages: `capture.rst` lists
    No/Value/Diff/Sum/Mean/Min/Max/Min Max/Min Max Mean; `commands.rst`
    (`*CAPTURE.OPTIONS?`) lists Value/Diff/Sum/Mean/Min/Max/**StdDev** (no Min Max
    combos); `fields.rst` lists the Min Max combos but not Sum or StdDev;
    tutorial2 omits StdDev. What is the authoritative list for current firmware?

22. `capture.rst` states FRAMED RAW mode sustains ~60 MByte/s "when
    panda-webcontrol is not installed". Is this figure still accurate for current
    hardware/firmware?

23. `commands.rst` shows `*IDN?` returning `SW: 1.1 … rootfs: PandA 1.1`. Is the
    identification string format (and the `rootfs:` field introduced in 1.1)
    unchanged in v4.x?

24. The webcontrol glossary uses `malcolm`, `pymalcolm`, "MalcolmJS", "Web
    Control" and "PandABox User Interface" interchangeably. Is the GUI still
    MalcolmJS/pymalcolm-based, and should the docs standardise on one name?

25. meta-panda `index.rst` simply `.. include::`s `../README.rst`. Does the
    README hold the intended landing-page content, or should index.rst have its
    own introduction?

26. FPGA `index.rst` routes block authors to `blocks.rst` (outdated, generated)
    and `app.rst` (outdated). Are these being regenerated/rewritten, or should
    the index point somewhere else?

27. The 24V FMC EEPROM update is described as "PandA 3.0 requires…". Is it still
    required for v4.x installs, and is it a one-time migration step or per-install?

28. `manual-build.rst` uses Xilinx's internal `gitenterprise.xilinx.com` manifest
    on branch `rel-v2023.2`. Is that URL reachable by external users; if not,
    what is the public equivalent (and is `rel-v2023.2` still the target branch
    in 2026)?

29. meta-panda `boot-process.rst` describes a FIT image + `rootfs.squashfs`
    boot, while rootfs `building.md` describes `imagefile.cpio.gz` + SD-card
    repartitioning. Is the cpio.gz/repartition flow fully superseded; should
    building.md's "Boot Process" section be retired?

30. server `config.rst` says config files load from `/opt/share/panda/config_d`
    on a PandA. With the move to Yocto/opkg, is that path still correct?

31. github.io `web-interface.rst` notes that rootfs "< 2.1" needs
    `imagefile.cpio.gz`; meta-panda's version drops this note. Are pre-2.1
    upgrades still supported, and where is that documented now?

32. `cocotb.rst` says "Modules using IP are currently unsupported" by the cocotb
    runner. Is that still true, and does it block testing any production blocks
    we should flag?

33. Both `make-release.rst` files instruct maintainers to use PEP440 version
    numbers and GitHub "Generate release notes". Given the firmware version
    scheme (2.0/3.0/4.0), is PEP440 actually the intended scheme for
    meta-panda/firmware releases, or only for the python (github.io) repo?

34. Is there an intended single "documentation home" across the five repos
    (e.g. PandABlocks.github.io aggregating the others), or should each repo's
    docs remain standalone? This determines whether the duplications in Section 1
    should be consolidated or deliberately mirrored.
