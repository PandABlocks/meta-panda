require panda-server.inc

FILESEXTRAPATHS:prepend := "${THISDIR}/files:"
SRC_URI += " \
    git://github.com/PandABlocks/PandABlocks-server;branch=master;protocol=https \
    file://CONFIG \
    file://0002-extension-server-notify-systemd.patch \
"
SRCREV = "d5a8f9cbc3aa32f2d2109fad0ca9bd86052603d7"
S = "${WORKDIR}/git"
