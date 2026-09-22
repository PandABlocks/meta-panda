.. _web_doc:

Updating a PandA via web interface
==================================

To update the firmware installed on a PandA, it is recommended to use the Web Admin
interface. To do this you will need physical access to the PandA and a USB memory 
stick with the new firmware copied onto it. You can find the latest firmware from
GitHub_.

Information about updating a PandA by SSH can be found in the :ref:`ssh_doc`.

The Web Interface of a PandA is accessible by typing its ip address or hostname into
a browser.


Updating the rootfs
-------------------

On the Web Admin interface, Navigate to Admin on the bottom banner. You will then be
able to read your current Version information.

On a memory stick you will need the ``boot-{MACHINE}.tar.gz``  file from GitHub_. There is no
need to unzip it.

With a prepared USB memory stick inserted in the USB slot in the back of a PandA, 
navigate to Packages under Admin Commands and then Install Rootfs from USB. You can
select your zip file from the list and follow the on screen instructions to install
your new version of the rootfs.

.. note::
    If you are installing a major upgrade to the rootfs, it is recommended to 
    uninstall all the installed zpkgs before upgrading the rootfs. From PandA v4.0 an
    option is available to do this as part of the rootfs install.

You can power cycle the box and it will install the new rootfs.
