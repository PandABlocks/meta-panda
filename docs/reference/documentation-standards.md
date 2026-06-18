# Documentation standards

Conventions for authoring the PandABlocks MyST documentation. These apply to
this repository and to the sibling repos (`PandABlocks-server`,
`PandABlocks-FPGA`); cross-repo wiring is configured in each repo's
`docs/myst.yml`, and adding a new cross-link is covered in
[](/how-to/contribute.md).

## Linking

All links use plain Markdown link syntax, `[text](target)`. Leave the text
**empty** wherever the link text should simply be the title of the thing you are
linking to — MyST fills it in from the target and keeps it in sync if the
target's title later changes:

```markdown
[](/how-to/quickstart.md)        → renders as the page title
[](#explicit-target)             → renders as the heading text
```

Only supply explicit text when the surrounding sentence needs different wording.

### Choosing a target

There are three kinds of target, each available both within a repo and across
repos. Pick by *what* you are pointing at, then use the internal or cross-repo
form.

| Pointing at | Internal form | Cross-repo form |
|---|---|---|
| A whole page | `[](/path/to/page.md)` | `[](xref:repo/path/to/page)` |
| A section (heading) | `[](/path/to/page.md#heading-slug)` | `[](xref:repo/path/to/page#heading-slug)` |
| An explicit label | `[](#my-label)` / `[](/path.md#my-label)` | `[](xref:repo#my-label)` |
| A Sphinx object/label (e.g. `PandABlocks-client`) | — | `` [](xref:repo#py.object) `` or `[](xref:repo)` for the root |

### Internal links: path rules

- **Always include the `.md` extension.** An extensionless path such as
  `[](how-to/app)` is treated as an opaque URL, not a document reference: it
  will not inherit a title and silently becomes a dead link if the path is
  wrong.
- **Prefer a leading-slash, root-relative path** (`[](/how-to/app.md)`), where
  the root is the `docs/` directory. It resolves identically from any source
  file. Directory-relative paths (`[](../how-to/app.md)`) also work but are
  resolved relative to the *source file's* directory, which is easy to get
  wrong from a nested page — the most common cause of broken links here.

### Sections vs explicit labels: stability

A heading automatically gets an *implicit* target — the slugified heading text
(`## Build steps` → `build-steps`). Linking to it is fine for incidental,
nearby links, but the slug **changes whenever the heading is reworded**, and
implicit targets are not addressable across repos without naming the page.

For any link that is load-bearing, far from its target, or crossing a repo
boundary, define an **explicit label** instead and link to that:

```markdown
(capture-format)=
## Data capture wire format
```

Explicit labels are stable across rewording and file renames, and
`[](xref:repo#capture-format)` resolves **without naming the page** — so it
keeps working if the target page is later moved. Place explicit labels on
headings or captioned blocks (figures, tables); a label on a bare paragraph
inherits no useful text.

### Cross-repo (`xref:`) notes

- The `repo` key must match a key under `project.references` in `myst.yml`.
- Page and heading forms require the page path (`xref:repo/page#slug`); the slug
  is the *target* repo's heading slug and tracks both the page path and the
  heading text.
- `xref:repo#label` (no page) resolves only **explicit** labels — the preferred,
  most durable form for cross-repo anchors.
- Sphinx targets (`PandABlocks-client`, `fastcs-PandABlocks`) are addressed by
  inventory object/label name, not by page path; `xref:repo` alone links to the
  project root.

## Enforcement

`docs/myst.yml` escalates the link-quality rules `link-resolves`,
`reference-target-resolves` and `link-text-exists` to *error*, and CI builds
with `myst build --strict`. A broken link, an unresolved cross reference, or an
empty label that cannot be auto-filled therefore **fails the build** rather than
publishing a dead link.
