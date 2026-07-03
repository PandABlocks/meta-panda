# Devcontainer for meta-panda Yocto/kas builds.
# Unlike the other PandABlocks repos (which use ubuntu-devcontainer), this is
# based on the kas image, matching KAS_IMAGE_VERSION in build.sh.
FROM ghcr.io/siemens/kas/kas:4.8 AS developer

USER root

# Add any system dependencies for the developer environment here.
# npm provides npx, used by `make docs` to run mystmd on demand for the docs build.
RUN apt-get update -y && apt-get install -y --no-install-recommends \
    make \
    npm \
    && apt-get clean
