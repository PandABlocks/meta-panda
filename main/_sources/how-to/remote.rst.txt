.. _ssh_doc:

Updating a PandA via SSH
========================

The Admin interface of the PandA can be used to update the firmware as detailed
in the _web_doc, but sometimes it is necessary to update a number of
PandAs at once. The SSH interface can be used to do this.

To gain access over SSH, either add an ``authorized_keys`` file to the SD card,
or load it from USB via the Admin interface.

It is then possible to log in remotely and perform operations on the PandA.

.. warning::

    PandA only has a single user; root, and remote access is done as this user.
    Root has privileges to break the system, so be careful when running the
    commands below.

Updating the rootfs
-------------------

Download a new ``boot-{MACHINE}.tar.gz`` file from GitHub_ and extract it somewhere. You
can then::

    $ ssh root@my_panda_ip rm /boot/rootfs.squashfs
    $ scp boot-{MACHINE}/* root@my_panda_ip:/boot
    $ ssh root@my_panda_ip sync

Within /boot you should find::
    - boot.bin
    - boot.scr
    - Image
    - rootfs.squashfs
    - target-defs

You can power cycle the box and it will install the new rootfs.

.. _GitHub: https://github.com/PandABlocks/meta-panda/releases


Update 24V eeprom
-----------------

PandA 3.0 requires an update to the EEPROM of 24Vio FMC cards to do this:


    - Find the right ipmi_definition file according the the product and revision (the one for FMC24V_ is under its module folder)
    - Copy it to panda
    - Run /opt/bin/write_eeprom <path-to-ipmi-definition>
    - After writing, the script will read the EEPROM to confirm the content matches

.. _FMC24V: https://github.com/PandABlocks/PandABlocks-FPGA/blob/master/modules/fmc_24vio/ipmi_definition.ini
