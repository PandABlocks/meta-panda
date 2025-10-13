#!/usr/bin/env bash
cd "$(dirname "$0")"
META_DIR="$(pwd)"

export KAS_MACHINE=${1}
export KAS_WORK_DIR=${2:-$PWD}
if [ -z "${KAS_MACHINE}" ]; then
    echo "Usage: $0 <machine> [<work_dir>]"
    exit 1
fi

function error {
    echo >&2 "$@"
    exit 1
}

kas-container build -c populate_sdk ./kas.yml || error "kas build failed"
cp -f ${KAS_WORK_DIR}/build/tmp/deploy/sdk/pandablocks-sdk-${KAS_MACHINE}.sh . || error "Failed to copy SDK installer"
