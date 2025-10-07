What does the rootfs do?
========================

The rootfs is responsible for booting the Zynq, then setting up a number of services on it:

- Bringing up the network as specified in a config.txt file on the SD card
- Running an SSH server that allows debugging access to those who have their public keys on the PandA
- Programming the FPGA and running services like the TCP server and Web Control as specified in packages
- Running a Web Admin server on port 80 that allows IPK files to allow the installation and removal of packages, and addition of SSH keys from the USB stick

How the documentation is structured
-----------------------------------

.. toctree::
    :caption: Rootfs Documentation

    how-to/building
    how-to/remote
    how-to/quickstart

.. toctree::
    :caption: Webcontrol Overview

    webcontrol/index

.. toctree::
    :caption: Webcontrol User Guide

    webcontrol/userguide/quick-start
    webcontrol/userguide/user_interface_overview
    webcontrol/userguide/working_with_a_design
    webcontrol/userguide/monitoring_attribute_values
    webcontrol/userguide/understanding_attribute_state

.. toctree::
    :caption: Webcontrol Reference

    webcontrol/userguide/glossary

