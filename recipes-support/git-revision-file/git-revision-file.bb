# This was provided by divhart in stackoverflow question 52729727
LICENSE = "MIT"
SUMMARY = "Place a git revision file in the sysroot"

inherit image-buildinfo

REVISION_INFO_FILE = "git-revision"
S = "${WORKDIR}"
PV = "${AUTOREV}"

do_configure[nostamp] = "1"

do_configure() {
    git -C ${THISDIR} describe --abbrev=7 --dirty --always --tags > ${S}/${REVISION_INFO_FILE}
}

do_install() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${S}/${REVISION_INFO_FILE} ${D}${sysconfdir}
}

FILES:${PN} = "${sysconfdir}"
