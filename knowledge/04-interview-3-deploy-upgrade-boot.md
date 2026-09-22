# PandABlocks Docs — Session 3: Deploy, Upgrade & Boot

Knowledge captured for the documentation rewrite. Decisions below reflect the
target architecture in which **meta-panda is the canonical home**, **PandABlocks-rootfs
is being archived** (valid content migrating to meta-panda), and the build has moved to
Yocto.

---

## 1. Package tooling (zpkg → opkg)

- Current firmware uses **opkg / `.ipk`**. **zpkg / `.zpg` is legacy (pre-5.0).** The
  cutover happened at **release 5.0**.
- **Pre-5.0:** PandABlocks-rootfs built the rootfs from `.zpg` files supplied by the
  other repos.
- **5.0 onward:** meta-panda builds the Yocto rootfs, incorporating `.ipk` packages from
  all the other repos.
- **PandABlocks-FPGA and PandABlocks-server can still build standalone `.ipk` packages**
  that load into an existing Yocto rootfs — **for testing purposes only**, not the normal
  install path. Artifact naming changed at the same time as the tooling.

## 2. Network configuration file

- **`config.txt` is the correct network-config file** and lives on the **SD card**. The
  `quickstart.rst` FAQ's `boot.txt` is wrong and must be corrected to `config.txt`.
- **`panda-config.txt` is a separate file, not an alias.** Placed on a **USB stick** it
  acts as an **override** that is picked up at boot and takes precedence over the SD-card
  `config.txt`.

## 3. SSH update guide

- **Canonical home: meta-panda.** Base it on the **opkg/`.ipk` `remote.rst`** (not the
  legacy github.io zpkg version). Remove the dangling `how-to/remote.md` toctree
  references from the archived rootfs docs.
- **The guide must cover two upgrade cases:**
  1. **pre-5.0 → 5.x** (the zpkg → Yocto/opkg transition)
  2. **post-5.0** (Yocto → Yocto)
- **Open task:** audit the `.ipk` `remote.rst` for content gaps — it's the correct
  starting point but may be incomplete.

## 4. 24V FMC EEPROM & FPGA bitstream selection

- **24V FMC EEPROM population is still required post-3.0** (v4.x and v5.x) and must stay
  in the update guide.
- It is a **one-time migration** that writes metadata into the EEPROM **permanently** —
  not per-install or per-upgrade.
- It applies **only to the 24V FMC**, a physical FMC card **produced by DLS and not used
  outside DLS**. Scope it clearly as DLS-specific; most users can ignore it.
- **Each PandABlocks-FPGA `.ipk` ships an FPGA bitstream and declares a required FMC**,
  validated by checking selected EEPROM values. This is what links EEPROM population to
  firmware selection.
- **meta-panda selects the correct FPGA image by:**
  1. honouring the **`APP` variable in `config.txt`** if set;
  2. if unset, **auto-selecting the FPGA image whose FMC requirements are satisfied** per
     the EEPROM check;
  3. **erroring if more than one image** would be satisfied.

## 5. Boot process

- The **`imagefile.cpio.gz` / SD-card repartitioning flow is superseded.** Retire the
  rootfs `building.md` "Boot Process" section along with the rest of the archived rootfs
  docs.
- **meta-panda's `boot-process.rst` (FIT image + `rootfs.squashfs`) is the canonical,
  correct boot description.**

## 6. Upgrade paths

- **Two pre-5.0 upgrade paths exist:**
  1. **Over SSH** — covered by the SSH update guide (see §3).
  2. **Web-admin** — load a **legacy updater zpg** (filename TBC) from a **USB stick**.
- **Fresh SD card install** is the standard approach for a **blank PandA**, and the
  fallback route when an in-place upgrade isn't viable.

---

## Cross-cutting documentation actions

- **meta-panda is canonical** for: the SSH update guide, the boot-process explanation, and
  the upgrade how-tos (absorbing the archived rootfs material).
- **Retire / remove from the archived rootfs docs:** the `building.md` "Boot Process"
  section, and the dangling `how-to/remote.md` toctree entries in `index.md` / `how-to.md`.
- **Fix the quickstart FAQ:** `boot.txt` → `config.txt`.
- **Treat github.io's zpkg-based `remote.rst` / `web-interface.rst` as legacy reference
  only.** Canonical procedures use opkg / `.ipk`.

## Open tasks / TBC

- [ ] Audit the opkg/`.ipk` `remote.rst` for content gaps.
- [ ] Confirm the **legacy updater zpg filename** used by the web-admin pre-5.0 path.
- [ ] Document the **legacy web-admin upgrade path** and the **fresh SD card install** in
      meta-panda.
