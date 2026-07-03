# PandABlocks Documentation — Session Decisions

This file records the decisions made while rewriting the PandABlocks org documentation.
Scope of this session: front-door/landing structure, where tutorials live, cross-repo
duplication cleanup, contribution/standards pages, and navigation stubs.

---

## Target documentation architecture (decided previously, for context)

- **meta-panda** — the front door and primary home: tutorials, architecture,
  hardware-target descriptions, web-control UI docs, most user-facing docs, plus
  developer docs for the Yocto firmware build. Assembles the firmware and ships an
  offline copy of the docs, so it holds the majority.
- **PandABlocks-FPGA** — block-specific and target-specific docs; how to build, test and
  upgrade selected firmwares.
- **PandABlocks-server** — the TCP server interface; how to build, test and integrate.
- **PandABlocks-rootfs** — being archived; still-valid content moves to meta-panda (build
  has migrated to Yocto).
- **PandABlocks.github.io** — becoming a redirect to meta-panda.

---

## 1. Tutorials 1–4 — duplication across three repos

- **Delete the FPGA and github.io copies outright.** No per-page cross-links or redirect
  stubs left behind in those repos.
- **meta-panda is the single canonical home** for the tutorials — exactly one home per
  piece of content, no duplicate-and-link arrangements.
- **The only redirect needed is one catch-all** from `pandablocks.github.io/` →
  `meta-panda/main/index.html`; github.io's tutorial copies retire under that catch-all
  rather than getting individual redirects.

## 2. Tutorials 3 (position compare) and 4 (snake scan)

- **Will be written** as part of this documentation task — genuinely planned, not removed.
- **Authoring workflow:** human-generated raw material (screenshots and bullet points)
  first, then AI-expanded into full prose.
- **Hosted in meta-panda** alongside Tutorials 1 & 2; since real content is coming,
  **Tutorial 2's "in the next tutorial" promise stays valid** (no need to edit it out).

## 3. meta-panda structure & web-control duplication

- **meta-panda is organised top-level by Diátaxis** — the four quadrants (tutorials,
  how-to, reference, explanation) as the primary division of the whole repo.
- **Confirmed contents include:** the tutorials (1–4), plus how-to guides for upgrading
  the firmware and for saving/restoring designs via the web UI.
- **The identical duplicates collapse to one** — consistent with the single-canonical-home
  principle; the survivor is resolved by the restructure rather than kept in two places.
- **OPEN DECISION — web-control "user guide" (reference-style) placement:** either
  (a) break it up and scatter the pieces across the four quadrants, or (b) keep it together
  in the reference section with selected sections extracted as how-to guides. Not yet
  settled.

## 4. Standards pages

- **Code Standards split by repo, not centralised:** FPGA gets a VHDL style standard,
  Server gets a C style standard — each lives in its own repo, not in a shared page.
- **Documentation Standards live in meta-panda** (doc-authoring conventions — e.g.
  Diátaxis adherence, markup conventions, the human-draft-then-AI-expand workflow).
- **All three are unwritten and need authoring**; the old github.io `standards.rst` is
  superseded and retires under the catch-all redirect rather than being migrated.

## 5. Landing page & README strategy

- **Every repo gets a top-level `README.md`** introducing the module: what it is, what it
  publishes, how it fits into PandABlocks as a whole, and a pointer back to both its own
  published docs and meta-panda.
- **`index.md` includes that `README.md` *and* generates the four-quadrant TOC** —
  README-plus-quadrants, not a from-scratch landing page that discards the README.
- **README and landing page stay in sync by construction** — the landing page embeds the
  README rather than duplicating it.
- **Format migration:** the entire doc set converts from Sphinx RST to MyST Markdown
  (mystmd) as part of this task.

---

## Derived action list (content to write / changes to make)

- [ ] Delete Tutorials 1–4 from PandABlocks-FPGA and PandABlocks.github.io.
- [ ] Add catch-all redirect `pandablocks.github.io/` → `meta-panda/main/index.html`.
- [ ] Write Tutorial 3 (position compare) and Tutorial 4 (snake scan) in meta-panda
      (human screenshots + bullets → AI expansion).
- [ ] Restructure meta-panda top-level into the four Diátaxis quadrants.
- [ ] Author how-to guides: upgrading firmware; saving/restoring designs via web UI.
- [ ] Collapse the duplicate `webcontrol/index` + `webcontrol/userguide/index` and the two
      `contents` files down to one each.
- [ ] **Decide** web-control user-guide placement (scatter vs keep-in-reference).
- [ ] Write VHDL code standard in PandABlocks-FPGA.
- [ ] Write C code standard in PandABlocks-server.
- [ ] Write Documentation Standards in meta-panda.
- [ ] Add a top-level `README.md` to every repo (module intro, what it publishes, fit
      within PandABlocks, pointers to its own docs + meta-panda).
- [ ] Make each `index.md` include its `README.md` and generate the four-quadrant TOC.
- [ ] Convert the whole doc set from Sphinx RST to MyST Markdown.
