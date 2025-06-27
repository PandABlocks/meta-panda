require panda-server.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " \
    git://github.com/PandABlocks/PandABlocks-server;branch=master;protocol=https \
    file://CONFIG \
    file://0001-Minor-build-improvements.patch \
    file://0002-extension-server-notify-systemd.patch \
"
SRCREV = "8debbfa3b9ca964cbb583d4259917aefaa131e66"
S = "${WORKDIR}/git"
