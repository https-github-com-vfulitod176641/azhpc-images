#!/bin/bash
set -ex

# Load gcc
GCC_VERSION=gcc-9.2.0
export PATH=/opt/${GCC_VERSION}/bin:$PATH
export LD_LIBRARY_PATH=/opt/${GCC_VERSION}/lib64:$LD_LIBRARY_PATH
set CC=/opt/${GCC_VERSION}/bin/gcc
set GCC=/opt/${GCC_VERSION}/bin/gcc

INSTALL_PREFIX=/opt/amd
mkdir -p ${INSTALL_PREFIX}

# AMD FFTW
FFTW_DOWNLOAD_URL=https://github.com/amd/amd-fftw/releases/download/2.0/aocl-fftw-centos-2.0.tar.gz
$COMMON_DIR/download_and_verify.sh $FFTW_DOWNLOAD_URL "16b77d2d29d6c87279cc1288a7bd76fb4c9d77a318ce17951c8acbcf719ee121"
tar -xvf aocl-fftw-centos-2.0.tar.gz
cp -r amd-fftw ${INSTALL_PREFIX}/fftw


# AMD libflame
LIBFLAME_DOWNLOAD_URL=https://github.com/amd/libflame/releases/download/2.0/aocl-libflame-centos-2.0.tar.gz
$COMMON_DIR/download_and_verify.sh $LIBFLAME_DOWNLOAD_URL "c660ac9cd67ada881fde6a00cdffe9b1cdd4607585a3b414b769b1b82df6d95e"
tar -xvf aocl-libflame-centos-2.0.tar.gz
cp -r amd-libflame ${INSTALL_PREFIX}/libflame


# AMD blis
BLIS_DOWNLOAD_URL=https://github.com/amd/blis/releases/download/2.0/aocl-blis-centos-2.0.tar.gz
$COMMON_DIR/download_and_verify.sh $BLIS_DOWNLOAD_URL "8548e42bb58f5fe9db38a42510c0ceb6806b91a117aa777f17951de1d6c59c53"
tar -xvf aocl-blis-centos-2.0.tar.gz
cp -r amd-blis ${INSTALL_PREFIX}/blis


# AMD blis-mt
BLIS_MT_DOWNLOAD_URL=https://github.com/amd/blis/releases/download/2.0/aocl-blis-mt-centos-2.0.tar.gz
$COMMON_DIR/download_and_verify.sh $BLIS_MT_DOWNLOAD_URL "6a6e2ee993a55c22cfb6ffc0361b6b53c146efac25f199e2a68763e13e7e1f09"
tar -xvf aocl-blis-mt-centos-2.0.tar.gz
cp -r amd-blis-mt ${INSTALL_PREFIX}/blis-mt

FFTW_VERSION="2.0"
LIBFLAME_VERSION="2.0"
BLIS_VERSION="2.0"
BLIS_MT_VERSION="2.0"

# Setup module files for AMD Libraries
mkdir -p /usr/share/Modules/modulefiles/amd/

# fftw
cat << EOF >> /usr/share/Modules/modulefiles/amd/fftw-${FFTW_VERSION}
#%Module 1.0
#
#  fftw
#
module load ${GCC_VERSION}
prepend-path    LD_LIBRARY_PATH   ${INSTALL_PREFIX}/fftw/lib
setenv          AMD_FFTW_INCLUDE  ${INSTALL_PREFIX}/fftw/include
EOF

# libflame
cat << EOF >> /usr/share/Modules/modulefiles/amd/libflame-${LIBFLAME_VERSION}
#%Module 1.0
#
#  libflame
#
module load ${GCC_VERSION}
prepend-path    LD_LIBRARY_PATH       ${INSTALL_PREFIX}/libflame/lib 
setenv          AMD_LIBFLAME_INCLUDE  ${INSTALL_PREFIX}/libflame/include
EOF

# blis
cat << EOF >> /usr/share/Modules/modulefiles/amd/blis-${BLIS_VERSION}
#%Module 1.0
#
#  blis
#
module load ${GCC_VERSION}
prepend-path    LD_LIBRARY_PATH   ${INSTALL_PREFIX}/blis/lib
setenv          AMD_BLIS_INCLUDE  ${INSTALL_PREFIX}/blis/include
EOF

# blis-mt
cat << EOF >> /usr/share/Modules/modulefiles/amd/blis-mt-${BLIS_MT_VERSION}
#%Module 1.0
#
#  blis-mt
#
module load ${GCC_VERSION} 
prepend-path    LD_LIBRARY_PATH      ${INSTALL_PREFIX}/blis-mt/lib 
setenv          AMD_BLIS_MT_INCLUDE  ${INSTALL_PREFIX}/blis-mt/include
EOF

# Create symlinks for modulefiles
ln -s /usr/share/Modules/modulefiles/amd/fftw-${FFTW_VERSION} /usr/share/Modules/modulefiles/amd/fftw
ln -s /usr/share/Modules/modulefiles/amd/libflame-${LIBFLAME_VERSION} /usr/share/Modules/modulefiles/amd/libflame
ln -s /usr/share/Modules/modulefiles/amd/blis-${BLIS_VERSION} /usr/share/Modules/modulefiles/amd/blis
ln -s /usr/share/Modules/modulefiles/amd/blis-mt-${BLIS_MT_VERSION} /usr/share/Modules/modulefiles/amd/blis-mt
