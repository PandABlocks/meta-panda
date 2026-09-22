```{include} ../../.github/CONTRIBUTING.md
```

## Cross-repository references

PandABlocks docs cross-link to the other repos with MyST `xref:` links,
configured in `docs/myst.yml` under `project.references`. For the link syntax,
when to use each target type, and the list of available reference targets, see
the [documentation standards reference](/reference/documentation-standards.md).

### Upstreaming to the copier template

The `project.references` block in `docs/myst.yml` is a prototype intended for
upstreaming into the
[python-copier-template](https://github.com/DiamondLightSource/python-copier-template).
When upstreaming, verify that the URL format and key names are consistent with
any MyST version changes since Stage A.
