FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " \
    file://overlayfs.cfg \
    file://squashfs.cfg \
    file://debugging-and-tracing.cfg \
"
