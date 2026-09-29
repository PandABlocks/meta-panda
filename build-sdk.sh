#!/usr/bin/env bash
cd "$(dirname "$0")"
META_DIR="$(pwd)"

export KAS_MACHINE=${1}
export KAS_WORK_DIR=${2:-$PWD}
export KAS_IMAGE_VERSION="4.8"
if [ -z "${KAS_MACHINE}" ]; then
    echo "Usage: $0 <machine> [<work_dir>]"
    exit 1
fi

function error {
    echo >&2 "$@"
    exit 1
}

# Step 1: generate the recipes that are pinned by release file rather than
# written by hand -- the FPGA ipks, and panda-server's PV/SRCREV.  Step 2 (the
# kas build below) needs both to exist.
./fetch-fpga-ipks.py || error "fetching FPGA ipks failed"
./fetch-panda-server-rev.py || error "resolving the panda-server release failed"

kas-container build -c populate_sdk ./kas.yml || error "kas build failed"
cp -f ${KAS_WORK_DIR}/build/tmp/deploy/sdk/pandablocks-sdk-${KAS_MACHINE}.sh . || error "Failed to copy SDK installer"
