FROM rockylinux:8.5 AS developer
ARG MACHINE=pandabox

# Add epel repo
RUN yum -y install epel-release

# Host dependencies
RUN yum -y upgrade && yum -y install \
    bc \
    bzip2 \
    cpio \
    dbus-x11 \
    diffutils \
    expat-devel \
    fakeroot \
    gcc-gnat \
    git \
    glibc-devel \
    glibc-langpack-en \
    gnutls-devel \
    gmp-devel \
    gtkwave \
    libffi-devel \
    libmpc-devel \
    libjpeg-turbo-devel \
    libuuid-devel \
    lzop \
    llvm-devel \
    ncurses-compat-libs \
    nmap-ncat \
    openssl-devel \
    patch \
    python3-devel \
    python3-setuptools \
    python3.12-devel \
    python3.12-pip \
    readline-devel \
    sudo \
    tini \
    unzip \
    xorg-x11-server-Xvfb \
    xorg-x11-utils \
    xz \
    zlib-devel

# cocotb requires python 3.7+
RUN update-alternatives --set python /usr/bin/python3.12
RUN update-alternatives --set python3 /usr/bin/python3.12

COPY meta-panda/.github/scripts /scripts

RUN yum -y group install "Development Tools"
RUN bash scripts/GNU-toolchain.sh
# Needed for cocotb install
RUN dnf -y --enablerepo=powertools install libstdc++-static
RUN bash scripts/install-ghdl.sh
RUN bash scripts/install-nvc.sh

# For the documentation
RUN pip3 install \
    matplotlib \
    rst2pdf \
    sphinx \
    sphinx-rtd-theme \
    --upgrade docutils==0.16

# For cocotb
RUN pip3 install \
    coverage \
    vhdeps \
    pandas \
    pytest \
    git+https://github.com/cocotb/cocotb.git@6649d76

# Make sure git doesn't fail when used to obtain a tag name
RUN git config --global --add safe.directory '*'

WORKDIR /repos
CMD ["/bin/bash"]

FROM developer AS ci

# ARC setup arguments
ARG TARGETPLATFORM=linux/amd64
ARG RUNNER_VERSION=2.316.0
ARG RUNNER_CONTAINER_HOOKS_VERSION=0.6.0

# Use 1001 and 121 for compatibility with GitHub-hosted runners
# runner UID assigned to allow automatic switch to user on IRIS runners
ARG RUNNER_UID=1000
ARG DOCKER_GID=1001

# Adds runner user to sudoer, required to change file permissions during CI workflow
RUN adduser --comment "" --uid $RUNNER_UID runner \
    && groupadd docker --gid $DOCKER_GID \
    && usermod -aG wheel runner \
    && usermod -aG wheel root \
    && usermod -aG docker runner \
    && echo "%wheel   ALL=(ALL:ALL) NOPASSWD:ALL" > /etc/sudoers \
    && echo "Defaults env_keep += \"DEBIAN_FRONTEND\"" >> /etc/sudoers

# Setup actions runner controller
ENV RUNNER_ASSETS_DIR=/runnertmp
RUN export ARCH=$(echo ${TARGETPLATFORM} | cut -d / -f2) \
    && if [ "$ARCH" = "amd64" ] || [ "$ARCH" = "x86_64" ] || [ "$ARCH" = "i386" ]; then export ARCH=x64 ; fi \
    && mkdir -p "$RUNNER_ASSETS_DIR" \
    && cd "$RUNNER_ASSETS_DIR" \
    && curl -fLo runner.tar.gz https://github.com/actions/runner/releases/download/v${RUNNER_VERSION}/actions-runner-linux-${ARCH}-${RUNNER_VERSION}.tar.gz \
    && tar xzf ./runner.tar.gz \
    && rm -f runner.tar.gz \
    && ./bin/installdependencies.sh

# Install container hooks
RUN cd "$RUNNER_ASSETS_DIR" \
    && curl -fLo runner-container-hooks.zip https://github.com/actions/runner-container-hooks/releases/download/v${RUNNER_CONTAINER_HOOKS_VERSION}/actions-runner-hooks-k8s-${RUNNER_CONTAINER_HOOKS_VERSION}.zip \
    && unzip ./runner-container-hooks.zip -d ./k8s \
    && rm -f runner-container-hooks.zip

# TODO: can we cache the sdk and reuse when panda-image-sdk.inc doesn't change?
#COPY recipes-core/images/panda-image-sdk.inc /panda-image-sdk.inc
COPY pandablocks-sdk-${MACHINE}.sh /sdk.sh
RUN /sdk.sh -y -d /sdk/

# Preparation for the kernel to be able to build the panda driver
# the sed command is a workaround for the prepare target getting stuck in an
# infinite loop
RUN . /sdk/environment-* && \
  sed -i '/=. prepare/d' /sdk/sysroots/cortex*/usr/src/kernel/Makefile && \
  make -C /sdk/sysroots/cortex*/usr/src/kernel prepare

# Sets working directory
WORKDIR /repos

# Entrypoint into container
CMD ["/bin/bash"]
