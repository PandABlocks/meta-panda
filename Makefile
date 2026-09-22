# meta-panda is a Yocto/kas layer with no compiled build of its own; this Makefile
# exists only to drive the documentation build the same way as the other
# PandABlocks repos (`make docs`).
#
# Docs are built with MyST (mystmd), run on demand through npx so no global install
# is needed; pin the version with MYSTMD_VERSION (see CONFIG.example). MyST writes
# its output into docs/_build/html. --strict exits non-zero on any error-severity
# message (e.g. an unresolved cross-repo xref) so CI fails rather than publishing
# broken links.

# The CONFIG file is required. If not present, create by copying CONFIG.example.
include CONFIG

MYST = npx --yes --package mystmd@$(MYSTMD_VERSION) myst

docs:
	cd docs && $(MYST) build --html --strict

docs-dev:
	cd docs && $(MYST) start

clean-docs:
	rm -rf docs/_build

.PHONY: docs docs-dev clean-docs
