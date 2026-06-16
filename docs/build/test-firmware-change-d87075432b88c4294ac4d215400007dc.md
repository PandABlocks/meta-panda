# Test firmware changes on a PandA

This guide covers the workflow for building and deploying server or FPGA
firmware changes to a live PandA for manual testing.

## Simulation-mode testing (server)

Server changes can be unit-tested natively in **simulation mode** — no PandA
required.  The only dependencies are `make` and `gcc`.

```bash
cd PandABlocks-server
make sim
```

Simulation mode runs the server against a software model of the block
hardware.  See the
[PandABlocks-server documentation](https://github.com/PandABlocks/PandABlocks-server)
for the full test flow.

## Live testing with `devtool` (server and FPGA)

To test changes against real hardware, use the Yocto `devtool` workflow inside
the `kas` build container:

1. Open a shell in the `kas` container:

   ```bash
   KAS_MACHINE=<machine> kas-container --ssh-agent shell kas.yml
   ```

:::{note}
Make sure there is disk space for the build files, an alternative build path
can be specified with the environment variable KAS\_WORK\_DIR.
:::

2. Use `devtool` to build an updated package in the Yocto workspace:

   ```bash
   devtool modify <recipe-name>
   # make your changes in the workspace source tree
   devtool build <recipe-name>
   ```

3. Deploy the built `.ipk` to the PandA:

   ```bash
   devtool deploy-target <recipe-name> root@<panda-hostname>
   ```

4. Restart the relevant service on the PandA:

   ```bash
   ssh root@<panda-hostname> systemctl daemon-reload
   ssh root@<panda-hostname> systemctl restart <service-name>
   ```

5. Test your changes on the live hardware.

## Deploying a custom FPGA bitstream

To test a custom FPGA bitstream:

1. Build the `.ipk` containing the bitstream in
   [PandABlocks-FPGA](https://github.com/PandABlocks/PandABlocks-FPGA)
   (see the FPGA repo docs).

2. Install it on the PandA:

   ```bash
   scp panda-fpga_<version>.ipk root@<panda-hostname>:/tmp/
   ssh root@<panda-hostname> opkg install --force-reinstall /tmp/panda-fpga_<version>.ipk
   ```

3. Override the active bitstream if needed — see {doc}`choose-fpga-bitstream`.

4. Restart the relevant service:

   ```bash
   ssh root@<panda-hostname> systemctl restart panda-fpga
   ```
