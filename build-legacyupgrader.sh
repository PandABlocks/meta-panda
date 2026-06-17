#!/usr/bin/env bash

function error {
  echo "$1" >&2
  exit 1
}

boot_file="$1"
output_file="$2"

if [[ -z "$output_file" ]]; then
  echo "Usage: $0 <boot-file> <output-file>"
  exit 1
fi

# Create a temporary directory for the upgrader
temp_dir=$(mktemp -d)
mkdir -p "$temp_dir/boot/"
tar -xvz -f "$boot_file" -C "$temp_dir/boot/" || error "Failed to extract boot file"
mkdir -p "$temp_dir/etc/rc.d/"
cat <<- 'EOF' > "$temp_dir/etc/rc.d/S01-legacyupgrader.sh"
    #!/bin/sh
    rm -f /boot/uImage /boot/uinitramfs /boot/devicetree.dtb
    cp -f /opt/boot/* /boot/
    mkdir -p /boot/state/designs
    cp -rf /opt/share/designs/* /boot/state/designs/
    sync
    reboot
EOF

chmod 755 "$temp_dir/etc/rc.d/S01-legacyupgrader.sh"

tar -cz --owner=0 --group=0 -C "$temp_dir" -f "$temp_dir/legacyupgrader.tar" boot etc
mv "$temp_dir/legacyupgrader.tar" "$output_file"
