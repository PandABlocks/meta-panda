# This was provided by divhart in stackoverflow question 52729727
LICENSE = "MIT"
SUMMARY = "Place a git revision file in the sysroot"

inherit image-buildinfo

REVISION_INFO_FILE = "git-revision"
S = "${WORKDIR}"
PV = "${AUTOREV}"

do_configure[nostamp] = "1"

python do_configure() {
    full_path = d.expand("${S}/${REVISION_INFO_FILE}")

    with open(full_path, 'w') as file:
        file.write(get_layer_revs(d).split()[2])
}

do_install() {
    install -d ${D}${sysconfdir}
    install -m 0644 ${S}/${REVISION_INFO_FILE} ${D}${sysconfdir}
}

FILES_${PN} = "${sysconfdir}"
