# Web-Control / GUI Documentation — Decisions

Destination: **meta-panda** (web-control / GUI docs).
Scope: decisions captured for resolving the gaps found in the gap analysis of the
web-control documentation extracted from the legacy MalcolmJS docs.

---

## 1. GUI URL and port

- The correct address is the **PandA's own IP or hostname on port 80** (as in
  `quickstart.rst` / `web-interface.rst`); that is what a real deployed user should type.
- The `http://{malcolm host}/gui/` form with `localhost:3000` is a **MalcolmJS dev-docs
  artifact** — it came from testing against a localhost deployment.
- That localhost / `:3000` form should **never appear in the user-facing docs**; it is
  purely a development detail.

## 2. Attribute-state icons (`understanding_attribute_state.rst`)

- The icon assets and the missing "table above" are **not worth chasing** — this is
  low-value content.
- Resolution: **describe the three states in text** (Processing, Update Error,
  Disconnected) rather than sourcing or recreating icon images.
- Take the **simplest approach** — drop the `*GET IMAGE*` placeholders and the
  "table above" reference entirely, replacing them with brief text descriptions of what
  each state means.
- The text will describe each state **functionally** (what it signifies to the user)
  rather than the literal glyph, since the source images are unavailable.

## 3. Design-page screenshots and unfinished sentence (`working_with_a_design.rst`)

- The screenshots (View/Edit, Dropdown List, Text Input, Checkbox) should come from a
  **live GUI** — not text descriptions like the icons.
- Capturing them is a **human task**, flagged for someone with a running PandA to grab;
  each `*GET SCREENSHOT*` / `*GET SCREENHOST*` spot is marked as a **TODO** rather than
  resolved now.
- The unfinished Text Input sentence ("shown in the .") almost certainly trailed off into
  a reference to that missing screenshot (e.g. "…shown in the screenshot below"), so it is
  **folded into the same human task** — the wording gets finished once the screenshot
  exists.

## 4. Naming / terminology

- **PandA Web Control** is technically a **pymalcolm backend + MalcolmJS frontend**, but
  that stack is an **implementation detail only**.
- The stack is **stable but no longer used outside PandA**, and is slated for replacement
  in the medium term — so for now only **minimal changes for consistency** are wanted, not
  a rewrite.
- meta-panda docs must **never mention** `malcolm`, `pymalcolm`, or MalcolmJS.
- Standardise on **"PandA Web Control"** as the one correct term throughout.

---

## Action items / human tasks

- [ ] **Human task:** on a running PandA, capture live-GUI screenshots for
  `working_with_a_design.rst`: View/Edit, Dropdown List, Text Input, Checkbox.
- [ ] **Human task:** once the Text Input screenshot exists, finish the trailing
  "shown in the ." sentence to reference it.
- [ ] Replace `understanding_attribute_state.rst` `*GET IMAGE*` placeholders + "table
  above" reference with short functional text for Processing, Update Error, Disconnected.
- [ ] Fix all GUI-address references to the PandA IP/hostname on port 80; remove every
  `localhost:3000` / `/gui/` dev artifact.
- [ ] Replace all `malcolm` / `pymalcolm` / MalcolmJS references with "PandA Web Control".
