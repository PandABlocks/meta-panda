```{include} ../../.github/CONTRIBUTING.md
```

## Cross-repository references

This project uses [MyST](https://mystmd.org/) for documentation.  Cross-links
to other PandABlocks repos (and to `PandABlocks-client` / `fastcs-PandABlocks`)
are configured in `docs/myst.yml` under `project.references`.

### Adding a cross-link

To link to a page in another PandABlocks repo:

```markdown
[link text](xref:<repo-key>#<target-id>)
```

For example, to link to the `BlockingClient` API in `PandABlocks-client`:

```markdown
[`BlockingClient`](xref:PandABlocks-client#pandablocks.blocking.BlockingClient)
```

### Available reference targets

| Key | Repo | Type |
|---|---|---|
| `PandABlocks-client` | `PandABlocks-client` | Sphinx (`objects.inv`) |
| `PandABlocks-FPGA` | `PandABlocks-FPGA` | MyST (`myst.xref.json`) |
| `PandABlocks-server` | `PandABlocks-server` | MyST (`myst.xref.json`) |
| `PandABlocks-devcontainer` | `PandABlocks-devcontainer` | MyST (`myst.xref.json`) |
| `fastcs-PandABlocks` | `fastcs-PandABlocks` | Sphinx (`objects.inv`) |

The `PandABlocks-FPGA`, `PandABlocks-server`, `PandABlocks-devcontainer` and
`fastcs-PandABlocks` entries are present in `myst.yml` but commented out until
those repos publish their `docs` branches.  Uncomment the relevant line once the
target site is live (Stage F).

### Upstreaming to the copier template

The `project.references` block in `docs/myst.yml` is a prototype intended for
upstreaming into the
[python-copier-template](https://github.com/DiamondLightSource/python-copier-template).
When upstreaming, verify that the URL format and key names are consistent with
any MyST version changes since Stage A.
