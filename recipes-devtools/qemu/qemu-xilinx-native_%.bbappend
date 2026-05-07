FILESEXTRAPATHS:prepend := "${THISDIR}/${PN}:"

SRC_URI += "file://0001-fix-qemu-with-glibc-2.41plus.patch \
            file://0002-Hack-for-RHEL-not-allowing-to-mmap-low-addresses.patch \
            "

