SUMMARY = "Annotypes python package"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://LICENSE;md5=86d3f3a95c324c9479bd8986968f4327"

inherit pypi setuptools3

SRC_URI += "file://0001-Workaround-for-broken-find_caller_class-in-python3.10.patch"
SRC_URI[sha256sum] = "b330a35b7ae25ab97741dc40c0fb9c6ce64204a7f100e83d70655e5815dda650"
PYPI_PACKAGE = "annotypes"
