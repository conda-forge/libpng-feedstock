#!/bin/bash
set -ex
# Get an updated config.sub and config.guess
cp $BUILD_PREFIX/share/libtool/build-aux/config.* .

# hmaarrfk - 2025/11/01
# We at conda-forge changed the zlib implementation to zlib-ng
# this changes the bit-for-bit results in the png test image
# So I (hmaarrfk) generated it with zlib-ng and saved it
cp ${RECIPE_DIR}/pngtest.png ./pngtest.png

./configure --prefix=$PREFIX

make -j${CPU_COUNT} ${VERBOSE_AT}
if [[ "${CONDA_BUILD_CROSS_COMPILATION}" != "1" ]]; then
make check
fi
make install

# We can remove this when we start using the new conda-build.
find $PREFIX -name '*.la' -delete
