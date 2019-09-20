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
FF_SOURCES_DIR=`pwd`/openssl_sources

OPENSSL_VERSION="1.0.2s"
FF_GCC_VER=4.9

FF_SOURCE=

FF_CFG_FLAGS=

FF_EXTRA_CFLAGS=
FF_EXTRA_LDFLAGS=


if [ $TARGET == 'arm' ]; then
  CPU=arm
  ARCH=armeabi
  PREFIX=`pwd`/../jni/openssl-android/armeabi
  export ANDROID_EABI=arm-linux-androideabi-${FF_GCC_VER}
  export ANDROID_ARCH=$ARCH
  PLATFORM_API=$PLATFORM_X32
  PREBUILT=$ARM_PREBUILT
  HOST=arm-linux-androideabi

elif [ $TARGET == 'armv7-a' ]; then
  CPU=armv7-a
  ARCH=armeabi-v7a
  PREFIX=`pwd`/../jni/openssl-android/armeabi-v7a
  export ANDROID_EABI=arm-linux-androideabi-${FF_GCC_VER}
  export ANDROID_ARCH=$ARCH
  PLATFORM_API=$PLATFORM_X32
  PREBUILT=$X86_PREBUILT
  HOST=i686-linux-android

elif [ $TARGET == 'i686' ]; then
  CPU=i686
  ARCH=x86
  PREFIX=`pwd`/../jni/openssl-android/x86
  export ANDROID_EABI=x86-${FF_GCC_VER}
  export ANDROID_ARCH=$ARCH
  PLATFORM_API=$PLATFORM_X32
  PREBUILT=$X86_PREBUILT
  HOST=i686-linux-android
  FF_CFG_FLAGS="$FF_CFG_FLAGS no-asm"

 # elif [ $TARGET == 'mips' ]; then
 #   CPU=mips
 #   ARCH=mips
 #   PREFIX=`pwd`/../jni/openssl-android/mips
 #   export ANDROID_EABI=mipsel-linux-android-${FF_GCC_VER}
 #   export ANDROID_ARCH=arch-mips
 #   PLATFORM_API=$MIPS_PLATFORM
 #   PREBUILT=$MIPS_PREBUILT
 #   HOST=mipsel-linux-android
 #

elif [ $TARGET == 'x86_64' ]; then
  CPU=x86_64
  ARCH=x86_64
  PREFIX=`pwd`/../jni/openssl-android/x86_64
  export ANDROID_EABI=x86_64-${FF_GCC_VER}
  export ANDROID_ARCH=$ARCH
  PLATFORM_API=$PLATFORM_X64
  PREBUILT=$X86_64_PREBUILT
  HOST=x86_64-linux-android

elif [ $TARGET == 'arm64-v8a' ]; then
  CPU=arm64-v8a
  ARCH=arm64-v8a
  PREFIX=`pwd`/../jni/openssl-android/arm64-v8a
  export ANDROID_EABI=aarch64-linux-android-${FF_GCC_VER}
  export ANDROID_ARCH=$ARCH
  PLATFORM_API=$PLATFORM_X64
  PREBUILT=$ARM64_PREBUILT
  HOST=aarch64-linux-android
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

FF_SOURCE=$FF_SOURCES_DIR/$ARCH
# set install dir to jni dir
# FF_PREFIX=$FF_BUILD_ROOT/$ARCH

rm -rf openssl-${OPENSSL_VERSION}
mkdir -p $FF_SOURCE
rm -rf $FF_SOURCE

mkdir -p $FF_BUILD_ROOT

tar -xf openssl-${OPENSSL_VERSION}.tar.gz && mv openssl-${OPENSSL_VERSION} $FF_SOURCE && echo "openssl-${OPENSSL_VERSION}.tar.gz has been extracted to $FF_SOURCE" || exit 1

if [ ! -f "$PREFIX/lib/libssl.a" ]; then
  echo "No lib/libssl.a found in $PREFIX"
  echo "Compiling from source"
  rm -rf $PREFIX
  mkdir -p $PREFIX

  minApiVersion=`echo $PLATFORM_API | cut -d'-' -f 2`
  echo "minApiVersion $minApiVersion"
  ./openssl_build.sh $ANDROID_NDK \
  $FF_SOURCE \
  $minApiVersion \
  $ARCH \
  $FF_GCC_VER \
  $PREFIX 

fi

if [ ! -f "$PREFIX/lib/libssl.a" ]; then
  echo "$PREFIX contains \\"
  for i in `ls -lsa $PREFIX`; do
    echo "$i \n"
  done
  exit 1
fi

# mkdir -p $PREFIX
# rm -rf $PREFIX
# cp -r $FF_PREFIX $PREFIX

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
