#!/usr/bin/env bash
# Prompt B — GitHub issue creation for the docs-rewrite backlog.
# Source: meta-panda/knowledge/03-target-doc-map.md §"Issue backlog"
#
# Prerequisites:
#   • gh authenticated with a PAT (scopes: repo, issues)
#   • All three repos on their `docs` branch at the paths below
#     (Prompt A must have been run first)
#
# Run from any directory.  Designed to be run once; re-running is safe
# if it failed partway — gh refuses duplicate titles and the sed
# replacements are idempotent (they only match the Stage-B placeholder text).

set -euo pipefail

META=/workspaces/meta-panda
FPGA=/workspaces/PandABlocks-FPGA
SERVER=/workspaces/PandABlocks-server

# Extract the issue number from a gh issue URL
# e.g. "https://github.com/PandABlocks/meta-panda/issues/42" → "42"
num() { echo "$1" | grep -oE '[0-9]+$'; }

# ─── 0. Ensure labels exist in all three repos ───────────────────────────────
echo "=== 0. Creating labels ==="
for REPO in PandABlocks/meta-panda PandABlocks/PandABlocks-FPGA PandABlocks/PandABlocks-server; do
  gh label create "docs-rewrite"        --repo "$REPO" --color "0075ca" --description "Docs rewrite backlog"                                --force
  gh label create "human-capture"       --repo "$REPO" --color "fbca04" --description "Needs human-captured screenshots or bullets"         --force
  gh label create "verify-then-write"   --repo "$REPO" --color "d93f0b" --description "Needs maintainer verification before writing"        --force
  gh label create "author-from-scratch" --repo "$REPO" --color "0e8a16" --description "New content to author from scratch"                  --force
  gh label create "infrastructure"      --repo "$REPO" --color "5319e7" --description "Docs build/deploy infrastructure"                    --force
  gh label create "tooling"             --repo "$REPO" --color "e99695" --description "Docs tooling / autogeneration"                       --force
done

# ─────────────────────────────────────────────────────────────────────────────
# PandABlocks/meta-panda  (9 issues)
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== 1. meta-panda issues ==="

# ── I1: tutorials 3 + 4  [human-capture] ─────────────────────────────────────
I1_URL=$(gh issue create \
  --repo PandABlocks/meta-panda \
  --title "docs: provide screenshots and content for tutorial 3 (position compare) and tutorial 4 (snake scan)" \
  --label "docs-rewrite,human-capture" \
  --body "$(cat << 'BODY'
## Target pages

- `tutorials/tutorial3_position_compare`
- `tutorials/tutorial4_snake_scan`

Both stubs contain fewer than 60 words each and are currently near-empty
placeholders.  They need the same depth as tutorials 1 and 2 (~600–1200 words
plus annotated screenshots).

## Category: human-capture

These pages can only be completed once a person with hands-on PandA access
supplies annotated screenshots and step-by-step bullets.  A doc engineer will
then expand them into finished MyST pages.

## What a human must do (~4–6 hours total)

### Tutorial 3 — Position compare (`tutorial3_position_compare`)

On a PandA connected to Web Control:

1. Configure a PCOMP block so that a position input is compared against a
   threshold and generates trigger pulses on the output.
2. Take labelled screenshots at each step (block palette, attribute panel, link
   arrows, waveform output if available).
3. Write numbered steps (goal → prerequisites → procedure → expected output) in
   the same voice as tutorials 1 and 2.
4. Record exact block names, field names, and representative parameter values.

### Tutorial 4 — Snake scan (`tutorial4_snake_scan`)

1. Build a 2D snake scan using a SEQ block and its table editor.
2. Take labelled screenshots of the SEQ table configuration and the resulting
   trigger output.
3. Write numbered steps at the same depth as tutorial 2.

Deposit screenshots under `docs/images/` in the `docs` branch and post the
bullets as a comment on this issue (or open a PR).

## Source stubs

- `docs/_legacy_rst/tutorials/tutorial3_position_compare.rst` — 41 words (stub)
- `docs/_legacy_rst/tutorials/tutorial4_snake_scan.rst` — 52 words (stub)
BODY
)")
I1=$(num "$I1_URL")
echo "  meta-panda#$I1: tutorials 3+4"

# Update tutorial3 stub
sed -i "s|**Blocked:** a GitHub issue will be created in Stage B (Prompt B) and linked here\.|**Blocked:** [PandABlocks/meta-panda#$I1]($I1_URL)|" \
  "$META/docs/tutorials/tutorial3_position_compare.md"

# Update tutorial4 stub
sed -i "s|**Blocked:** a GitHub issue will be created in Stage B (Prompt B) and linked here\.|**Blocked:** [PandABlocks/meta-panda#$I1]($I1_URL)|" \
  "$META/docs/tutorials/tutorial4_snake_scan.md"

# Update PROGRESS.md (two TBD lines → same issue)
sed -i "s|⛔ tutorials/tutorial3_position_compare — issue #TBD — human-capture|⛔ tutorials/tutorial3_position_compare — issue #$I1 — human-capture|" "$META/docs/PROGRESS.md"
sed -i "s|⛔ tutorials/tutorial4_snake_scan — issue #TBD — human-capture|⛔ tutorials/tutorial4_snake_scan — issue #$I1 — human-capture|" "$META/docs/PROGRESS.md"


# ── I2: web-control attribute-widget screenshots + trailing sentence  [human-capture]
I2_URL=$(gh issue create \
  --repo PandABlocks/meta-panda \
  --title "docs: add screenshots and trailing sentence for the four attribute input widgets in how-to/use-web-control" \
  --label "docs-rewrite,human-capture" \
  --body "$(cat << 'BODY'
## Target page

`how-to/use-web-control-to-set-up-a-panda`

The "Specifying Block Attributes" section has been converted but the subsection
covering the four attribute input widgets is blocked pending fresh screenshots
and one missing sentence from the source.

## Category: human-capture

## What a human must do (~2 hours)

1. In PandA Web Control, find or create attributes that exercise each of the
   four input widget types:
   - **View/Edit button** — a complex / table attribute
   - **Dropdown list** — an enum attribute
   - **Text input** — a free-text string or numeric attribute
   - **Checkbox** — a boolean on/off attribute
2. Take one labelled screenshot per widget type clearly showing the widget in
   context inside the Block Information Panel.
3. Provide the concluding sentence for the *Text input* widget description —
   the source text (`working_with_a_design.rst`) is truncated mid-sentence at
   that point.

Deposit screenshots under `docs/images/` in the `docs` branch and post the
sentence and image filenames as a comment on this issue.

## Source

`docs/_legacy_rst/webcontrol/userguide/working_with_a_design.rst` — the four
widget subsections under "Specifying Block Attributes → Types".
BODY
)")
I2=$(num "$I2_URL")
echo "  meta-panda#$I2: widget screenshots"

# Update inline stub in the converted page (multi-line text — use perl)
perl -i -0pe \
  "s|A GitHub issue covering the widget screenshots and the\ntrailing sentence will be created in Stage B \(Prompt B\) and linked here\.|Tracked in [PandABlocks/meta-panda#$I2]($I2_URL).|" \
  "$META/docs/how-to/use-web-control-to-set-up-a-panda.md"

# Update PROGRESS.md
sed -i "s|⛔ how-to/use-web-control-to-set-up-a-panda (4 widget screenshots + trailing sentence) — issue #TBD — capture|⛔ how-to/use-web-control-to-set-up-a-panda (widget screenshots + trailing sentence) — issue #$I2 — human-capture|" "$META/docs/PROGRESS.md"


# ── I3: 3.0→4.0 breaking changes  [verify-then-write] ────────────────────────
I3_URL=$(gh issue create \
  --repo PandABlocks/meta-panda \
  --title "docs: document 3.0→4.0 breaking changes and migration guide" \
  --label "docs-rewrite,verify-then-write" \
  --body "$(cat << 'BODY'
## Target page

`reference/changes`

## Category: verify-then-write

The existing source (`github.io reference/migration_guide.rst`) only covers
2.0→3.0.  The 3.0→4.0 section is completely absent.

## What a human must do (~3 hours)

1. Review the PandABlocks 4.0 release notes, CHANGELOG, and git log for
   breaking changes since 3.0.
2. Check the existing `migration_guide.rst` (2.0→3.0) for style reference.
3. Write a 3.0→4.0 section for `reference/changes` covering:
   - Config file changes (`boot.txt` → `config.txt`, etc.)
   - Wire-protocol breaking changes (if any)
   - Removed / renamed blocks or fields
   - Build toolchain changes
4. Also add a compatibility matrix row for the 3.0→4.0 transition alongside
   the existing `release_compatibility.rst` content.

Post the draft as a comment or PR against the `docs` branch.

## Source

- `docs/_legacy_rst/` (`github.io` copies) — `reference/migration_guide.rst`
  (119 words, 2.0→3.0 only)
- `reference/release_compatibility.rst` (32 words)
BODY
)")
I3=$(num "$I3_URL")
echo "  meta-panda#$I3: 3.0→4.0 changes"

sed -i "s|**Blocked:** a GitHub issue will be created in Stage B (Prompt B) and linked here\.|**Blocked:** [PandABlocks/meta-panda#$I3]($I3_URL)|" \
  "$META/docs/reference/changes.md"

sed -i "s|⛔ reference/changes — issue #TBD — verify (3.0->4.0)|⛔ reference/changes — issue #$I3 — verify (3.0->4.0)|" "$META/docs/PROGRESS.md"


# ── I4: machine-target support tiers  [verify-then-write] ────────────────────
I4_URL=$(gh issue create \
  --repo PandABlocks/meta-panda \
  --title "docs: fill in hardware details for pandabox2 and pandabrick in reference/machine-targets" \
  --label "docs-rewrite,verify-then-write" \
  --body "$(cat << 'BODY'
## Target page

`reference/machine-targets`

The MACHINE table matches `conf/machine/`, and support tiers are settled
(pandabox/pandabox2/pandabrick generally supported; xu5-st1/zedboard
development-only). Only the details columns remain (see the verify note on
the `pandabrick` row).

## Category: verify-then-write

## What a human must do (~30 min)

Fill in the "Hardware"/"Notes" column entries for `pandabox2` and
`pandabrick` (SoC/module name, link to any hardware description).

Post findings as a comment or PR.

## Source

`docs/reference/machine-targets.md` table; ground truth `conf/machine/*.conf`.
BODY
)")
I4=$(num "$I4_URL")
echo "  meta-panda#$I4: machine-target hardware details"

# Update inline HTML comment in the table cell
sed -i "s|<!-- verify: notes/details for pandabox2 and pandabrick -->|<!-- verify: PandABlocks/meta-panda#$I4 — hardware details for pandabox2/pandabrick -->|" \
  "$META/docs/reference/machine-targets.md"

# Append to Blocked section (not yet listed)
sed -i "s|^## Notes$|- ⛔ reference/machine-targets (hardware details) — issue #$I4 — verify\n\n## Notes|" "$META/docs/PROGRESS.md"


# ── I5: KAS_IMAGE_VERSION mapping  [verify-then-write] ───────────────────────
I5_URL=$(gh issue create \
  --repo PandABlocks/meta-panda \
  --title "docs: verify and document the KAS_IMAGE_VERSION values for how-to/build" \
  --label "docs-rewrite,verify-then-write" \
  --body "$(cat << 'BODY'
## Target page

`how-to/build`

The page instructs users to set `KAS_IMAGE_VERSION` but defers to the release
notes for the correct value, with a verify note in the source.

## Category: verify-then-write

## What a human must do (~1 hour)

1. Confirm the current valid `KAS_IMAGE_VERSION` value(s) for PandABlocks 5.x.
2. Document what the variable selects (which build container image / tag).
3. If the value is fixed per major release, add a table mapping release →
   `KAS_IMAGE_VERSION`.
4. If it tracks `kas.yml` automatically, update the note to say so clearly.

Post findings as a comment or PR against `how-to/build.md`.

## Source

`docs/how-to/build.md` — the `:::{note}` block under "Build steps → step 3".
BODY
)")
I5=$(num "$I5_URL")
echo "  meta-panda#$I5: KAS_IMAGE_VERSION"

sed -i "s|<!-- verify: confirm current value -->|<!-- verify: PandABlocks/meta-panda#$I5 — confirm KAS_IMAGE_VERSION values -->|" \
  "$META/docs/how-to/build.md"

sed -i "s|^## Notes$|- ⛔ how-to/build (KAS_IMAGE_VERSION) — issue #$I5 — verify\n\n## Notes|" "$META/docs/PROGRESS.md"


# ── I6: legacy zpg filename  [verify-then-write] ─────────────────────────────
I6_URL=$(gh issue create \
  --repo PandABlocks/meta-panda \
  --title "docs: confirm legacy-updater zpg filename convention for pre-5.0 upgrade path" \
  --label "docs-rewrite,verify-then-write" \
  --body "$(cat << 'BODY'
## Target page

`how-to/upgrade-via-web-admin`

The pre-5.0 upgrade path instructs users to download the legacy-updater package
from GitHub Releases, but does not state the exact filename/pattern.

## Category: verify-then-write

## What a human must do (~1 hour)

1. Check the GitHub Releases page for meta-panda for the legacy zpg/zpkg
   updater packages.
2. Document the exact filename pattern (e.g. `panda-upgrade-<version>.zpg`)
   and any machine-type suffix.
3. Confirm whether the file extension is `.zpg`, `.zpkg`, or something else.
4. Update `how-to/upgrade-via-web-admin.md` with a concrete filename example.

Post findings as a comment or PR.

## Source

`docs/how-to/upgrade-via-web-admin.md` — the "Pre-5.0 PandAs" subsection,
step 1.
BODY
)")
I6=$(num "$I6_URL")
echo "  meta-panda#$I6: zpg filename"

sed -i "s|<!-- verify: confirm zpg filename convention for the legacy updater -->|<!-- verify: PandABlocks/meta-panda#$I6 — confirm zpg filename pattern -->|" \
  "$META/docs/how-to/upgrade-via-web-admin.md"

sed -i "s|^## Notes$|- ⛔ how-to/upgrade-via-web-admin (zpg filename) — issue #$I6 — verify\n\n## Notes|" "$META/docs/PROGRESS.md"


# ── I7: Xilinx branch bump post-5.0  [verify-then-write] ─────────────────────
I7_URL=$(gh issue create \
  --repo PandABlocks/meta-panda \
  --title "docs: confirm the Xilinx yocto-manifests branch for post-5.0 manual builds" \
  --label "docs-rewrite,verify-then-write" \
  --body "$(cat << 'BODY'
## Target page

`how-to/manual-build`

The page currently references branch `rel-v2023.2` of
`github.com/Xilinx/yocto-manifests`.  A verify note flags that this may need
updating for post-5.0 releases.

## Category: verify-then-write

## What a human must do (~1 hour)

1. Confirm whether `rel-v2023.2` is still the correct Xilinx manifest branch
   for building PandABlocks 5.x.
2. If a newer branch is required for post-5.0, document it and the reason for
   the change.
3. If the branch varies by PandABlocks release, add a small table (PandABlocks
   version → manifest branch).

Post findings as a comment or PR against `how-to/manual-build.md`.

## Source

`docs/how-to/manual-build.md` — the `repo init` step.
BODY
)")
I7=$(num "$I7_URL")
echo "  meta-panda#$I7: Xilinx branch"

sed -i "s|<!-- verify: confirm the correct branch for post-5.0 releases -->|<!-- verify: PandABlocks/meta-panda#$I7 — confirm Xilinx manifest branch for post-5.0 -->|" \
  "$META/docs/how-to/manual-build.md"

sed -i "s|^## Notes$|- ⛔ how-to/manual-build (Xilinx branch post-5.0) — issue #$I7 — verify\n\n## Notes|" "$META/docs/PROGRESS.md"


# ── I8: hardware-target descriptions  [author-from-scratch] ──────────────────
I8_URL=$(gh issue create \
  --repo PandABlocks/meta-panda \
  --title "docs: author per-target hardware descriptions for explanations/hardware-targets" \
  --label "docs-rewrite,author-from-scratch" \
  --body "$(cat << 'BODY'
## Target page

`explanations/hardware-targets`

The page is a full stub — no content has been written yet.  It should describe
each supported hardware target so integrators know which platform to choose.

## Category: author-from-scratch

## What a human must do (~4 hours)

For each MACHINE value in `reference/machine-targets` (pandabox, pandabox2,
pandabrick, plus the development-only xu5-st1 and zedboard — the list in
`conf/machine/`), provide:

1. **SoC / module** — the Xilinx SoC or module part number.
2. **Key I/O** — number and type of I/O connectors, FMC slots, SFP, etc.
3. **Distinguishing features** — what makes this target different from the
   others (performance, I/O count, form factor).
4. **Typical use case** — e.g. "general purpose lab PandA", "high-channel-count
   detector trigger".
5. **Links** — hardware datasheet or purchase page where publicly available.

A table-per-target or a definition-list format is fine.  Post as a comment or
PR against `explanations/hardware-targets.md`.

## Source

Interview6 §A (background); cross-reference `reference/machine-targets.md`.
BODY
)")
I8=$(num "$I8_URL")
echo "  meta-panda#$I8: hardware-target descriptions"

sed -i "s|**Blocked:** a GitHub issue will be created in Stage B (Prompt B) and linked here\.|**Blocked:** [PandABlocks/meta-panda#$I8]($I8_URL)|" \
  "$META/docs/explanations/hardware-targets.md"

sed -i "s|⛔ explanations/hardware-targets — issue #TBD — author|⛔ explanations/hardware-targets — issue #$I8 — author|" "$META/docs/PROGRESS.md"


# ── I9: versioned docs / version switcher  [infrastructure] ──────────────────
I9_URL=$(gh issue create \
  --repo PandABlocks/meta-panda \
  --title "docs: implement versioned docs and version switcher (R5)" \
  --label "docs-rewrite,infrastructure" \
  --body "$(cat << 'BODY'
## Scope

All three docs repos: meta-panda, PandABlocks-FPGA, PandABlocks-server.

This is review item R5 from the target map — deferred from the initial
content-rewrite round.

## Background

Each repo's GitHub Pages CI workflow already runs `make_switcher.py` and
produces a `switcher.json`, but the version switcher is not yet wired into the
MyST / sphinx-book-theme theme configuration.  The Pages deploy publishes under
a versioned sub-path (`/<repo>/<version>/`).

## What needs doing (~2–4 hours)

1. **Wire the switcher into the theme** — add `html_theme_options.switcher` (or
   the MyST equivalent) so the version dropdown appears in the built docs.
2. **Test the switcher URL** — confirm `switcher.json` is reachable at the path
   the theme expects (typically the repo root or a known static path).
3. **Handle `main` vs tag versions** — ensure the switcher lists released tags
   and `main`/`latest` sensibly.
4. **Apply consistently** — the same change needs landing in all four repos (or
   factored into the copier template if that's easier).
5. **Document the setup** in `how-to/contribute` under the xref/intersphinx
   section (already drafted there).

## Notes

- The Pages CI workflow details are in each repo's `docs/PROGRESS.md` → Notes.
- The copier-template upstreaming opportunity is noted in `how-to/contribute`.
BODY
)")
I9=$(num "$I9_URL")
echo "  meta-panda#$I9: versioned docs (R5)"

sed -i "s|^## Notes$|- ⛔ infrastructure: versioned docs / version switcher (R5) — issue #$I9 — infrastructure\n\n## Notes|" "$META/docs/PROGRESS.md"


# ── Commit meta-panda changes ─────────────────────────────────────────────────
echo ""
echo "  Committing meta-panda Stage B edits..."
git -C "$META" add docs/tutorials/tutorial3_position_compare.md \
                   docs/tutorials/tutorial4_snake_scan.md \
                   docs/how-to/use-web-control-to-set-up-a-panda.md \
                   docs/how-to/build.md \
                   docs/how-to/upgrade-via-web-admin.md \
                   docs/how-to/manual-build.md \
                   docs/reference/changes.md \
                   docs/reference/machine-targets.md \
                   docs/explanations/hardware-targets.md \
                   docs/PROGRESS.md
git -C "$META" commit -m "$(cat << 'MSG'
docs: Stage B — link GitHub issues into stubs and verify notes

Issues created for all human-capture, verify-then-write, author-from-scratch,
and infrastructure backlog items (see PROGRESS.md Blocked section).
MSG
)"


# ─────────────────────────────────────────────────────────────────────────────
# PandABlocks/PandABlocks-FPGA  (4 issues)
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== 2. PandABlocks-FPGA issues ==="

# ── I10: testing CI  [verify-then-write] ─────────────────────────────────────
I10_URL=$(gh issue create \
  --repo PandABlocks/PandABlocks-FPGA \
  --title "docs: verify and update how-to/testing for current CI (GitHub Actions + DLS GitLab)" \
  --label "docs-rewrite,verify-then-write" \
  --body "$(cat << 'BODY'
## Target page

`how-to/testing`

The page is a full stub — the source (`reference/testing.rst`) describes a
Travis CI setup that has since moved to GitHub Actions (simulation tests) and
DLS internal GitLab (full FPGA build tests).

## Category: verify-then-write

## What a human must do (~3 hours)

1. Verify the current CI arrangement:
   - Which test suite(s) run on **GitHub Actions** (open to contributors)?
     Typically the Python / cocotb simulation tests.
   - Which test suite(s) run on **DLS internal GitLab** (requires DLS access)?
     Typically the full FPGA bitstream build and hardware-in-the-loop tests.
2. For each suite: document the trigger (PR/push/manual), the command to run
   locally, and any required setup (Python version, simulator, DLS VPN).
3. Note which tests require access to real hardware vs simulation only.
4. Replace the stub with the verified content.

Post as a PR against `docs/how-to/testing.md` on the `docs` branch.

## Source

`docs/_legacy_rst/reference/testing.rst` — 274 words (Python tests, HDL tests).
BODY
)")
I10=$(num "$I10_URL")
echo "  FPGA#$I10: testing CI"

sed -i "s|**Blocked:** a GitHub issue will be created in Stage B (Prompt B) and linked here\.|**Blocked:** [PandABlocks/PandABlocks-FPGA#$I10]($I10_URL)|" \
  "$FPGA/docs/how-to/testing.md"

sed -i "s|⛔ how-to/testing — issue #TBD — verify|⛔ how-to/testing — issue #$I10 — verify|" "$FPGA/docs/PROGRESS.md"


# ── I11: cocotb IP assumption  [verify-then-write] ───────────────────────────
I11_URL=$(gh issue create \
  --repo PandABlocks/PandABlocks-FPGA \
  --title "docs: verify the cocotb 'modules using IP are unsupported' assumption against the full block set" \
  --label "docs-rewrite,verify-then-write" \
  --body "$(cat << 'BODY'
## Target page

`how-to/cocotb`

The page includes the statement: "Modules that use IP are currently unsupported
by the cocotb runner.  All soft blocks (those covered by simulation) are
believed not to use IP and should remain testable — verify this assumption
against the full block set."

## Category: verify-then-write

## What a human must do (~1–2 hours)

1. Check the full list of modules under `modules/` against the cocotb runner.
2. Confirm whether any soft blocks use Xilinx IP (and therefore cannot be
   cocotb-tested).
3. If the assumption holds: remove the verify note and state it as fact.
4. If exceptions exist: list the affected modules and explain why they are
   excluded.
5. If the limitation has been lifted: update the text accordingly.

Post findings as a comment or PR against `docs/how-to/cocotb.md`.

## Source

`docs/how-to/cocotb.md` — "About cocotb" section, lines 12–14.
BODY
)")
I11=$(num "$I11_URL")
echo "  FPGA#$I11: cocotb IP assumption"

sed -i "s|verify this assumption against the full block set|verify this assumption — tracked in [PandABlocks/PandABlocks-FPGA#$I11]($I11_URL)|" \
  "$FPGA/docs/how-to/cocotb.md"

sed -i "s|^## Notes$|- ⛔ how-to/cocotb (IP assumption) — issue #$I11 — verify\n\n## Notes|" "$FPGA/docs/PROGRESS.md"


# ── I12: VHDL coding standard  [author-from-scratch] ─────────────────────────
I12_URL=$(gh issue create \
  --repo PandABlocks/PandABlocks-FPGA \
  --title "docs: author the VHDL coding standard for reference/vhdl-standard" \
  --label "docs-rewrite,author-from-scratch" \
  --body "$(cat << 'BODY'
## Target page

`reference/vhdl-standard`

No source exists — this is new content identified in Interview1 §4 as needed
for FPGA block contributors.

## Category: author-from-scratch

## What a human must do (~4 hours)

Write the VHDL coding standard for PandABlocks FPGA block authors, covering at
minimum:

1. **Naming conventions** — entity/architecture/signal/constant/type naming.
2. **Entity and architecture style** — port ordering (clk/rst first, then
   inputs, then outputs), generic placement, `architecture rtl of` boilerplate.
3. **Reset style** — synchronous vs asynchronous; active-high vs active-low.
4. **Signal initialisation** — what is and is not allowed in simulation vs
   synthesis.
5. **Comment requirements** — what must be commented (port descriptions,
   non-obvious logic).
6. **Testbench conventions** — file naming, clock generation, `timing.ini`
   relationship.
7. **Project-specific idioms** — any PandABlocks-specific patterns (e.g. use of
   `entity_pkg`, `block_sim` wrapper conventions).

Post as a PR against `docs/reference/vhdl-standard.md` on the `docs` branch.
BODY
)")
I12=$(num "$I12_URL")
echo "  FPGA#$I12: VHDL standard"

sed -i "s|**Blocked:** a GitHub issue will be created in Stage B (Prompt B) and linked here\.|**Blocked:** [PandABlocks/PandABlocks-FPGA#$I12]($I12_URL)|" \
  "$FPGA/docs/reference/vhdl-standard.md"

sed -i "s|⛔ reference/vhdl-standard — issue #TBD — author|⛔ reference/vhdl-standard — issue #$I12 — author|" "$FPGA/docs/PROGRESS.md"


# ── I13: MyST block-listing generator + block-doc directives  [tooling] ───────
# NOTE: not in the 03 backlog "Issue backlog" section, but both stub pages
#       (reference/blocks.md and how-to/block.md) explicitly promise a Stage B
#       issue; included here to fulfil that promise.
I13_URL=$(gh issue create \
  --repo PandABlocks/PandABlocks-FPGA \
  --title "docs: implement MyST block-listing generator and block-doc authoring directives" \
  --label "docs-rewrite,tooling" \
  --body "$(cat << 'BODY'
## Blocked pages

- `reference/blocks` — needs a MyST generator to replace the old Sphinx
  `.. include:: build/blocks.txt`; will auto-list every block type from the
  42 `modules/*/*_doc.md` pages.
- `how-to/block` § "Writing docs" — instructions for writing per-block docs
  deferred until the MyST tooling has landed and the two RST directives
  (`block_fields`, `timing_plot`) have MyST equivalents.

## Category: tooling

## What needs doing

### reference/blocks generator

Currently `docs/reference/blocks.md` is a stub.  The old RST approach used a
generated `blocks.txt` injected via `.. include::`.  The MyST replacement
needs to either:

- (a) Generate a `blocks.md` from the 42 `modules/*/*_doc.md` files at build
  time (a `myst-nb` or custom Sphinx extension), or
- (b) Use MyST's `{include}` / `{toctree}` pattern to auto-assemble the listing.

Prototype and document the chosen approach.

### block-doc directives

The `block_fields` and `timing_plot` RST directives used in the converted
`modules/*/*_doc.md` files need MyST-compatible implementations (or a mapping
to native MyST/Sphinx equivalents) so that `myst build` renders them correctly.

Document the authoring workflow in `how-to/block` § "Writing docs" once the
directives are working.

## Related

- `modules/*/*_doc.md` (×42) are already converted to MyST; the directives
  appear in them as raw RST pass-through blocks pending this work.
BODY
)")
I13=$(num "$I13_URL")
echo "  FPGA#$I13: MyST block tooling"

# reference/blocks.md
sed -i "s|**Blocked:** a GitHub issue will be created in Stage B (Prompt B) and linked here\.|**Blocked:** [PandABlocks/PandABlocks-FPGA#$I13]($I13_URL)|" \
  "$FPGA/docs/reference/blocks.md"

# how-to/block.md "Writing docs" admonition
sed -i "s|A GitHub issue tracking the MyST block-listing generator and the block-doc\ndirectives will be created in Stage B (Prompt B) and linked here\.|Tracked in [PandABlocks/PandABlocks-FPGA#$I13]($I13_URL).|" \
  "$FPGA/docs/how-to/block.md"
# If the above single-line sed misses the newline, fall back to perl:
perl -i -0pe \
  "s|A GitHub issue tracking the MyST block-listing generator and the block-doc\ndirectives will be created in Stage B \(Prompt B\) and linked here\.|Tracked in [PandABlocks/PandABlocks-FPGA#$I13]($I13_URL).|" \
  "$FPGA/docs/how-to/block.md" 2>/dev/null || true

sed -i "s|⛔ reference/blocks — issue #TBD — tooling (MyST block-listing generator)|⛔ reference/blocks — issue #$I13 — tooling (MyST block-listing generator)|" "$FPGA/docs/PROGRESS.md"
sed -i "s|⛔ how-to/block \"Writing docs\" section — issue #TBD — tooling (block-doc directives.*)|⛔ how-to/block \"Writing docs\" section — issue #$I13 — tooling (block-doc directives, deferred until MyST per-block doc tooling lands)|" "$FPGA/docs/PROGRESS.md"


# ── Commit FPGA changes ───────────────────────────────────────────────────────
echo ""
echo "  Committing FPGA Stage B edits..."
git -C "$FPGA" add docs/how-to/testing.md \
                   docs/how-to/cocotb.md \
                   docs/how-to/block.md \
                   docs/reference/vhdl-standard.md \
                   docs/reference/blocks.md \
                   docs/PROGRESS.md
git -C "$FPGA" commit -m "$(cat << 'MSG'
docs: Stage B — link GitHub issues into stubs and verify notes
MSG
)"


# ─────────────────────────────────────────────────────────────────────────────
# PandABlocks/PandABlocks-server  (7 issues)
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== 3. PandABlocks-server issues ==="

# ── I14: capture-options superset  [verify-then-write] ───────────────────────
I14_URL=$(gh issue create \
  --repo PandABlocks/PandABlocks-server \
  --title "docs: confirm the documented capture options against a live PandA server" \
  --label "docs-rewrite,verify-then-write" \
  --body "$(cat << 'BODY'
## Target page

`reference/capture-options`

The capture-option tables have been verified against the server source
(`server/pos_out.c`: the `capture_option_info` and `nominal_capture_masks`
tables) and harmonised across `capture-options.md`, `capture.md` and
`fields.md`. What remains is a quick live confirmation.

## Category: verify-then-write

## What a human must do (~30 min)

1. Run `*CAPTURE.OPTIONS?` and `*CAPTURE.ENUMS?` against a live PandA server
   (v4.x / v5.x), once on a firmware build with `StdDev` support and once
   without if available.
2. Compare the responses against the tables in `reference/capture-options.md`
   (expected: Value, Diff, Sum, Mean, Min, Max [, StdDev]; enums add No,
   Min Max, Min Max Mean [, Mean StdDev]).
3. Correct the page if anything differs; otherwise just close this issue.

## Source

`docs/reference/capture-options.md`; `server/pos_out.c` for the
source-of-truth tables.
BODY
)")
I14=$(num "$I14_URL")
echo "  server#$I14: capture-options superset"

# Link the live-confirmation issue from the note on the page
perl -i -0pe "s|options \(\`StdDev\`, and therefore \`Mean StdDev\`\) depends on the FPGA\nconfiguration\.|options (\`StdDev\`, and therefore \`Mean StdDev\`) depends on the FPGA\nconfiguration. Live confirmation tracked in [PandABlocks/PandABlocks-server#$I14]($I14_URL).|" \
  "$SERVER/docs/reference/capture-options.md"

sed -i "s|^## Notes$|- ⛔ reference/capture-options (live confirmation) — issue #$I14 — verify\n\n## Notes|" "$SERVER/docs/PROGRESS.md"


# ── I15: 60 MB/s figure  [verify-then-write] ─────────────────────────────────
I15_URL=$(gh issue create \
  --repo PandABlocks/PandABlocks-server \
  --title "docs: verify the 60 MBytes/s high-performance capture throughput figure" \
  --label "docs-rewrite,verify-then-write" \
  --body "$(cat << 'BODY'
## Target page

`reference/capture`

The "High performance mode" section states: "In tests it has been capable of
sustaining 60 MBytes/s when panda-webcontrol is **not** installed."

## Category: verify-then-write

## What a human must do (~1–2 hours)

1. Confirm the 60 MBytes/s figure is still achievable with current firmware.
2. Note the conditions under which it was measured:
   - Hardware revision (pandabox / xu5 / etc.)
   - FPGA image version
   - Network interface (GigE / 10GigE)
   - `FRAMED RAW` mode
3. If the figure has changed (higher or lower), update it with the new value
   and measurement conditions.
4. If panda-webcontrol is no longer a factor, remove or update that caveat.

Post findings as a comment or PR against `docs/reference/capture.md`.

## Source

`docs/reference/capture.md` — "High performance mode" section.
BODY
)")
I15=$(num "$I15_URL")
echo "  server#$I15: 60 MB/s figure"

# Add a verify comment after the 60 MBytes/s sentence
sed -i "s|been capable of sustaining 60 MBytes/s when panda-webcontrol is \*\*not\*\* installed\.|been capable of sustaining 60 MBytes/s when panda-webcontrol is **not** installed. <!-- verify: PandABlocks/PandABlocks-server#$I15 — confirm figure and conditions -->|" \
  "$SERVER/docs/reference/capture.md"

sed -i "s|^## Notes$|- ⛔ reference/capture (60 MB/s figure) — issue #$I15 — verify\n\n## Notes|" "$SERVER/docs/PROGRESS.md"


# ── I16: extension server vs implementation  [verify-then-write] ─────────────
I16_URL=$(gh issue create \
  --repo PandABlocks/PandABlocks-server \
  --title "docs: verify extension.rst against the current server implementation and rewrite reference/extension" \
  --label "docs-rewrite,verify-then-write" \
  --body "$(cat << 'BODY'
## Target page

`reference/extension`

The page is a full stub — the source (`extension.rst`) is flagged as outdated
and needs verification against the current implementation before it can be
converted.

## Category: verify-then-write

## What a human must do (~3–4 hours)

1. Read `docs/_legacy_rst/extension.rst` (739 words: Extension Modules,
   Injected Values).
2. Compare against the current server source code for the extension server
   (socket protocol, injected value names, lifecycle hooks).
3. Identify:
   - What has changed since the doc was written.
   - What is still accurate and can be kept.
   - What is missing (new injected values, new API calls).
4. Write the updated `reference/extension.md` with verified content.

Post as a PR against the `docs` branch.

## Source

`docs/_legacy_rst/extension.rst` — 739 words (Extension Modules, Injected
Values).
BODY
)")
I16=$(num "$I16_URL")
echo "  server#$I16: extension server"

sed -i "s|**Blocked:** a GitHub issue will be created in Stage B (Prompt B) and linked here\.|**Blocked:** [PandABlocks/PandABlocks-server#$I16]($I16_URL)|" \
  "$SERVER/docs/reference/extension.md"

sed -i "s|⛔ reference/extension — issue #TBD — verify|⛔ reference/extension — issue #$I16 — verify|" "$SERVER/docs/PROGRESS.md"


# ── I17: *IDN? v4.x  [verify-then-write] ─────────────────────────────────────
I17_URL=$(gh issue create \
  --repo PandABlocks/PandABlocks-server \
  --title "docs: verify *IDN? response format is unchanged in v4.x and update example" \
  --label "docs-rewrite,verify-then-write" \
  --body "$(cat << 'BODY'
## Target page

`reference/commands`

The `*IDN?` example in the "System commands" section shows a response from an
older firmware version.  The backlog flags this as needing verification for v4.x.

## Category: verify-then-write

## What a human must do (~1 hour)

1. Run `*IDN?` against a v4.x PandA server.
2. Confirm whether the response format has changed (fields, order, version
   string format).
3. Update the code-block example with a representative v4.x response.
4. If the format is strictly unchanged, add a note stating "unchanged since
   v3.x" so future maintainers know it was verified.

Post findings as a comment or PR against `docs/reference/commands.md`.

## Source

`docs/reference/commands.md` — "System commands" section, `*IDN?` example.
Current example: `OK =PandA SW: 330bd94-dirty FPGA: 0.1.9 d1275f61 00000000`
BODY
)")
I17=$(num "$I17_URL")
echo "  server#$I17: *IDN? v4.x"

# Add a verify comment after the *IDN? code block
sed -i "s|> OK =PandA SW: 330bd94-dirty FPGA: 0.1.9 d1275f61 00000000|> OK =PandA SW: 330bd94-dirty FPGA: 0.1.9 d1275f61 00000000 <!-- verify: PandABlocks/PandABlocks-server#$I17 — confirm *IDN? format unchanged in v4.x -->|" \
  "$SERVER/docs/reference/commands.md"

sed -i "s|^## Notes$|- ⛔ reference/commands (*IDN? v4.x) — issue #$I17 — verify\n\n## Notes|" "$SERVER/docs/PROGRESS.md"


# ── I18: CONFIG syntax  [verify-then-write] ───────────────────────────────────
I18_URL=$(gh issue create \
  --repo PandABlocks/PandABlocks-server \
  --title "docs: verify and document the CONFIG file syntax for how-to/building" \
  --label "docs-rewrite,verify-then-write" \
  --body "$(cat << 'BODY'
## Target page

`how-to/building`

The "Setting up the CONFIG file" section defers to `CONFIG.example` and notes
"The exact syntax accepted by the server Makefile for CONFIG values is pending
verification (tracked in the issue backlog)."

## Category: verify-then-write

## What a human must do (~1–2 hours)

1. Review the server `Makefile` for all CONFIG variable names it reads and
   their accepted forms (e.g. `BINUTILS_DIR`, `PYTHON`, `COTHREAD`, etc.).
2. Confirm whether the values are paths, flags, or version strings.
3. Document any non-obvious syntax or gotchas (e.g. trailing slash required,
   quoted vs unquoted paths).
4. Replace the deferral note in `how-to/building.md` with the verified
   information.

Post findings as a comment or PR.

## Source

`docs/how-to/building.md` — "Setting up the CONFIG file" section.
`docs/_legacy_rst/building.rst` — 493 words with the CONFIG table.
BODY
)")
I18=$(num "$I18_URL")
echo "  server#$I18: CONFIG syntax"

# Update the note that says "pending verification (tracked in the issue backlog)"
sed -i "s|pending verification (tracked in the issue backlog)\.|pending verification — tracked in [PandABlocks/PandABlocks-server#$I18]($I18_URL).|" \
  "$SERVER/docs/how-to/building.md"

sed -i "s|^## Notes$|- ⛔ how-to/building (CONFIG syntax) — issue #$I18 — verify\n\n## Notes|" "$SERVER/docs/PROGRESS.md"


# ── I19: C coding standard  [author-from-scratch] ────────────────────────────
I19_URL=$(gh issue create \
  --repo PandABlocks/PandABlocks-server \
  --title "docs: author the C coding standard for reference/c-standard" \
  --label "docs-rewrite,author-from-scratch" \
  --body "$(cat << 'BODY'
## Target page

`reference/c-standard`

No source exists — this is new content identified in Interview1 §4 as needed
for server contributors.

## Category: author-from-scratch

## What a human must do (~4 hours)

Write the C coding standard for PandABlocks server contributors, covering at
minimum:

1. **Naming conventions** — functions, variables, macros, types (typedef'd
   structs, enums).
2. **File structure** — header guard style, include order, `extern "C"` guards.
3. **Error handling** — return-code conventions, `errno` usage, logging macros.
4. **Memory management** — ownership rules, allocation patterns, common pitfalls
   in the server's context.
5. **Comment style** — what warrants a comment; doxygen vs plain C comments.
6. **Formatting** — indentation (tabs/spaces), brace placement, line length.
7. **Project-specific idioms** — any server-specific patterns (e.g. lock/unlock
   wrappers, the config vs data thread boundary).

Post as a PR against `docs/reference/c-standard.md` on the `docs` branch.
BODY
)")
I19=$(num "$I19_URL")
echo "  server#$I19: C standard"

sed -i "s|**Blocked:** a GitHub issue will be created in Stage B (Prompt B) and linked here\.|**Blocked:** [PandABlocks/PandABlocks-server#$I19]($I19_URL)|" \
  "$SERVER/docs/reference/c-standard.md"

sed -i "s|⛔ reference/c-standard — issue #TBD — author|⛔ reference/c-standard — issue #$I19 — author|" "$SERVER/docs/PROGRESS.md"


# ── I20: server architecture depth  [author-from-scratch] ────────────────────
I20_URL=$(gh issue create \
  --repo PandABlocks/PandABlocks-server \
  --title "docs: author detailed server architecture internals for explanations/architecture" \
  --label "docs-rewrite,author-from-scratch" \
  --body "$(cat << 'BODY'
## Target page

`explanations/architecture`

A skeleton has been written covering the two TCP sockets, the config/data thread
split, and the block model at a high level.  The depth items are deferred:
locking strategy, DMA pipeline, persistence state machine.

## Category: author-from-scratch

## What a human must do (~4–6 hours)

Expand the skeleton in `explanations/architecture.md` to cover the internals
that matter to contributors and extension developers:

1. **Thread model** — which threads exist, what each does, how they communicate
   (queues, mutexes, condition variables).
2. **Locking strategy** — what lock(s) protect shared state; any lock ordering
   rules; known contention points.
3. **DMA pipeline** — how captured data flows from FPGA registers through the
   DMA ring buffer to the data socket.
4. **Persistence / state machine** — how the server saves and restores block
   configuration; when config is written to hardware vs held in memory.
5. **Extension server integration** — how extension modules register and receive
   injected values (link to `reference/extension`).

A diagram (ASCII or SVG) of the thread/data-flow architecture would be very
helpful.

Post as a PR against `docs/explanations/architecture.md` on the `docs` branch.

## Source

`docs/explanations/architecture.md` — existing skeleton.
Server source code (C) is the primary reference.
BODY
)")
I20=$(num "$I20_URL")
echo "  server#$I20: architecture depth"

# Update the admonition that says "tracked in the issue backlog as **blocked: author**."
sed -i "s|tracked in the issue backlog as \*\*blocked: author\*\*\.|tracked in [PandABlocks/PandABlocks-server#$I20]($I20_URL) (**blocked: author**).|" \
  "$SERVER/docs/explanations/architecture.md"

sed -i "s|^## Notes$|- ⛔ explanations/architecture (depth) — issue #$I20 — author\n\n## Notes|" "$SERVER/docs/PROGRESS.md"


# ── Commit server changes ─────────────────────────────────────────────────────
echo ""
echo "  Committing server Stage B edits..."
git -C "$SERVER" add docs/reference/capture-options.md \
                     docs/reference/capture.md \
                     docs/reference/extension.md \
                     docs/reference/commands.md \
                     docs/reference/c-standard.md \
                     docs/how-to/building.md \
                     docs/explanations/architecture.md \
                     docs/PROGRESS.md
git -C "$SERVER" commit -m "$(cat << 'MSG'
docs: Stage B — link GitHub issues into stubs and verify notes
MSG
)"


# ─────────────────────────────────────────────────────────────────────────────
# Summary
# ─────────────────────────────────────────────────────────────────────────────
echo ""
echo "=== Stage B complete — issues created ==="
echo ""
echo "PandABlocks/meta-panda:"
echo "  #$I1  tutorials 3+4 screenshots         [human-capture]"
echo "  #$I2  widget screenshots + sentence      [human-capture]"
echo "  #$I3  3.0→4.0 breaking changes           [verify-then-write]"
echo "  #$I4  machine-target hardware details     [verify-then-write]"
echo "  #$I5  KAS_IMAGE_VERSION mapping          [verify-then-write]"
echo "  #$I6  legacy zpg filename                [verify-then-write]"
echo "  #$I7  Xilinx branch post-5.0             [verify-then-write]"
echo "  #$I8  hardware-target descriptions       [author-from-scratch]"
echo "  #$I9  versioned docs / version switcher  [infrastructure]"
echo ""
echo "PandABlocks/PandABlocks-FPGA:"
echo "  #$I10 testing CI update                  [verify-then-write]"
echo "  #$I11 cocotb IP assumption               [verify-then-write]"
echo "  #$I12 VHDL coding standard               [author-from-scratch]"
echo "  #$I13 MyST block-listing + block-doc     [tooling]  *"
echo ""
echo "PandABlocks/PandABlocks-server:"
echo "  #$I14 capture-options superset           [verify-then-write]"
echo "  #$I15 60 MB/s figure                     [verify-then-write]"
echo "  #$I16 extension server vs implementation [verify-then-write]"
echo "  #$I17 *IDN? v4.x                         [verify-then-write]"
echo "  #$I18 CONFIG syntax                      [verify-then-write]"
echo "  #$I19 C coding standard                  [author-from-scratch]"
echo "  #$I20 server architecture depth          [author-from-scratch]"
echo ""
echo "* I13 is from the FPGA PROGRESS.md stub promises, not the 03 backlog."
echo "  All others are from the 03-target-doc-map.md Issue backlog section."
