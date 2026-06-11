# Firmware Build & Release — Knowledge File (meta-panda)

> Source: documentation rewrite Session 6. This file captures decisions about the
> Yocto firmware build, release artifacts, release process, supported hardware targets,
> and the version scheme. Developer build docs live in **meta-panda**.

## 1. Canonical build path & fate of rootfs `building.md`

- **Yocto (kas) is the canonical build path** for new users in 2026. The old rootfs path
  (Diamond rootfs builder + Xilinx SDK + `CONFIG` + zpkg) is superseded.
- **rootfs `building.md` is not migrated and not kept as legacy** — the rootfs repo is
  being archived.
- **Disable the published docs/Pages for the rootfs repo** so its outdated build
  instructions are no longer visible to anyone.

## 2. Release artifact name & format

- The current release artifact is **`boot-{MACHINE}.tar.gz`** (the meta-panda `remote.rst`
  description is correct).
- Contents are **`rootfs.squashfs`** (the squashfs root filesystem) and **`Image`** (the
  kernel image), consistent with the Yocto build.
- The github.io description (`boot-x.x.zip` containing `imagefile.cpio.gz` / `uImage`) is
  **outdated** and belongs to the retired build path.

## 3. `make-release.rst` releases link

- The releases link in meta-panda's `make-release.rst` is a **copy-paste leftover** from
  the github.io copy and must be corrected.
- It should point at **`github.com/PandABlocks/meta-panda/releases`**.
- **meta-panda is the repo that cuts firmware releases**, so that is the correct releases
  page for this document.

## 4. `manual-build.rst` Xilinx manifest URL & branch

- **`gitenterprise.xilinx.com` is Xilinx's internal GitHub Enterprise host — NOT reachable
  by external/public users.** It appears in the manifest READMEs only in the
  "clone/fork to customise" sections, which is the likely source of the confusion.
- **Use the public manifest at `github.com/Xilinx/yocto-manifests`** instead, initialised
  with: `repo init -u https://github.com/Xilinx/yocto-manifests.git -b <release_version>`.
  `manual-build.rst` should swap the gitenterprise URL for this one.
- **`rel-v2023.2` is a valid public release branch** and remains the target branch for now.
- **Branch bump planned after firmware 5.0 ships** (newer Xilinx branches currently go up
  to `rel-v2025.2`).

## 5. Version scheme (PEP440 vs firmware 2.0/3.0/4.0)

- **PEP440 is the intended scheme** for meta-panda / firmware releases.
- **The patch segment is usually dropped** (e.g. `4.0`, not `4.0.0`) because patch releases
  are rare; a patch number is added only when a patch release is actually produced.
- **github.io is irrelevant to this decision** — its contents are being deleted.
- Maintainers continue to use GitHub's **"Generate release notes"** when cutting a release.

---

## Open items (gaps flagged for these build docs — need maintainer input)

These were requested but not yet authoritatively resolved. Recorded here so they aren't
lost; **do not treat the placeholders as confirmed.**

### A. Supported MACHINE targets reference

- **Confirmed `MACHINE` values:** `pandabox` (default), `xu5-s1`, `xu5-st1`, `zedboard`.
- A newer **`PandABrick`** target now also appears in 4.x release artifacts alongside
  `pandabox` and `xu5_st1` — confirm whether it should be listed as a supported `MACHINE`.
- **TODO:** add a reference table enumerating each target and its differences (SoC/module,
  intended hardware, notable feature differences). Per-target hardware descriptions are
  slated for the meta-panda front door; this build-docs table should at minimum list the
  valid `MACHINE` strings and link out to those descriptions.

### B. `KAS_IMAGE_VERSION` ↔ firmware version mapping

- `build.rst` sets `KAS_IMAGE_VERSION="4.8"` with no explanation of how it relates to the
  PandA firmware release a user is trying to build.
- **TODO:** document what `KAS_IMAGE_VERSION` selects and how a user picks the value that
  corresponds to the firmware release they want. (Not resolved in this session.)

---

## Related cleanup actions captured along the way

- meta-panda `make-release.rst` is byte-identical to the github.io copy — de-duplicate and
  fix the releases link (see §3).
- `run-container.rst` is duplicated between github.io and meta-panda (same
  `REPO_DIR`/`VIVADO_DIR`/`BUILD_DIR` mounts, same "reistry" typo) — consolidate into the
  meta-panda copy and fix the typo.
- Building-the-image guidance is currently split across rootfs `building.md` (retire, §1),
  meta-panda `build.rst` (kas/Yocto — canonical), and meta-panda `manual-build.rst`
  (manual Yocto/bitbake — fix manifest URL, §4).
