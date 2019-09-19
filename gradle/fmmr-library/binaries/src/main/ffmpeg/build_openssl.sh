#!/bin/bash
# Cross-compile environment for Android on ARMv7 and x86
#

export PROPS=$WORKING_DIR/../../../../local.properties

export NDK=`grep ndk.dir $PROPS | cut -d'=' -f2`

if [ "$NDK" = "" ] || [ ! -d $NDK ]; then
  echo "NDK variable not set or path to NDK is invalid, exiting..."
  exit 1
fi

if [ -z "$PLATFORM_X32" ]; then
  echo "--------------------------------------------------------------"
  echo "Attention PLATFORM_X32 variable not specified"
  echo "You should specify variables in min_support_platforms.sh first"
  echo "--------------------------------------------------------------"
  exit 1
fi

export ANDROID_NDK_ROOT=$NDK

if [ $# -ne 1 ];
  then echo "illegal number of parameters"
  echo "usage: build_openssl.sh TARGET"
  exit 1
fi

UNAME_S=$(uname -s)
case "$UNAME_S" in
    Darwin)
        export FF_MAKE_FLAGS=-j`sysctl -n machdep.cpu.core_count`
    ;;
    CYGWIN_NT-*)
        FF_WIN_TEMP="$(cygpath -am /tmp)"
        export TEMPDIR=$FF_WIN_TEMP/

        echo "Cygwin temp prefix=$FF_WIN_TEMP/"
    ;;
esac

export TARGET=$1

ARM_PLATFORM=$NDK/platforms/${PLATFORM_X32}/arch-arm/
ARM_PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64

ARM64_PLATFORM=$NDK/platforms/${PLATFORM_X64}/arch-arm64/
ARM64_PREBUILT=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64

X86_PLATFORM=$NDK/platforms/${PLATFORM_X32}/arch-x86/
X86_PREBUILT=$NDK/toolchains/x86-4.9/prebuilt/darwin-x86_64

X86_64_PLATFORM=$NDK/platforms/${PLATFORM_X64}/arch-x86_64/
X86_64_PREBUILT=$NDK/toolchains/x86_64-4.9/prebuilt/darwin-x86_64

# MIPS_PLATFORM=$NDK/platforms/${PLATFORM_DEPRECATED}/arch-mips/
# MIPS_PREBUILT=$NDK/toolchains/mipsel-linux-android-4.9/prebuilt/darwin-x86_64

FF_BUILD_ROOT=`pwd`/openssl-android

OPENSSL_VERSION="1.0.2s"
FF_GCC_VER=4.9

FF_SOURCE=
FF_CROSS_PREFIX=

FF_CFG_FLAGS=
FF_PLATFORM_CFG_FLAGS=

FF_EXTRA_CFLAGS=
FF_EXTRA_LDFLAGS=


if [ $TARGET == 'arm' ]; then
  CPU=arm
  ARCH=armeabi
  PREFIX=`pwd`/../jni/openssl-android/armeabi
  export ANDROID_EABI=arm-linux-androideabi-${FF_GCC_VER}
  export ANDROID_ARCH=$ARCH
  KERNEL_BITS="32"
  PLATFORM=$PLATFORM_X32
  PREBUILT=$ARM_PREBUILT
  HOST=arm-linux-androideabi
  FF_SOURCE=$FF_BUILD_ROOT/$TARGET
  FF_CROSS_PREFIX=arm-linux-androideabi
  FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_VER}
  FF_PLATFORM_CFG_FLAGS="android"

elif [ $TARGET == 'armv7-a' ]; then
  CPU=armv7-a
  ARCH=armeabi-v7a
  PREFIX=`pwd`/../jni/openssl-android/armeabi-v7a
  export ANDROID_EABI=arm-linux-androideabi-${FF_GCC_VER}
  export ANDROID_ARCH=$ARCH
  KERNEL_BITS="32"
  PLATFORM=$PLATFORM_X32
  PREBUILT=$X86_PREBUILT
  HOST=i686-linux-android
  FF_SOURCE=$FF_BUILD_ROOT/$TARGET
  FF_CROSS_PREFIX=arm-linux-androideabi
  FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_VER}
  FF_PLATFORM_CFG_FLAGS="android"

elif [ $TARGET == 'i686' ]; then
  CPU=i686
  ARCH=x86
  PREFIX=`pwd`/../jni/openssl-android/x86
  export ANDROID_EABI=x86-${FF_GCC_VER}
  export ANDROID_ARCH=$ARCH
  KERNEL_BITS="32"
  PLATFORM=$PLATFORM_X32
  PREBUILT=$X86_PREBUILT
  HOST=i686-linux-android
  FF_SOURCE=$FF_BUILD_ROOT/$TARGET
  FF_CROSS_PREFIX=i686-linux-android
  FF_TOOLCHAIN_NAME=x86-${FF_GCC_VER}
  FF_PLATFORM_CFG_FLAGS="android-x86"
  FF_CFG_FLAGS="$FF_CFG_FLAGS no-asm"

 # elif [ $TARGET == 'mips' ]; then
 #   CPU=mips
 #   ARCH=mips
 #   PREFIX=`pwd`/../jni/openssl-android/mips
 #   export ANDROID_EABI=mipsel-linux-android-${FF_GCC_VER}
 #   export ANDROID_ARCH=arch-mips
 #   PLATFORM=$MIPS_PLATFORM
 #   PREBUILT=$MIPS_PREBUILT
 #   HOST=mipsel-linux-android
 #

elif [ $TARGET == 'x86_64' ]; then
  CPU=x86_64
  ARCH=x86_64
  PREFIX=`pwd`/../jni/openssl-android/x86_64
  export ANDROID_EABI=x86_64-${FF_GCC_VER}
  export ANDROID_ARCH=$ARCH
  KERNEL_BITS="64"
  PLATFORM=$PLATFORM_X64
  PREBUILT=$X86_64_PREBUILT
  HOST=x86_64-linux-android
  FF_SOURCE=$FF_BUILD_ROOT/$TARGET
  FF_CROSS_PREFIX=x86_64-linux-android
  FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_VER}
  FF_PLATFORM_CFG_FLAGS="linux-x86_64-clang"

elif [ $TARGET == 'arm64-v8a' ]; then
  CPU=arm64-v8a
  ARCH=arm64-v8a
  PREFIX=`pwd`/../jni/openssl-android/arm64-v8a
  export ANDROID_EABI=aarch64-linux-android-${FF_GCC_VER}
  export ANDROID_ARCH=$ARCH
  KERNEL_BITS="64"
  PLATFORM=$PLATFORM_X64
  PREBUILT=$ARM64_PREBUILT
  HOST=aarch64-linux-android
  FF_SOURCE=$FF_BUILD_ROOT/$TARGET
  FF_CROSS_PREFIX=aarch64-linux-android
  FF_TOOLCHAIN_NAME=${FF_CROSS_PREFIX}-${FF_GCC_VER}
  FF_PLATFORM_CFG_FLAGS="android64-aarch64"
else
  echo "unknown architecture $TARGET";
  exit 1
fi


if [ ! -e "openssl-${OPENSSL_VERSION}.tar.gz" ]; then
  echo "Downloading openssl-${OPENSSL_VERSION}.tar.gz"
  curl -LO https://www.openssl.org/source/openssl-${OPENSSL_VERSION}.tar.gz
else
  echo "Using openssl-${OPENSSL_VERSION}.tar.gz"
fi

# FF_TOOLCHAIN_PATH=$FF_BUILD_ROOT/build/${TARGET}/toolchain

# FF_SYSROOT=$FF_TOOLCHAIN_PATH/sysroot
# FF_PREFIX=$FF_BUILD_ROOT/build/${TARGET}/output
FF_PREFIX=$FF_BUILD_ROOT/build/${TARGET}

rm -rf openssl-${OPENSSL_VERSION}
if [ -d $FF_SOURCE ]
then
    rm -rf $FF_SOURCE
fi

mkdir -p $FF_BUILD_ROOT

tar -xf openssl-${OPENSSL_VERSION}.tar.gz && mv openssl-${OPENSSL_VERSION} $FF_SOURCE && echo "openssl-${OPENSSL_VERSION}.tar.gz has been extracted to $FF_SOURCE" || exit 1

if [ ! -f "$FF_PREFIX/lib/libcrypto.a" ]; then
  echo "$FF_PREFIX contains "
  echo `ls -lsa $FF_PREFIX`
  rm -rf $FF_PREFIX
  mkdir -p $FF_PREFIX

  minApiVersion=`echo $PLATFORM | cut -d'-' -f 2`
  echo "minApiVersion $minApiVersion"
  ./openssl_build.sh $ANDROID_NDK \
  $FF_SOURCE \
  $minApiVersion \
  $ARCH \
  $FF_GCC_VER \
  $FF_PREFIX
fi

if [ ! -f "$FF_PREFIX/lib/libcrypto.a" ]; then
  echo "$FF_PREFIX contains "
  echo `ls -lsa $FF_PREFIX`
  exit 1
fi
# # INSTALL_DIR=`pwd`/openssl-android/$CPU
# # mkdir -p $INSTALL_DIR
#
# # cd openssl-${OPENSSL_VERSION}
#
#
# echo "--------------------"
# echo "--------------------"
# echo "[*] make NDK standalone toolchain"
# echo "--------------------"
# # . ./Setenv-android.sh $NDK $ANDROID_EABI $ANDROID_ARCH
# FF_MAKE_TOOLCHAIN_FLAGS="$FF_MAKE_TOOLCHAIN_FLAGS --verbose"
# FF_MAKE_TOOLCHAIN_FLAGS="$FF_MAKE_TOOLCHAIN_FLAGS --platform=$PLATFORM"
# FF_MAKE_TOOLCHAIN_FLAGS="$FF_MAKE_TOOLCHAIN_FLAGS --install-dir=$FF_TOOLCHAIN_PATH"
# FF_MAKE_TOOLCHAIN_FLAGS="$FF_MAKE_TOOLCHAIN_FLAGS --toolchain=$FF_TOOLCHAIN_NAME"
# FF_MAKE_TOOLCHAIN_FLAGS="$FF_MAKE_TOOLCHAIN_FLAGS --abis=$ARCH"
# # FF_MAKE_TOOLCHAIN_FLAGS="$FF_MAKE_TOOLCHAIN_FLAGS --force"
#
# FF_TOOLCHAIN_TOUCH="$FF_TOOLCHAIN_PATH/touch"
# export PATH=$FF_TOOLCHAIN_PATH/bin:$PATH
#
# # if [ $KERNEL_BITS == '64' ]; then
# #   minApiVersion=21
# # else
# #   minApiVersion=9
# # fi
# # rm -rf ${FF_TOOLCHAIN_PATH} && \
# # 	${ANDROID_NDK_ROOT}/build/tools/make_standalone_toolchain.py --arch $ARCH \
# # 		--api ${minApiVersion} --install-dir ${FF_TOOLCHAIN_PATH}
#
# if [ ! -f "$FF_TOOLCHAIN_TOUCH" ]; then
#     $ANDROID_NDK_ROOT/build/tools/make-standalone-toolchain.sh \
#         $FF_MAKE_TOOLCHAIN_FLAGS && \
#     touch $FF_TOOLCHAIN_TOUCH || exit 1
# fi
#
# #--------------------
# echo ""
# echo "--------------------"
# echo "[*] check openssl env"
# echo "--------------------"
# if [ -d "$FF_TOOLCHAIN_PATH/bin" ]; then
#   export PATH=$FF_TOOLCHAIN_PATH/bin:$PATH
# else
#   echo "No toolchain found in export path: ${FF_TOOLCHAIN_PATH}/bin"
#   exit 1
# fi
#
# export ANDROID_NDK_HOME=$FF_TOOLCHAIN_PATH
#
# echo "Clean openssl output directory"
# mkdir -p $FF_PREFIX
# rm -rf $FF_PREFIX/*
#
# echo "Setting up openssl environment"
# # export ANDROID_ARCH=$FF_SYSROOT
# # export ANDROID_EABI="${HOST}-${TOOLCHAIN_VERSION}"
# # export ANDROID_API=$PLATFORM
# # export ANDROID_SYSROOT=$ANDROID_NDK_ROOT/platforms/${PLATFORM}/$FF_SYSROOT
# # export ANDROID_TOOLCHAIN=$FF_TOOLCHAIN_PATH
# # export ANDROID_DEV=$ANDROID_SYSROOT/usr
#
# # export SYSTEM=android
# # export ARCH=$ARCH
# #
# # export CROSS_COMPILE=$HOST-
# #
# # export CFLAGS="--sysroot=$ANDROID_SYSROOT"
# # export CPPFLAGS="--sysroot=$ANDROID_SYSROOT"
# # export CXXFLAGS="--sysroot=$ANDROID_SYSROOT"
#
# # export COMMON_FF_CFG_FLAGS="no-ssl2 no-ssl3 no-comp no-hw no-engine"
# export COMMON_FF_CFG_FLAGS="shared -no-idea -no-asm -no-ssl2 -no-ssl3 -no-comp -no-hw"
# FF_CFG_FLAGS="$FF_CFG_FLAGS $COMMON_FF_CFG_FLAGS"
#
# #--------------------
# # Standard options:
# # FF_CFG_FLAGS="$FF_CFG_FLAGS zlib-dynamic"
# # FF_CFG_FLAGS="$FF_CFG_FLAGS no-shared"
# FF_CFG_FLAGS="$FF_CFG_FLAGS --openssldir=$FF_PREFIX"
# FF_CFG_FLAGS="$FF_CFG_FLAGS --cross-compile-prefix=${FF_CROSS_PREFIX}-"
# # FF_CFG_FLAGS="$FF_CFG_FLAGS --cross-compile-prefix=$CROSS_COMPILE"
# FF_CFG_FLAGS="$FF_CFG_FLAGS $FF_PLATFORM_CFG_FLAGS"
# #--------------------
# echo ""
# echo "--------------------"
# echo "[*] configurate openssl"
# echo "--------------------"
# cd $FF_SOURCE
# # export CC=~/android-ndk-r9/toolchains/arm-linux-androideabi-4.8/prebuilt/darwin-x86_64/bin/arm-linux-androideabi-gcc
#
# #if [ -f "./Makefile" ]; then
# #    echo 'reuse configure'
# #else
#     echo "./Configure $FF_CFG_FLAGS"
#     # CC=$FF_TOOLCHAIN_PATH/bin/arm-linux-androideabi-gcc \
#      ./Configure $FF_CFG_FLAGS || exit 1
#       # CC=clang ANDROID_NDK=${FF_TOOLCHAIN_PATH} PATH=${PATH} \
#       # ./Configure $FF_CFG_FLAGS && \
#       # CC=clang ANDROID_NDK=${FF_TOOLCHAIN_PATH} PATH=${PATH} \
#       # make build_libs
#
#
# #        --extra-cflags="$FF_CFLAGS $FF_EXTRA_CFLAGS" \
# #        --extra-ldflags="$FF_EXTRA_LDFLAGS"
# #fi
# cd $FF_SOURCE
#
# # Remove the version from the soname generated by the makefile
# echo "Modify openssl makefile to remove version from soname"
# sed -i.bak 's/^SHLIB_EXT=\.so\..*/SHLIB_EXT=\.so/' Makefile
# # sed -i.bak 's/^SHLIB_EXT=\.so\..*/SHLIB_EXT=\.so/' Makefile.shared
# sed -i.bak 's/LIBVERSION=[^ ]* /LIBVERSION= /g' Makefile
# # sed -i.bak 's/LIBVERSION=[^ ]* /LIBVERSION= /g' Makefile.shared
# # sed -i.bak 's/install: all install_docs install_sw/install: install_docs install_sw/g' Makefile.shared
# sed -i.bak 's/install: all install_docs install_sw/install: install_docs install_sw/g' Makefile
#
# cd $FF_SOURCE
#
# echo "--------------------"
# echo "--------------------"
# echo "[*] compile openssl"
# echo "--------------------"
# make depend
# make $FF_MAKE_FLAGS || exit 1
# make install_sw || exit 1
# #--------------------
# echo ""
# echo "--------------------"
# echo "[*] link openssl"
# echo "--------------------"
#
# echo $ANDROID_TOOLCHAIN
# echo $PREBUILT/bin
#
# # echo 'Xxxxxxxxxx' | sudo -kSE make install CC=$PREBUILT/bin/$HOST-gcc RANLIB=$PREBUILT/bin/$HOST-ranlib
#
# echo "--------------------"
# echo "--------------------"
# echo "[*] copy the binaries"
# echo "--------------------"
# mkdir -p $PREFIX
# cp -r $FF_PREFIX/* $PREFIX
#
#
#
# # if [ $TARGET == "mips" ]
# # then
# #   echo "does not works"
# #   echo "TODO - replace with calling libopenssl_builder.sh"
# #   exit 1
# #      ./Configure android-mips shared no-ssl2 no-ssl3 no-comp no-hw no-engine --openssldir=$INSTALL_DIR --prefix=$INSTALL_DIR
# # elif [ $TARGET == "x86_64" ]
# # then
# #     #./Configure linux-generic64 shared no-ssl2 no-ssl3 no-comp no-hw no-engine --openssldir=$INSTALL_DIR --prefix=$INSTALL_DIR
# #     . ./libopenssl_builder.sh -s `pwd` -n $NDK -o $FF_BUILD_ROOT/output -b 6 -p $PLATFORM_X64 -t $FF_BUILD_ROOT/${CPU}/toolchain
# #
# #     # copy the binaries
# #     mkdir -p $PREFIX
# #     cp -r $FF_BUILD_ROOT/$CPU/* $PREFIX
# #
# #     exit 0
# # elif [ $TARGET == "arm64-v8a" ]
# # then
# #     . ./libopenssl_builder.sh -s `pwd` -n $NDK -o $FF_BUILD_ROOT/output -b 1 -p $PLATFORM_X64 -t $FF_BUILD_ROOT/${CPU}/toolchain
# #
# #     # copy the binaries
# #     mkdir -p $PREFIX
# #     cp -r $FF_BUILD_ROOT/$CPU/* $PREFIX
# #
# #     exit 0
# # elif [ $TARGET == "armv7-a" ]
# # then
# #     . ./libopenssl_builder.sh -s `pwd` -n $NDK -o $FF_BUILD_ROOT/output -b 3 -p $PLATFORM_X32 -t $FF_BUILD_ROOT/${CPU}/toolchain
# #     # copy the binaries
# #     mkdir -p $PREFIX
# #     cp -r $FF_BUILD_ROOT/$CPU/* $PREFIX
# #
# #     exit 0
# # elif [ $TARGET == "i686" ]
# # then
# #     . ./libopenssl_builder.sh -s `pwd` -n $NDK -o $FF_BUILD_ROOT/output -b 0 -p $PLATFORM_X32 -t $FF_BUILD_ROOT/${CPU}/toolchain
# #     # copy the binaries
# #     mkdir -p $PREFIX
# #     cp -r $FF_BUILD_ROOT/$CPU/* $PREFIX
# #
# #     exit 0
# # else
# #   echo "does not works"
# #   echo "TODO - replace with calling libopenssl_builder.sh"
# #   exit 1
