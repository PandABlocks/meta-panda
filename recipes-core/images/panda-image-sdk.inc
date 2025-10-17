TOOLCHAIN_OUTPUTNAME = "pandablocks-sdk-${MACHINE}"
TOOLCHAIN_TARGET_TASK += " \
  kernel-devsrc \
"
TOOLCHAIN_HOST_TASK += " \
  nativesdk-python3-sphinx \
  nativesdk-python3-docutils \
  nativesdk-python3-six \
  nativesdk-python3-sphinx-rtd-theme \
  nativesdk-python3-babel \
  nativesdk-python3-jinja2 \
  nativesdk-python3-pygments \
  nativesdk-python3-imagesize \
"
