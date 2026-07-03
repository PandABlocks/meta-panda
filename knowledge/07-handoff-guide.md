# PandABlocks Docs Rewrite — Claude Code Hand-off Guide

How to execute the rewrite from the planning artifacts. Read top-to-bottom once, then work task by task.

## Artifact set (read in this order)
1. `01-inventory.md` — what exists today (≈86 files, 5 repos).
2. `02-gap-analysis-draft.md` — duplications, gaps, open questions (now resolved below).
3. `04-interview-1…7` — the maintainer decisions behind every structural call.
4. `03-target-doc-map.md` — **the target structure** (every page × repo × quadrant × disposition × status). Source of truth for *what goes where*.
5. `05-stage-a-scaffolding-spec.md` — **how to scaffold** each repo from the DLS mystmd skeleton.
6. `06-source-provenance-map.md` — **for each target page, which source sections feed it**. Source of truth for *what to put in each page*.

If 03 and 06 ever disagree, 06 is newer (it includes close-read corrections listed at its top).

## Execution order & model per stage
| Stage | What | Model | Notes |
|---|---|---|---|
| A | Scaffold all repos to a green, empty-but-complete build (05) | Opus | One PR per repo. Resolve FPGA modules question + xref prototype here. Gate: `myst build` green + one Pages deploy. |
| B | Create GitHub issues from the 03 backlog | Sonnet | Needs PAT. Group by knowledge area; one issue per scoped item; link each to its stub page. |
| C | Icon recreation (8 attribute-state icons from malcolmjs colour spec) | Opus | Clone DiamondLightSource/malcolmjs; no "malcolm" in docs. |
| D | Bulk content conversion (mechanical RST→MyST, the 42 module docs + straightforward pages) | Sonnet | Chunk = one repo × one quadrant. Fill stubs; commit per file. |
| E | Hard content conversion (own task each — see below) | Opus | Judgment + restructuring. |
| F | Final cross-repo verification (xref end-to-end, intersphinx, all builds + Pages, rootfs Pages off, github.io redirect) | Opus | Integration gate. |
| (opt) | Assurance pass over 06 + the hard rewrites + xref config | Fable | Only if max fidelity wanted; ~2× Opus cost. |

## Chunking rule
One Claude Code task = **one repo × one Diátaxis quadrant**, EXCEPT these get their **own task** (large or judgment-heavy):
- meta-panda `working_with_a_design.rst` (4882w → splits into `use-web-control-to-set-up-a-panda` + `save-restore-design`)
- server `fields.rst` (2671w), `commands.rst` (1984w), `capture.rst` (1460w → also spawns `capture-options`)
- FPGA `block.rst` (1610w → fill VHDL-entity, defer Writing-docs)

≈18–20 tasks total.

## Branch / commit / durable-state discipline
- One **branch per repo** (e.g. `docs-rewrite`); never commit conversions straight to default.
- **Commit after every file** with a clear message; small commits survive a crashed session.
- Keep `docs/PROGRESS.md` (template provided) in each repo and update the relevant line in the **same commit** as the file it tracks. This is the crash-recovery checklist.
- **GitHub issues are durable state** for blocked items — a stub + its issue means that page is "done for this round."
- Copy `03`, `05`, `06` into each repo (e.g. under `docs/_rewrite/`) so every task is self-contained without this web session.

## Stub convention (Stage A and any blocked page)
Each stub: a title + a MyST admonition carrying the `status` from 03/06 and a `Source:` line from 06, plus a link to its GitHub issue if blocked. Stubs must be valid MyST so the build stays green.

## Per-task loop
1. Read the page's row in `06` (source file + sections) and `03` (disposition + status).
2. Read the live source file(s) in the repo; convert/merge/split per the notes.
3. Apply the interview fixes called out in the row (URL fixes, `boot.txt`→`config.txt`, etc.).
4. If `blocked: *`: leave the stub, ensure the issue exists, move on.
5. `myst build`; fix until green. Commit file + PROGRESS line. 

## Open items to settle in-flight (not blockers)
- FPGA per-block docs: symlink `modules/` into `docs/` vs out-of-tree TOC reference — prototype both in Stage A, pick the clean build, document it.
- xref/intersphinx exact keys — settle against current mystmd cross-references docs during Stage A; capture config for upstream into the copier template.
- CI/Pages workflow is not in the skeleton upload — confirm or add the GitHub Actions docs build+deploy per repo in Stage A.
