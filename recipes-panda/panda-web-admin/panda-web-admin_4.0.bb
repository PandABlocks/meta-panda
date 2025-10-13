SUMMARY = "PandABlocks-web-admin"
LICENSE = "Apache-2.0"
LIC_FILES_CHKSUM = "file://${COMMON_LICENSE_DIR}/Apache-2.0;md5=89aea4e17d99a7cacdbeed46a0096b10"

FILESEXTRAPATHS:prepend := "${THISDIR}/files:${THISDIR}/../../:"
SRC_URI = " \
    file://panda-web-admin.socket \
    file://panda-web-admin.service \
    file://panda-web-admin.py \
    file://rootfs-version.sh \
    file://static/favicon.ico \
    file://static/PandA-logo-for-black-background.svg \
    file://static/style.css \
    file://templates/button.html \
    file://templates/docs.html \
    file://templates/drawer.html \
    file://templates/form_select.html \
    file://templates/header.html \
    file://templates/footer.html \
    file://templates/index.html \
    file://templates/nav.html \
    file://panda-webcontrol.service \
    file://panda-webcontrol-wrapper \
    file://panda-webcontrol.py \
    file://panda-webcontrol.nav.html \
    file://meta-panda.docs.html \
    file://README.rst \
    file://docs/images/PandA-logo.ico \
    file://docs/images/tutorial1_bits.png \
    file://docs/images/tutorial1_pulse.png \
    file://docs/images/PandA-logo-for-black-background.svg \
    file://docs/images/tutorial2_pcap.png \
    file://docs/images/tutorial2_layout.png \
    file://docs/images/favicon.ico \
    file://docs/images/tutorial1_layout.png \
    file://docs/images/tutorial2_positions.png \
    file://docs/how-to.rst \
    file://docs/tutorials/tutorial1_blinking_leds.rst \
    file://docs/tutorials/manual-build.rst \
    file://docs/tutorials/tutorial4_snake_scan.rst \
    file://docs/tutorials/template_tutorial2_pcap.json \
    file://docs/tutorials/tutorial2_position_capture.rst \
    file://docs/tutorials/tutorial3_position_compare.rst \
    file://docs/tutorials/tutorial2.timing.ini \
    file://docs/tutorials/template_tutorial1_leds.json \
    file://docs/how-to/packages.rst \
    file://docs/how-to/remote.rst \
    file://docs/how-to/build.rst \
    file://docs/how-to/quickstart.rst \
    file://docs/how-to/web-interface.rst \
    file://docs/how-to/run-container.rst \
    file://docs/how-to/make-release.rst \
    file://docs/_static/css/custom.css \
    file://docs/index.rst \
    file://docs/explanations/boot-process.rst \
    file://docs/tutorials.rst \
    file://docs/explanations.rst \
    file://docs/reference.rst \
    file://docs/conf.py \
    file://docs/reference/opkg.rst \
    file://docs/webcontrol/build_popping_screenshot.js \
    file://docs/webcontrol/malcolm-logo.svg \
    file://docs/webcontrol/index.rst \
    file://docs/webcontrol/contents.rst \
    file://docs/webcontrol/conf.py \
    file://docs/webcontrol/malcolm-logo.png \
    file://docs/webcontrol/requirements.txt \
    file://docs/webcontrol/userguide/user_interface_overview.rst \
    file://docs/webcontrol/userguide/working_with_a_design.rst \
    file://docs/webcontrol/userguide/index.rst \
    file://docs/webcontrol/userguide/glossary.rst \
    file://docs/webcontrol/userguide/monitoring_attribute_values.rst \
    file://docs/webcontrol/userguide/images \
    file://docs/webcontrol/userguide/images/error_icon.png \
    file://docs/webcontrol/userguide/images/ui_schematic.png \
    file://docs/webcontrol/userguide/images/put_process.svg \
    file://docs/webcontrol/userguide/images/system_context.svg \
    file://docs/webcontrol/userguide/images/disconnected_icon.png \
    file://docs/webcontrol/userguide/images/attribute_lifecycle.svg \
    file://docs/webcontrol/userguide/images/information_icon.png \
    file://docs/webcontrol/userguide/images/design_context.png \
    file://docs/webcontrol/userguide/images/locally_edited_icon.png \
    file://docs/webcontrol/userguide/images/warning_icon.png \
    file://docs/webcontrol/userguide/screenshots \
    file://docs/webcontrol/userguide/screenshots/attribute_view_chart.png \
    file://docs/webcontrol/userguide/screenshots/attribute_table.png \
    file://docs/webcontrol/userguide/screenshots/block-list.png \
    file://docs/webcontrol/userguide/screenshots/popping-1.png \
    file://docs/webcontrol/userguide/screenshots/starting-ui.png \
    file://docs/webcontrol/userguide/screenshots/window_popping_output.svg \
    file://docs/webcontrol/userguide/screenshots/continuous_plot.png \
    file://docs/webcontrol/userguide/screenshots/PANDA-layout-spread-out.png \
    file://docs/webcontrol/userguide/screenshots/window_popping_template.svg \
    file://docs/webcontrol/userguide/screenshots/PANDA-block-details.png \
    file://docs/webcontrol/userguide/screenshots/PANDA-layout.png \
    file://docs/webcontrol/userguide/screenshots/popping-4.png \
    file://docs/webcontrol/userguide/screenshots/popping-3.png \
    file://docs/webcontrol/userguide/screenshots/panel_popping.png \
    file://docs/webcontrol/userguide/screenshots/layout-button.png \
    file://docs/webcontrol/userguide/screenshots/popping-2.png \
    file://docs/webcontrol/userguide/screenshots/attribute_value_table.png \
    file://docs/webcontrol/userguide/screenshots/chart_options.png \
    file://docs/webcontrol/userguide/screenshots/example-ui.png \
    file://docs/webcontrol/userguide/screenshots/PANDA-new-link.png \
    file://docs/webcontrol/userguide/contents.rst \
    file://docs/webcontrol/userguide/understanding_attribute_state.rst \
    file://docs/webcontrol/userguide/quick-start.rst \
    file://docs/webcontrol/malcolm-logo.ico \
    file://docs/webcontrol/copy_screenshots_from_e2e.js \
    file://docs/webcontrol/_templates/page.html \
    file://docs/webcontrol/_templates/layout.html \
    file://docs/webcontrol/_static/theme_overrides.css \
"
S = "${WORKDIR}"

inherit python3native
DEPENDS = " \
    python3-docutils-native \
    python3-jinja2-native \
    python3-requests-native \
    python3-six-native \
    python3-sphinx-native \
    python3-sphinx-rtd-theme-native \
"
RDEPENDS:${PN} = " \
    bash \
    python3-cothread \
    python3-numpy \
    python3-panda-malcolm \
    python3-tornado \
"

inherit systemd
SYSTEMD_SERVICE:${PN} = " \
    panda-web-admin.socket \
    panda-web-admin.service \
    panda-webcontrol.service \
"
SYSTEMD_AUTO_ENABLE:${PN} = "enable"

do_install() {
    install -d ${D}/${systemd_system_unitdir} ${D}/${bindir}
    install -d ${D}/${datadir}/web-admin
    install -m 0644 ${WORKDIR}/panda-web-admin.socket ${D}/${systemd_system_unitdir}
    install -m 0644 ${WORKDIR}/panda-web-admin.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/panda-web-admin.py ${D}/${bindir}
    install -m 0755 ${WORKDIR}/rootfs-version.sh ${D}/${bindir}
    cp -r ${WORKDIR}/templates ${D}/${datadir}/web-admin
    cp -r ${WORKDIR}/static ${D}/${datadir}/web-admin
    # Webcontrol part
    install -m 0644 ${WORKDIR}/panda-webcontrol.service ${D}/${systemd_system_unitdir}
    install -m 0755 ${WORKDIR}/panda-webcontrol.py ${D}/${bindir}
    install -m 0755 ${WORKDIR}/panda-webcontrol-wrapper ${D}/${bindir}
    install -m 0755 ${WORKDIR}/panda-webcontrol.py ${D}/${bindir}
    mkdir -p ${D}/opt/etc/www
    install -m 0644 ${WORKDIR}/panda-webcontrol.nav.html ${D}/opt/etc/www
    install -m 0644 ${WORKDIR}/meta-panda.docs.html ${D}/opt/etc/www
    export VERSION=${PV}
    python3 -m sphinx -b html ${WORKDIR}/docs ${D}/opt/share/www/meta-panda
}

FILES:${PN} += " \
    ${bindir} \
    ${datadir} \
    /opt/etc/www \
    /opt/share/www \
"
