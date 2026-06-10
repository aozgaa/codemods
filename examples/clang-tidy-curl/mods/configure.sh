#!/bin/sh
# Shared bespoke repo logic: configure curl's build directory.
# SSL and libpsl are disabled so the build needs no third-party libraries on
# either macOS or Linux — this campaign only needs a compile database and
# compilable objects, not a featureful curl.
set -eu
cmake -S . -B build -G Ninja \
  -DCMAKE_EXPORT_COMPILE_COMMANDS=ON \
  -DCURL_ENABLE_SSL=OFF \
  -DCURL_USE_LIBPSL=OFF
