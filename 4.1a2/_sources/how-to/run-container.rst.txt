Run in a container
==================

A PandA Development container is available from on `Github Container reistry <https://ghcr.io/pandablocks/pandablocks-dev-container>`_.



Starting the container
----------------------

To pull the container from github container registry ::

    $ docker pull ghcr.io/pandablocks/pandablocks-dev-container:latest

To get a released version, use a numbered release instead of ``latest``.

Create three directories: 

- ``REPO_DIR``, containing all the PandA repositories

- ``VIVADO_DIR``, containing a Vivado installation

- ``BUILD_DIR``, an empty directory

The above directories will be mounted as volumes to the container as it is run with the following command:

.. code-block:: bash

    docker run --rm --net=host -it -v REPO_DIR:/repos:Z -v BUILD_DIR:/build:Z -v VIVADO_DIR:/scratch/Xilinx ghcr.io/pandablocks/pandablocks-dev-container /bin/bash

The ``/repos``, ``/build``, and ``/scratch/Xilinx`` paths describe the container directories at which the mounts occur. 

In each repo you will need to:

.. code-block:: bash

    cp CONFIG.example CONFIG

.. note::

    For the Vivado installation the container path will need to match your local system. 
    i.e. if it is located in /FPGA/Xilinx you will use VIVADO_DIR:/FPGA/Xilinx 
    and you will then need to edit CONFIG as appropriate.
