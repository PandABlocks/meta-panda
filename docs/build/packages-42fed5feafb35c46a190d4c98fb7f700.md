# Install packages via opkg

PandA uses [opkg](https://openwrt.org/docs/guide-user/additional-software/opkg)
to manage application software.  Packages are distributed as `.ipk` files whose
names follow the convention `<package>_<version>.ipk`.

## Install via the web admin interface

1. Place the `.ipk` file(s) on a USB stick.
2. Insert the USB stick into the PandA.
3. Open the web admin interface at `http://<panda-hostname>/admin/`.
4. Navigate to **Packages → Install Packages from USB**.
5. Browse to the `.ipk` file and click **Install Selected**.

## Install over SSH

Copy the `.ipk` to the PandA and install it with `opkg`:

```bash
scp panda-fpga_<version>.ipk root@<panda-hostname>:/tmp
ssh root@<panda-hostname> opkg install /tmp/panda-fpga_<version>.ipk
```

Replace `panda-fpga_<version>.ipk` with the actual filename.
