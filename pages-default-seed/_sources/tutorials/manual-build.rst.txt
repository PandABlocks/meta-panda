Long way to build the panda image
---------------------------------

If you are interested in the main way to build, go to
`build_doc`, the current document was done mainly for learning
purposes.

The following steps might need to be run in a docker container(possibly `kas`
image), if the dependencies are not available in your system.


- Use ``repo`` tool to initialise the yocto sources based on Xilinx's yocto
  manifest, this will automatically add layers like meta-xilinx and
  meta-petalinux::

    BRANCH="rel-v2023.2"
    repo init -u https://gitenterprise.xilinx.com/Yocto/yocto-manifests.git -b $BRANCH

- Load development environment passing the build directory as argument::

    . setupsdk build

- Add layer meta-panda to you yocto build::

    git clone https://github.com/PandABlocks/meta-panda ../sources/meta-panda
    bitbake-layers add-layer ../sources/meta-panda

- Set the following variables in ``conf/local.conf``:

  - ``MACHINE="pandabox"`` or ``MACHINE="xu5-s1"``

  - ``DISTRO="panda-petalinux"``

- Build panda-image by running: ``bitbake panda-image``
- Gather the output files from the deploy folder::

    mkdir boot
    cp -Lf tmp/deploy/images/pandabox/fitImage-petalinux-initramfs-image-pandabox-pandabox boot/image.ub
    cp -f tmp/deploy/images/pandabox/{rootfs.squashfs,boot.bin,boot.scr,target-defs} boot/
    zip boot-pandabox.zip boot/*
