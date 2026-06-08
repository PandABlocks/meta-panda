# PandABlocks Documentation Project — Step by Step Plan

This document covers all four phases: repo trawl, interview, planning, and output.
Each step specifies which tool to use, which model, and why.

---

## Guiding principles

**Git is the state store, not the context window.** Every artefact produced in
each phase is committed before moving on. Any session can be resumed cold.

**Dumb inputs, smart outputs.** Claude reads raw source and produces structured
summaries. Those summaries — not the raw source — are the inputs to every
subsequent phase. Context stays manageable throughout.

**Phases are independent.** You can pause between any two phases, hand the work
to a colleague, or resume weeks later. Each phase produces a well-defined set of
committed files that the next phase reads.

---

## Phase 1 — Repo trawl (automated reading)

**Goal:** Produce a structured inventory of everything that currently exists
across all five repos, without you doing any work.

**Tool:** Claude Code  
**Model:** Sonnet 4.6 (fast, cheap — this is mechanical reading, not deep reasoning)  
**Why not web:** The repos are on disk. Fetching files via web would be 100× slower
and require you to ferry content manually.

### What Claude Code does

1. Finds every `.rst` and `.md` file under `docs/` in each repo.
2. For each file, records: path, word count, last git commit date, and a
   two-sentence summary of what the page covers.
3. Identifies any doc pages that reference external URLs or other repo docs
   (potential cross-links that will need updating).
4. Writes the results to `meta-panda/knowledge/01-inventory.md` in a structured
   table, one section per repo.

### The prompt you give Claude Code

```
Read every .rst and .md file under docs/ in each of these repos:
PandABlocks-FPGA, PandABlocks-server, PandABlocks-rootfs,
PandABlocks.github.io, meta-panda.

For each file write a row in knowledge/01-inventory.md with:
- repo name
- file path relative to docs/
- word count
- date of last git commit on this file
- one sentence: what does this page cover?
- one sentence: what audience is it written for?
- flag: does it look outdated, partial, or current?

Commit when done.
```

### Output

`knowledge/01-inventory.md` — a complete map of what exists. Commit it.

---

## Phase 2 — Repo trawl (gap pre-analysis)

**Goal:** Have Claude read the inventory and the actual doc content to form a
first-pass view of what is missing, duplicated, or contradictory — before you
are involved at all.

**Tool:** Claude Code  
**Model:** Sonnet 4.6 — see note below  
**Why not web:** Still reading files on disk.

> **Pro plan limitation:** Opus is not available in Claude Code on Pro — it is
> reserved for Max plans. Sonnet 4.6 will do a reasonable job of gap analysis
> for a codebase of this size. If you find it too shallow, run a follow-up pass
> in Claude web (Phase 2b below) where Opus 4.8 is available.

### What Claude Code does

1. Reads `01-inventory.md` plus the full content of every doc file flagged as
   current or partial (skips ones it already flagged as clearly outdated).
2. Produces `knowledge/02-gap-analysis-draft.md` with three sections:
   - **Duplications** — the same content appearing in multiple repos
   - **Apparent gaps** — topics mentioned in passing but never given a full page
     (e.g. a how-to that says "see the build docs" but those docs don't exist)
   - **Questions for the owner** — things Claude cannot determine from the files
     alone, numbered Q1, Q2, Q3 etc. This becomes the interview agenda.

### The prompt you give Claude Code

```
Read knowledge/01-inventory.md and the content of every doc file marked
current or partial. Then write knowledge/02-gap-analysis-draft.md with:

Section 1 — Duplications: list pages that cover the same topic across repos.
Section 2 — Apparent gaps: topics referenced but never fully documented.
Section 3 — Questions for the owner: numbered list of things you cannot
determine from the files. Be specific — not "is this accurate?" but
"the quickstart guide says to run build.sh but the rootfs docs say to use
kas — which is correct for a new user in 2026?". Cap at 30 questions.

Commit when done.
```

### Output

`knowledge/02-gap-analysis-draft.md` — your interview agenda. Commit it.

### Optional Phase 2b — deeper gap analysis in Claude web

If the Sonnet output feels thin, start a new Claude web conversation with Opus 4.8,
paste in `01-inventory.md` and the full content of the most important doc files,
and ask it to deepen the gap analysis. Paste the result back into
`02-gap-analysis-draft.md` and commit. This costs Opus quota but is a single
focused session, not a long interview — it should stay well within one 5-hour window.

---

## Phase 3 — Interview (knowledge elicitation)

**Goal:** Answer Claude's questions from Phase 2, capture your own knowledge
about what the docs should cover, and produce a durable knowledge base that
survives any crash.

**Tool:** Claude web (this conversation)  
**Model:** Opus 4.8 (the current flagship, available on Pro)  
**Why not Claude Code:** This is a conversation, not a coding task. You are doing
significant cognitive work. The web interface is comfortable for long answers,
supports image uploads, works on mobile, and — critically — the conversation
history is preserved in Claude's servers regardless of what happens to your
container or machine. The container is not involved at all.

> **Usage note:** Each interview session will likely run 20–30 exchanges on Opus
> 4.8 with substantial context. Realistically, one or two heavy sessions per day
> is your ceiling on Pro before the 5-hour window fills. With six sessions (A–F)
> spread across two weeks this is comfortable — but do not try to run two
> sessions back-to-back. Start each session in a fresh conversation, not as a
> continuation of the previous one, to keep context lean.

### Session structure

Each session covers one subsystem. Do not try to cover everything in one
conversation. Suggested split:

| Session | Subsystem | Key files to paste in |
|---|---|---|
| A | Boot process and hardware overview | `02-gap-analysis-draft.md` questions about rootfs and meta-panda |
| B | Server command interface | Questions about PandABlocks-server |
| C | FPGA blocks and firmware | Questions about PandABlocks-FPGA |
| D | Web control and user-facing features | Questions about webcontrol |
| E | Tutorials — scope and accuracy | Cross-cutting questions about the four tutorials |
| F | Audience and scope decisions | Which docs live where, who reads them |

### How to start each session

Paste `02-gap-analysis-draft.md` into a new Claude web conversation with this
framing:

```
I am rewriting the documentation for the PandABlocks org. Here is a
gap analysis produced by reading the existing docs. This session covers
[subsystem]. Ask me the questions from Section 3 that relate to this
subsystem, one at a time. After each answer, summarise what I said in
2–4 bullet points. At the end of the session, compile all the bullet
points into a single knowledge file I can copy into my repo.
```

The "one at a time" instruction prevents Claude from overwhelming you with a
wall of questions. The "summarise after each answer" instruction means that
even if you give a rambling answer, the important information is extracted
cleanly.

### After each session

At the end, ask:

```
Write the full contents of knowledge/03-[subsystem].md based on
everything we discussed. Format it as structured markdown with clear
headings. Include: what this subsystem does, who the audiences are,
what currently exists, what is missing, and any specific facts I gave
you that aren't in the existing docs.
```

Copy the output into `knowledge/03-[subsystem].md` in your repo and commit it.
This is the crash-recovery checkpoint. You lose at most one session's work if
something goes wrong.

### Output

`knowledge/03-boot-process.md`  
`knowledge/03-server.md`  
`knowledge/03-fpga.md`  
`knowledge/03-webcontrol.md`  
`knowledge/03-tutorials.md`  
`knowledge/03-scope-decisions.md`  

All committed to `meta-panda/knowledge/`.

---

## Phase 4 — Planning (doc structure design)

**Goal:** Decide which documents exist, what they contain, which repo they live
in, and what the MyST-MD structure for each repo looks like. Produce a plan that
can be handed directly to the output phase.

**Tool:** Claude web  
**Model:** Opus 4.8  
**Why not Claude Code:** This is design work, not file work. You want to be able
to push back, ask "what if we merged these two pages", and have a real
conversation. The output is a plan document, not code.

> **Usage note:** This is likely one or two long sessions. Paste all the
> `knowledge/03-*.md` files in one go at the start — this is a large context
> load, but prompt caching means subsequent turns are much cheaper than the
> first. Start a fresh conversation; do not continue from a Phase 3 session.

### How to run this session

Start a new conversation and paste in all the `knowledge/03-*.md` files plus
`02-gap-analysis-draft.md`. Then:

```
Based on this knowledge base, design the full documentation structure for the
PandABlocks organisation. Each repo should have its own MyST-MD based doc
structure. Apply Diátaxis strictly: tutorials, how-to guides, explanations,
and reference. Follow the target structure from this GitHub issue [paste
the issue text].

For each document produce:
- repo it lives in
- Diátaxis category
- filename
- one-paragraph description of what it covers
- audience (new user / developer / operator)
- whether it can be written from the knowledge base alone, or needs
  more input from me

Output this as knowledge/04-doc-plan.md.
```

Review the plan carefully. This is the last moment to change your mind about
scope. When you are happy, copy `04-doc-plan.md` into the repo and commit it.

### MyST-MD structure in the plan

Ask Claude to also produce, for each repo, the skeleton `myst.yml` /
`_toc.yml` entries so the output phase has a template to fill, e.g.:

```yaml
# meta-panda/_toc.yml
format: jb-book
root: index
chapters:
  - file: tutorials/tutorial1_blinking_leds
  - file: how-to/quickstart
  - file: how-to/build
  ...
```

### Output

`knowledge/04-doc-plan.md` — full doc inventory with repo assignments  
`knowledge/04-toc-meta-panda.yml`  
`knowledge/04-toc-fpga.yml`  
`knowledge/04-toc-server.yml`  

All committed.

---

## Phase 5 — Output (writing the docs)

**Goal:** Write each document. Use the knowledge base as the source of truth.
Reference the existing docs only as inspiration, not as copy-paste material.

**Tool:** Claude Code for file creation and structure; Claude web for any doc
that needs significant back-and-forth with you  
**Model:** Opus 4.8 for the first draft of complex docs; Sonnet 4.6 for
mechanical docs (reference tables, toc files, redirect pages)  
**Why Claude Code here:** The writing phase is now a defined coding task. Claude
Code reads the plan file, knows exactly what to produce, and can write all the
files, set up the MyST directory structure, and commit as it goes. You review
PRs rather than driving each doc.

> **Usage note:** Sonnet 4.6 is the right default for Claude Code sessions here.
> Use the `/model opusplan` pattern — plan with Opus, execute with Sonnet —
> for any doc that needs real architectural thinking before writing. Switching
> models mid-session does not clear context, so Sonnet sees everything Opus
> planned.

### How to run this phase

One Claude Code session per repo. Each session:

```
Read knowledge/04-doc-plan.md and knowledge/04-toc-[repo].yml.
Write all the docs assigned to [repo] into docs/ using MyST markdown.
Use knowledge/03-*.md as your primary source. Where you need content
that isn't in the knowledge base, write a clearly marked placeholder:
<!-- TODO: needs input from owner — [specific question] -->

Create the _toc.yml, index.md, and conf.py for a MyST-MD build.
Commit after writing each document, not at the end.
```

The "commit after each document" instruction means a crash loses at most one
document.

### Docs that need your input during writing

Some docs — particularly the conceptual explanations and any tutorial that is
being significantly rewritten — will hit TODOs that need answers. Handle these
in Claude web, using the same session format as Phase 3:

```
Claude Code has written a draft of [doc] but flagged these TODOs.
[Paste the TODOs]. Answer my questions one at a time, then revise the draft.
```

Paste the revised draft back into the file and commit.

### Output

All documentation files in their final target repos, committed as draft PRs
for review.

---

## Summary table

| Phase | Name | Tool | Model | Crash risk | Output |
|---|---|---|---|---|---|
| 1 | Repo trawl — inventory | Claude Code | Sonnet 4.6 | Low — pure file reading | `01-inventory.md` |
| 2 | Repo trawl — gap analysis | Claude Code | Sonnet 4.6 | Low — produces one file | `02-gap-analysis-draft.md` |
| 2b | Gap analysis deepening (optional) | Claude web | Opus 4.8 | None — chat history durable | updated `02-gap-analysis-draft.md` |
| 3 | Interview | Claude web | Opus 4.8 | None — chat history is durable | `03-*.md` per subsystem |
| 4 | Planning | Claude web | Opus 4.8 | None — chat history is durable | `04-doc-plan.md`, toc files |
| 5 | Output | Claude Code | Sonnet 4.6 + Opus 4.8 via `/model opusplan` | Low — commits per document | Final doc files |

---

## Pro plan usage limits and model versions

### What's available on Pro

All three current Opus versions (4.6, 4.7, 4.8) are available on Pro in Claude
web. **Opus 4.8 is the right default** — it is the current flagship with the
best reasoning, and costs no more quota than 4.6 or 4.7. There is no reason to
reach for an older Opus version.

Sonnet 4.6 is the only Sonnet version currently on Pro. No version decision needed.

**Opus is not available in Claude Code on Pro.** It is reserved for Max plans.
Claude Code on Pro uses Sonnet 4.6 only. Plan accordingly: phases that need
Opus reasoning (gap analysis deepening, planning, complex doc drafts) must happen
in Claude web, not Claude Code.

### How limits work

Usage runs on a **5-hour rolling window**, not a daily reset. Approximate ceilings
on Pro: ~45 Opus messages or ~100 Sonnet messages per window. These are for
short, fresh conversations — a long interview session where Claude is re-processing
20 previous exchanges may consume 5–10× the quota of a first message. One or two
heavy Opus sessions per day is a realistic ceiling.

**The single biggest lever is conversation length.** Every previous message is
resent on every turn. Starting a fresh conversation for each interview session
(rather than continuing one long thread) is the most effective way to preserve
quota. Paste in only what that session needs — not the entire knowledge base.

### Version-specific tokenizer note

Opus 4.7 introduced a new tokenizer that encodes text 1.0–1.35× less efficiently
than Opus 4.6. Opus 4.8 uses the same tokenizer as 4.7, so moving from 4.7 to
4.8 has no token cost impact. For this project — mostly short RST/Markdown files
and your own prose — the tokenizer difference is unlikely to materially affect
how many sessions you get per window.

### If you hit a limit mid-session

- Switch to Sonnet 4.6 for the remainder of that session (non-reasoning turns
  like "write the knowledge file from our discussion" are fine on Sonnet).
- Or end the session, commit what you have, and resume in a new conversation
  after the window resets (5 hours from your first message).
- If limits are consistently blocking you by week 1, a one-month upgrade to
  Max 5× (£80) removes the constraint entirely.

---

## What lives in `meta-panda/knowledge/` at each checkpoint

After Phase 1: `01-inventory.md`  
After Phase 2: `01-inventory.md`, `02-gap-analysis-draft.md`  
After Phase 3: above + `03-boot-process.md`, `03-server.md`, `03-fpga.md`,
`03-webcontrol.md`, `03-tutorials.md`, `03-scope-decisions.md`  
After Phase 4: above + `04-doc-plan.md`, `04-toc-*.yml`  
After Phase 5: above + all final doc files in their repos  

The `knowledge/` directory is the complete audit trail of the project. Anyone
joining later can read it and understand every decision made.

---

## One thing to do before you start

Add this to `meta-panda/CLAUDE.md`:

```markdown
## Doc project status

Phase 1 — inventory: [ ]
Phase 2 — gap analysis: [ ]
Phase 3 — interviews:
  - [ ] Boot process and hardware (Session A)
  - [ ] Server command interface (Session B)
  - [ ] FPGA blocks and firmware (Session C)
  - [ ] Web control (Session D)
  - [ ] Tutorials (Session E)
  - [ ] Scope decisions (Session F)
Phase 4 — planning: [ ]
Phase 5 — output: [ ]

To resume any Claude Code session: read this file and knowledge/04-doc-plan.md.
```

Tick boxes off as you go. Claude Code reads this at the start of every session
and knows exactly where you are.
