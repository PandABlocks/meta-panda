# Working in a container for development

For development work (e.g. FPGA builds requiring Vivado), a
`pandablocks-dev-container` image is published on the GitHub Container
Registry.

Pull it:

```bash
docker pull ghcr.io/pandablocks/pandablocks-dev-container:latest
```

Use a numbered tag instead of `latest` to pin a specific release.

Create three host directories:

- `REPO_DIR` — containing all PandA repositories
- `VIVADO_DIR` — containing a Vivado installation
- `BUILD_DIR` — an empty scratch directory

Run the container with those directories mounted:

```bash
docker run --rm --net=host -it \
  -v REPO_DIR:/repos:Z \
  -v BUILD_DIR:/build:Z \
  -v VIVADO_DIR:/scratch/Xilinx \
  ghcr.io/pandablocks/pandablocks-dev-container /bin/bash
```

:::{note}
The mount path for Vivado inside the container must match your local path.
For example, if Vivado is at `/FPGA/Xilinx` on the host use
`-v /FPGA/Xilinx:/FPGA/Xilinx` and edit `CONFIG` accordingly.
:::

In each repository inside the container:

```bash
cp CONFIG.example CONFIG
```