# Session 4 — Versioning & Compatibility

Reference notes for the PandABlocks documentation rewrite. This session covers which
releases go together, migration between releases, and the device identification string.
This is cross-cutting material spanning **meta-panda** (compatibility/migration) and
**PandABlocks-server** (the `*IDN?` string).

---

## 1. Migration notes (`reference/changes.md`)

- Migration material consolidates into a single **`reference/changes.md`** in meta-panda,
  replacing per-version migration guide files (retires the github.io `migration_guide.rst`).
- This file documents **breaking changes and migration steps for every major version bump**
  (e.g. 2.0 → 3.0, 3.0 → 4.0, and onward).
- meta-panda owns this as cross-cutting reference material.
- **Open action:** no breaking changes are recalled for 3.0 → 4.0, but this **needs
  verifying** before the file is considered complete.

---

## 2. Compatibility matrix

- **Pre-5.0:** the existing compatibility rule holds — you must keep the **same major
  version number across rootfs and all zpkg files**. This matrix should be embedded
  **within each relevant section of `reference/changes.md`** rather than as a standalone
  file (retires the github.io `release_compatibility.rst`).
- **Post-5.0:** the model changes to a **single unified firmware image** to load, removing
  the multi-component version-matching problem for the common case.
- **FPGA / rootfs compatibility (resolved):** compatibility is defined as **"matching major
  version number between FPGA and meta-panda guarantees compatibility"**, and **both major
  numbers bump together on a Vivado version change** (motivating the move toward a
  Vivado-based scheme, e.g. `v2026.2`).
- **Server:** **no longer listed in the compatibility table**, because it is compiled as
  part of the Yocto rootfs.

---

## 3. The `*IDN?` identification string

- The **`*IDN?` string format is unchanged in v4.x and beyond.**
- The **`rootfs:` field still exists and correctly reports the rootfs version** (unchanged
  meaning from its 1.1 introduction).
- Authoritative description stays in **PandABlocks-server** docs (server-interface
  reference); meta-panda links to it rather than duplicating.

---

## Outstanding actions

- [ ] Verify whether there were any breaking changes between 3.0 and 4.0; populate the
  3.0 → 4.0 section of `reference/changes.md` accordingly.
