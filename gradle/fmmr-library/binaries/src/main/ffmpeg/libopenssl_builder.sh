#!/bin/bash

USAGE=$'Usage:

./libopenssl_builder <options>

Required:
  -s <openssl_directory> The top level openssl directory
  -n <ndk_directory> The top level ndk directory
  -o <output_directory> The directory in which you would like the builds
  -b <build index> 0-6

Optional:
  -h Help
  -y <system> The system you are using (default: darwin-x86_64 - for mac users)
  -p <platform> Android platform (default: android-21)
  -t <toolchain_install_dir> The directory in which to install the toolchains (default: /tmp/libopenssl_builder/toolhain)
  -v <toolchain_version> The toolchain version (default: 4.9)
'

# Architectures and Toolchains

TOOLCHAIN_VERSION=4.9

PLATFORM=android-21

TOOLCHAIN_SYSTEM=darwin-x86_64

TOOLCHAIN_INSTALL_DIR=/tmp/libopenssl_builder/toolchain

BUILD_INDEX=0

# In same order as ARCHS - each toolchain corresponds to an architecture
TOOLS=(
    x86
    aarch64-linux-android
    arm-linux-androideabi
    arm-linux-androideabi
     mipsel-linux-android
     mips64el-linux-android
    x86_64
)

# In same order as ARCHS - the host is the prefix of the tools in the toolchain bin
HOSTS=(
    i686-linux-android
    aarch64-linux-android
    arm-linux-androideabi
    arm-linux-androideabi
     mipsel-linux-android
     mips64el-linux-android
    x86_64-linux-android
)

# In same order as ARCHS - folder names of <ndk>/platforms/$PLATFORM/xxxxx
SYSROOTS=(
    arch-x86
    arch-arm64
    arch-arm
    arch-arm
     arch-mips
     arch-mips64
    arch-x86_64
)

ARCHS=(
    android-x86
    arm64-v8a
    armeabi
    armv7-a
    mips
    mips64
    x86_64
)

# In same order as ARCHS - machines for openssl
OPENSSL_OS=(
    android-x86
    aarch64-linux-android
    android
    android-armv7
    linux-generic32
    linux-generic64
    x86_64-linux-android
)

check_built()
{
    arch=$1
    openssl_artifact=$OPENSSL_OUTDIR/$arch/lib/libssl.so
    if [ -f "$openssl_artifact" ]; then
        echo "openssl: OK"
    else
        echo "openssl: FAIL"
    fi
}

while getopts o:n:s:y:p:t:v:b:h opt; do
    case $opt in
    n)
        ndk_directory=$OPTARG
        ;;
    o)
        output_directory=$OPTARG
        ;;
    s)
        openssl_directory=$OPTARG
        ;;
    y)
        TOOLCHAIN_SYSTEM=$OPTARG
        ;;
    p)
        PLATFORM=$OPTARG
        ;;
    t)
        TOOLCHAIN_INSTALL_DIR=$OPTARG
        ;;
    v)
        TOOLCHAIN_VERSION=$OPTARG
        ;;
    b)
        BUILD_INDEX=$OPTARG
        ;;
    h)
        echo "$USAGE"
        exit 0
        ;;
    esac
done

shift $((OPTIND - 1))

if [ -z "$output_directory" -o -z "$ndk_directory" -o -z "$openssl_directory" ]; then
    echo "$USAGE"
    exit 0
fi

export OPENSSL_OUTDIR=$output_directory

echo "========================================"
echo "======== libopenssl_builder  start ========"
echo "========================================"

# Build curl for each Android architecture
#for (( i=0; i<${#ARCHS[@]}; i++)); do

    tool=${TOOLS[$BUILD_INDEX]}
    arch=${ARCHS[$BUILD_INDEX]}
    host=${HOSTS[$BUILD_INDEX]}
    sysroot=${SYSROOTS[$BUILD_INDEX]}

    mkdir -p $TOOLCHAIN_INSTALL_DIR

    if [ -d "$TOOLCHAIN_INSTALL_DIR/bin" ]; then
        echo "Skipping creation of toolchain - exists in $TOOLCHAIN_INSTALL_DIR"
    else
        echo "Building toolchain"
        $ndk_directory/build/tools/make-standalone-toolchain.sh --platform=$PLATFORM --install-dir=$TOOLCHAIN_INSTALL_DIR --toolchain=$tool-"$TOOLCHAIN_VERSION" --abis=$arch #--force
    fi

    echo "Adding toolchain to PATH"
    export PATH=$TOOLCHAIN_INSTALL_DIR/bin:$PATH

    ############ OPENSSL ############
    echo "Clean openssl output directory"
    mkdir -p $OPENSSL_OUTDIR/$arch
    rm -rf $OPENSSL_OUTDIR/$arch/*

    echo "Setting up openssl environment"
    export ANDROID_NDK_ROOT=$ndk_directory
    export ANDROID_ARCH=$sysroot
    export ANDROID_EABI=$host-"$TOOLCHAIN_VERSION"
    export ANDROID_API=$PLATFORM
    export ANDROID_SYSROOT=$ndk_directory/platforms/$PLATFORM/$sysroot
    export ANDROID_TOOLCHAIN=$TOOLCHAIN_INSTALL_DIR
    export ANDROID_DEV=$ANDROID_SYSROOT/usr

    export SYSTEM=android
    export ARCH=$arch

    export CROSS_COMPILE=$host-

    export CFLAGS="--sysroot=$ANDROID_SYSROOT"
    export CPPFLAGS="--sysroot=$ANDROID_SYSROOT"
    export CXXFLAGS="--sysroot=$ANDROID_SYSROOT"

    echo "Configuring openssl for "
    pushd $openssl_directory > /dev/null

    ./Configure ${OPENSSL_OS[$BUILD_INDEX]} shared -no-idea -no-asm -no-ssl2 -no-ssl3 -no-comp -no-hw --cross-compile-prefix=$CROSS_COMPILE --openssldir=$OPENSSL_OUTDIR/$arch --prefix=$OPENSSL_OUTDIR/$arch

    # Remove the version from the soname generated by the makefile
    echo "Modify openssl makefile to remove version from soname"
    pushd $openssl_directory > /dev/null
    sed -i.bak 's/^SHLIB_EXT=\.so\..*/SHLIB_EXT=\.so/' Makefile
    sed -i.bak 's/LIBVERSION=[^ ]* /LIBVERSION= /g' Makefile
    sed -i.bak 's/install: all install_docs install_sw/install: install_docs install_sw/g' Makefile
    popd > /dev/null

    echo "Building openssl"
    pushd $openssl_directory > /dev/null
    echo "make depend"
    make depend
    echo "make"
    make
    echo "Installing openssl to $OPENSSL_OUTDIR/$arch"
    make install
    echo "Cleaning up openssl"
    #make clean >> $logfile

    echo "========================================"
    check_built $arch
    echo "========================================"

#done

echo "========================================"
echo "========= libopenssl_builder done ========="
echo "========================================"
echo "Checking if everything worked..."
echo "----------------------------------------"
arch=${ARCHS[$BUILD_INDEX]}

check_built $arch

echo "----------------------------------------"
