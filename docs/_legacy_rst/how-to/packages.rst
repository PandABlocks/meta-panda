IPK Packages (opkg)
==================

IPK files will be used for managing all application software. These packages are
managed with the command opkg.

 The name of a ipk file must be of the form package_version.ipk, where package
 is the package name and version identifies the package version.

Installing IPK Files
---------------------

There are two ways to maintain installed software:

1. The simplest is via the Administration web page:
  - First place the .ipk files to install on a USB stick.
  - Insert USB stick into PandA
  - Select “Install ipk files from USB” from admin page
  - Navigate to appropriate location and select package(s) to install
  - Click on “Install Selected”

2. Alternatively files can be copied directly to PandA and installed via a script, for example:

.. code-block:: bash

    scp panda-fpga_version.ipk root@panda:/tmp
    ssh root@panda opkg install /tmp/panda-fpga_version.ipk
