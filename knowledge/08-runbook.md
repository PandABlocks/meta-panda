# PandABlocks Docs Rewrite — Runbook & Claude Code Prompts (human-facing)

This is the only operational file you drive from. Everything else in `meta-panda/knowledge/` is
reference material that the prompts below point Claude Code at — you never edit it by hand.

## File roles
**You act on:** this file, `07-handoff-guide.md`, and the issue backlog in `03`.
**Claude Code reads (in `meta-panda/knowledge/`):** `03`, `05`, `06` (primary); `01`, `02`,
`04-interview-*` (background); `PROGRESS-template.md`; `docs-skeleton/` (extracted `docs.zip`).

In every prompt below, `/workspaces/meta-panda/knowledge` = the absolute path of `meta-panda/knowledge`
(e.g. `~/src/meta-panda/knowledge`). Set it once; it's reachable from every repo's session because
it's a sibling checkout (or symlink `knowledge/` into each repo if you prefer).

---

## One-time setup (you)
1. Create the `docs` branch in `meta-panda`, `PandABlocks-FPGA`, `PandABlocks-server`. *(Superseded 2026-06: no separate PandABlocks-devcontainer repo — each repo carries its own `.devcontainer/` + Dockerfile.)*
2. Put all knowledge files in `meta-panda/knowledge/`; extract `docs.zip` to `meta-panda/knowledge/docs-skeleton/`.
3. Have a GitHub PAT ready (scopes: repo, issues) for Stage B; authenticate `gh` in that terminal.
4. Two decisions are yours (not blockers): confirm whether all **8** attribute-state icons need distinct glyphs or some collapse; and (optional) whether you have a preference on the FPGA module-docs surfacing or the xref keys, else let CC prototype and report.

## How to run across 5-hour windows
Sequential, one session per task, `/clear` between tasks, `/model` to switch. Suggested window plan:
- **Window 1:** Stage A scaffold (Prompt A) for all four repos. Opus-heavy; review the four scaffold PRs at the end.
- **Window 2–3:** Bulk conversion (Prompt D) repo by repo on Sonnet; drop in hard files (Prompt E) on Opus as budget allows. Run Stage B (Prompt B) as a short Sonnet burst once stubs exist.
- **Last window:** Icons (Prompt C) and final verification (Prompt F) on Opus.
End every window at a clean committed state on a whole quadrant or repo.

Budget tip: Prompt A can be split — do steps 1–3,5,6 on **Sonnet** (mechanical), then steps 4 + the
FPGA modules prototype on **Opus**. That stretches the Opus budget.

---

## PROMPT A — Stage A scaffold  ·  model: Opus (or split, see tip)  ·  run from each repo root on `docs`
```
You are scaffolding the documentation for this repository as part of a multi-repo docs rewrite. Work only on the `docs` branch.

Read first: /workspaces/meta-panda/knowledge/05-stage-a-scaffolding-spec.md (how to scaffold), /workspaces/meta-panda/knowledge/03-target-doc-map.md (this repo's target pages), and the corrections at the top of /workspaces/meta-panda/knowledge/06-source-provenance-map.md (apply them). The mystmd skeleton to instantiate is /workspaces/meta-panda/knowledge/docs-skeleton/.

Following 05 exactly:
1. Instantiate the skeleton into docs/ as a one-off (not copier-managed). Keep every structural element byte-for-byte; swap only title / github / github_url / logo.
2. Delete reference/api.md, reference/api.json, the apidoc plugins block, tutorials/installation.md; for core repos delete how-to/run-container.md.
3. Build project.toc and the index.md card targets from this repo's section in 03/06. Create EVERY target page as a valid TODO stub: title + a MyST admonition carrying the page's `status` and a `Source:` line from 06 (link an issue placeholder if blocked).
4. Add the xref `references:` block naming the other core repos + devcontainer, and intersphinx entries for PandABlocks-client and fastcs-PandABlocks. Prove a cross-link resolves in the BUILT output.
5. Copy /workspaces/meta-panda/knowledge/PROGRESS-template.md to docs/PROGRESS.md, set the repo name, tick Stage-A items as you go.
6. Run `myst build` until green; commit after each step; open a PR from `docs` titled "docs: Stage A scaffold".

FPGA ONLY: also resolve per-block-docs surfacing — prototype BOTH (a) symlink modules/ into docs/ and (b) an out-of-tree TOC reference to ../modules/*/*_doc.md — pick whichever builds clean with the files staying physically under modules/, and record the choice in PROGRESS.md.

Gate: green `myst build`, every target page present as a stub, xref probe resolves. Stop and report BEFORE converting any real content.
```

## PROMPT B — GitHub issues  ·  model: Sonnet  ·  run from meta-panda with `gh` authenticated (PAT)
```
Create GitHub issues for the docs-rewrite backlog. The backlog is the "Issue backlog" section of /workspaces/meta-panda/knowledge/03-target-doc-map.md (Human-capture, Verify-then-write, Author-from-scratch, Infrastructure).

For each item: create one issue in the relevant PandABlocks/<repo>, titled clearly; body states the target page it blocks (look it up in /workspaces/meta-panda/knowledge/06-source-provenance-map.md), the category, and exactly what a human must do (treat each as a few hours of work). Group closely related items by knowledge area. Label `docs-rewrite` + the category. Use the `gh` CLI.
Then write each issue number into that repo's docs/PROGRESS.md "Blocked" section and into the matching stub page's admonition, and commit those edits on `docs`. List the issues created at the end.
```

## PROMPT C — Recreate attribute-state icons  ·  model: Opus  ·  run from meta-panda on `docs`
```
Recreate the attribute-state icons for explanations/understanding-attribute-state. Clone DiamondLightSource/malcolmjs and read the colour/glyph spec in attributeAlarm.component.js. There are EIGHT states: Normal, Processing, Locally Edited, Update Error, Warning, Error, Invalid, Disconnected (see /workspaces/meta-panda/knowledge/06-source-provenance-map.md).
Recreate each as a small standalone SVG (material-style glyph in the spec colour) under docs/images/attribute-state/, and wire them into the understanding-attribute-state page. Do NOT mention malcolm or MalcolmJS anywhere in the docs — the repo is only the source of the colours. `myst build` green; commit on `docs`.
```

## PROMPT D — Bulk conversion  ·  model: Sonnet  ·  run per repo, once per quadrant, on `docs`
```
Convert the {QUADRANT} pages for this repo from RST to MyST Markdown, on the `docs` branch.
For each page in this repo's {QUADRANT} section of /workspaces/meta-panda/knowledge/06-source-provenance-map.md: read the cited source file and sections, convert/merge/split exactly as the row says, apply every listed fix (URL corrections, boot.txt->config.txt, title changes, etc.), and replace the stub.
SKIP these own-task files (done separately on Opus): working_with_a_design, fields, commands, capture, block.
SKIP any page marked blocked:* — leave its stub and ensure its issue is linked.
Reuse existing screenshots/assets in place.
After each file: `myst build`, then commit the file together with its docs/PROGRESS.md line. Report done/skipped at the end.

(FPGA reference quadrant only: the 42 modules/*/*_doc.rst conversions are independent and identical in shape — you may fan them out to sub-agents, one batch each, but YOU commit the results sequentially.)
```

## PROMPT E — Hard files  ·  model: Opus  ·  one session each, on `docs`
Run once per file, pasting the matching SPECIFICS line:
```
Convert {FILE} on the `docs` branch, following its row in /workspaces/meta-panda/knowledge/06-source-provenance-map.md and the disposition in /workspaces/meta-panda/knowledge/03-target-doc-map.md. Restructure into clean MyST, preserve ALL technical specifics (matrices, tables, examples, figures), apply the listed fixes, and split into the named target pages where the row says. `myst build` green; commit per target page + its PROGRESS line.
SPECIFICS: {SPECIFICS}
```
- **meta-panda working_with_a_design.rst** — split into how-to/use-web-control-to-set-up-a-panda (the bulk, attribute widgets folded in) + how-to/save-restore-design (the Saving/Opening sections). The four widget subsections (View/Edit, Dropdown, Text Input, Checkbox) stay stubbed as blocked:capture with their issue linked.
- **server fields.rst** — keep the MODE matrix and the Summary-of-Sub-Types / Summary-of-Attributes tables; point to reference/streaming-tables.
- **server commands.rst** — preserve the Configuration and System command tables; keep `*IDN?`.
- **server capture.rst** — keep the ~60 MB/s figure + webcontrol caveat; EXTRACT the "Capture Options" subsection into reference/capture-options (add the "run `*CAPTURE.OPTIONS?` live" note); link meta-panda how-to/integrate-with-a-panda for getting data out.
- **FPGA block.rst** — fill the "Block VHDL entity" section (LUT example); defer "Writing docs" (blocked:tooling, link its issue); do NOT split.

## PROMPT F — Final cross-repo verification  ·  model: Opus  ·  run from any repo
```
Final cross-repo verification of the docs `docs` branches. Confirm: every repo's `myst build` is green; xref links resolve across meta-panda / PandABlocks-FPGA / PandABlocks-server in BUILT output; intersphinx links into PandABlocks-client and fastcs-PandABlocks resolve; GitHub Pages deploys green per repo; PandABlocks-rootfs Pages is disabled; PandABlocks.github.io serves the single catch-all redirect to meta-panda.
Fix what you can; file issues for the rest. Capture the working xref/intersphinx config as a diff suitable for upstreaming into the python-copier-template. Summarise final status against /workspaces/meta-panda/knowledge/03-target-doc-map.md.
```
