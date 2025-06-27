FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI:append = " file://persistent-storage-journald.conf"

do_install:append() {
    install -D -m0644 ${WORKDIR}/persistent-storage-journald.conf ${D}${systemd_unitdir}/journald.conf.d/02-persistent-storage.conf
}
