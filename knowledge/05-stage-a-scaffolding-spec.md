# Stage A — Docs Scaffolding Spec (one-off, mystmd)

Instantiate the DLS python-copier-template docs skeleton into the three core repos as a
**one-off scaffold** (not copier-managed), producing a *building, complete-but-empty* docs tree
per repo before any content conversion. Run under Opus; output is a reviewable scaffolding PR per
repo (pure structure, no prose).

**Guiding rule:** preserve the template's structure and conventions **verbatim**; vary only the
**leaf content pages**, which the template already expects to vary per project. A reader arriving
from a copier-generated Python repo (PandABlocks-client, fastcs-PandABlocks — done later via
copier) must recognise the layout instantly.

Source skeleton: `docs/` with `myst.yml`, four Diátaxis landing pages, `index.md`, `images/`,
`explanations/decisions/` (+ `COPYME`), `how-to/contribute.md`, `reference/api.md` (+ `api.json`).

---

## 1. Kept byte-for-byte (the familiarity surface)

Do not touch these except for the per-repo header swaps in §2:

- `myst.yml` `site:` block — `template: book-theme`, the four-item `nav`, `options.logo`, `options.github_url`.
- The four landing pages `tutorials.md` / `how-to.md` / `reference.md` / `explanations.md`, each with `{toc}\n:context: children`.
- `index.md` — README `{include}` + the four-card Diátaxis grid (only the card `:link:` targets change; see §2).
- `explanations/decisions.md`, the `COPYME` ADR template, and the `pattern: explanations/decisions/*.md` glob.
- `how-to/contribute.md` — the `{include} ../../.github/CONTRIBUTING.md` (already the template's pattern; just confirm path depth per repo).
- The Reference `url:`→GitHub-releases "Release Notes" entry.

## 2. Per-repo header swaps (every repo)

In `myst.yml project:` change only:
- `title:` → repo name (`meta-panda`, `PandABlocks-FPGA`, `PandABlocks-server`).
- `github:` → repo URL.
In `site.options:` change only:
- `github_url:` → repo URL.
- `logo:` → PandABlocks logo if one exists, else keep `images/dls-logo.svg` as a placeholder (flag for swap).

## 3. Global deletes (all three core repos)

- `reference/api.md`, `reference/api.json` — Python apidoc artifacts (no analogue in these repos).
- The commented `myst-apidoc-plugin` `plugins:` block in `myst.yml`.
- `tutorials/installation.md` — pip/venv install of a Python lib.
- `how-to/run-container.md` — per the map (KAS part → `how-to/build`; dev-container part → new PandABlocks-devcontainer repo).

The Reference quadrant keeps its **shape** (landing page + Release Notes `url:`); for FPGA only, the
template's *generated* `reference/api.md` slot is replaced in-place by the *generated*
`reference/blocks.md` (see §4), so the autogen position reads the same as the Python repos' apidoc slot.

## 4. Per-repo TOC + page stubs (from target map v4)

Every listed page is created as a **TODO stub** at its final path (see §7), so the build is green and
the provenance map can point sources at pages that already exist.

### meta-panda — `project.toc`
```
- file: index.md
- file: tutorials.md
  children:
    - file: tutorials/tutorial0_connecting_to_web_control.md
    - file: tutorials/tutorial1_blinking_leds.md
    - file: tutorials/tutorial2_position_capture.md
    - file: tutorials/tutorial3_position_compare.md
    - file: tutorials/tutorial4_snake_scan.md
- file: how-to.md
  children:
    - file: how-to/quickstart.md
    - file: how-to/build.md
    - file: how-to/manual-build.md
    - file: how-to/make-release.md
    - file: how-to/packages.md
    - file: how-to/upgrade-via-ssh.md
    - file: how-to/upgrade-via-web-admin.md
    - file: how-to/use-web-control-to-set-up-a-panda.md
    - file: how-to/save-restore-design.md
    - file: how-to/monitor-attribute-values.md
    - file: how-to/integrate-with-a-panda.md
    - file: how-to/test-firmware-changes.md
    - file: how-to/choose-fpga-bitstream.md
    - file: how-to/contribute.md
- file: explanations.md
  children:
    - file: explanations/boot-process.md
    - file: explanations/architecture.md
    - file: explanations/hardware-targets.md
    - file: explanations/web-control-ui-overview.md
    - file: explanations/understanding-attribute-state.md
    - file: explanations/decisions.md
      children:
        - pattern: explanations/decisions/*.md
- file: reference.md
  children:
    - file: reference/opkg.md
    - file: reference/changes.md
    - file: reference/machine-targets.md
    - file: reference/glossary.md
    - file: reference/troubleshooting.md
    - url: https://github.com/PandABlocks/meta-panda/releases
      title: Release Notes
```
`index.md` cards → tutorials.md / how-to.md / explanations.md / reference.md (default targets are fine).

### PandABlocks-FPGA — `project.toc`
FPGA has no Tutorials quadrant in v4. Keep the four landing pages for structural parity, but the
tutorials landing stays empty with a one-line note (or drop the tutorials card+nav for FPGA — minor
per-repo call; default: keep for parity).
```
- file: index.md
- file: tutorials.md           # empty landing (parity) — note "no tutorials yet"
- file: how-to.md
  children:
    - file: how-to/app.md
    - file: how-to/block.md
    - file: how-to/testing.md
    - file: how-to/cocotb.md
    - file: how-to/build-fpga-image.md
    - file: how-to/finedelay-test.md
    - file: how-to/local-development.md       # pointer to PandABlocks-devcontainer
    - file: how-to/contribute.md
- file: explanations.md
  children:
    - file: explanations/framework.md
- file: reference.md
  children:
    - file: reference/blocks.md               # GENERATED slot (replaces api.md position)
    - <PER-BLOCK MODULE DOCS — see §5, open question>
    - file: reference/glossary.md             # links to meta-panda canonical glossary
    - file: reference/vhdl-standard.md
    - url: https://github.com/PandABlocks/PandABlocks-FPGA/releases
      title: Release Notes
```

### PandABlocks-server — `project.toc`
No Tutorials quadrant in v4; same empty-landing/parity note as FPGA.
```
- file: index.md
- file: tutorials.md           # empty landing (parity)
- file: how-to.md
  children:
    - file: how-to/startup.md
    - file: how-to/building.md
    - file: how-to/contribute.md
- file: explanations.md
  children:
    - file: explanations/architecture.md
- file: reference.md
  children:
    - file: reference/commands.md
    - file: reference/fields.md
    - file: reference/capture.md
    - file: reference/capture-options.md
    - file: reference/config.md
    - file: reference/extension.md
    - file: reference/streaming-tables.md
    - file: reference/support.md
    - file: reference/c-standard.md
    - url: https://github.com/PandABlocks/PandABlocks-server/releases
      title: Release Notes
```

### PandABlocks-devcontainer (new, minimal)
Smallest repo — README + index + a single how-to. The template's `how-to/run-container.md` is a good
base for `how-to/local-development.md` here (keep, don't delete, for this repo). Only the How-to
quadrant is populated; other quadrants may be omitted or kept empty for parity (per-repo call).

## 5. OPEN QUESTION — FPGA per-block docs (resolve as first Stage A action)

Per-block docs **must stay physically next to their `module.ini`** at `modules/<block>/<block>_doc.{rst→md}`
(42 files). They cannot be copied/moved into `docs/`. Two ways to surface them in the docs build —
**prototype both on FPGA and pick the one mystmd builds cleanly:**

- **(a) Symlink** `modules/` (or a curated view of it) into `docs/`, then `pattern:` the linked path in the TOC.
- **(b) Out-of-tree reference** — TOC/`pattern:` entries that reach `../modules/*/*_doc.md` from the `docs/`-rooted project.

Decision criteria: keeps files physically under `modules/`; keeps `myst.yml` project root at `docs/`
(template parity); builds without warnings; survives `myst build` + Pages deploy; doesn't break `xref`
target generation. Document the chosen mechanism in the FPGA scaffolding PR. (Note: the Python repos
won't hit this — their reference is apidoc — so whatever is chosen is FPGA-local and should be as
contained as possible.)

## 6. xref + intersphinx — PROTOTYPE here for upstream

Net-new (absent from the skeleton). Build it in these one-off repos as a **prototype intended for
adoption into the python-copier-template**, so the later Python repos inherit identical wiring.

- Add a `project.references:`-style block to each core repo's `myst.yml` naming the other two core
  repos + the devcontainer repo (resolving against each site's `myst.xref.json`).
- Add intersphinx-style entries for the two Sphinx repos (`PandABlocks-client`, `fastcs-PandABlocks`)
  via their `objects.inv`.
- *Exact keys per current mystmd cross-references docs* — settle during the prototype.
- **Test probe:** a real cross-link `server reference/capture` → `meta-panda reference/glossary`
  resolves in the **built** output (not just config that parses); and one link into a Sphinx repo resolves.
- Capture the working config as a candidate diff to upstream into the copier template.

## 7. Stub page convention

Each target page is created as a valid-but-empty stub so the build stays green:
- Title (`# <Page title>` from the map).
- A TODO admonition noting: status from v4 (`writable-now` / `blocked: capture|verify|author|tooling`),
  and a `Source:` line (filled by the provenance map next).
- For generated pages (`reference/blocks.md`): a placeholder note in the same spirit as the template's
  `api.md` note, with the generator wiring left as a separate `blocked: tooling` issue.

## 8. CI / Pages (not in this skeleton)

The build/deploy workflow lives outside `docs/` (the copier template ships it elsewhere) and is **not**
in the upload. Stage A must confirm or add a GitHub Actions docs build+deploy per repo. Separately:
PandABlocks-rootfs → Pages disabled; PandABlocks.github.io → single catch-all redirect (not a myst build).

## 9. Acceptance gates

Per repo:
- `myst build` exits clean (no errors); `api.md`/`api.json`/apidoc hook and the pip-install tutorial removed.
- Every v4 target page exists as a stub at its correct Diátaxis path; the four-card index and nav resolve.
- `index.md` README-include and `how-to/contribute.md` CONTRIBUTING-include both resolve.
- Reference keeps the Release Notes `url:`; FPGA's `reference/blocks.md` present in the api.md slot.
- One repo (meta-panda) deploys to GitHub Pages green via the wired workflow.

FPGA-specific:
- §5 open question resolved and documented; the 42 module-doc paths build (stub or converted), files
  still physically under `modules/`.

Cross-repo (xref prototype):
- `references` wiring added; the server→meta-panda glossary probe resolves in built output; one
  intersphinx link to a Sphinx repo resolves; config captured for upstream.

## 10. Sequencing

Stage A precedes content conversion. The provenance map is independent and can run before/parallel;
running Stage A first lets each source section in the provenance map point at a stub that already
exists at its final path.
