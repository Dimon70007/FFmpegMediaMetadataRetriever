#!/bin/bash

set -e

# Set your own NDK here
#NDK=~/Android/android-ndk-r10e

#export NDK=`grep ndk.dir $PROPS | cut -d'=' -f2`

#if [ "$NDK" = "" ] || [ ! -d $NDK ]; then
#    echo "NDK variable not set or path to NDK is invalid, exiting..."
#    exit 1
#fi

if [ -z "$PLATFORM_X32" ]; then
  echo "--------------------------------------------------------------"
  echo "Attention PLATFORM_X32 variable not specified"
  echo "You should specify variables in min_support_platforms.sh first"
  echo "--------------------------------------------------------------"
  exit 1
fi
export TARGET=$1

ARM_PLATFORM=$NDK/platforms/${PLATFORM_X32}/arch-arm
ARM_PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/$BUILD_PLATFORM

ARM64_PLATFORM=$NDK/platforms/${PLATFORM_X64}/arch-arm64
ARM64_PREBUILT=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/$BUILD_PLATFORM

X86_PLATFORM=$NDK/platforms/${PLATFORM_X32}/arch-x86
X86_PREBUILT=$NDK/toolchains/x86-4.9/prebuilt/$BUILD_PLATFORM

X86_64_PLATFORM=$NDK/platforms/${PLATFORM_X64}/arch-x86_64
X86_64_PREBUILT=$NDK/toolchains/x86_64-4.9/prebuilt/$BUILD_PLATFORM

# MIPS_PLATFORM=$NDK/platforms/${PLATFORM_DEPRECATED}/arch-mips
# MIPS_PREBUILT=$NDK/toolchains/mipsel-linux-android-4.9/prebuilt/darwin-x86_64
main_dir=`pwd`
BUILD_DIR=${main_dir}/ffmpeg-android

FFMPEG_VERSION="3.4.6"
# FFMPEG_VERSION="4.2.1"
FF_SOURCE_DIR=$main_dir/ffmpeg-${FFMPEG_VERSION}

if [ ! -e "ffmpeg-${FFMPEG_VERSION}.tar.bz2" ]; then
    echo "Downloading ffmpeg-${FFMPEG_VERSION}.tar.bz2"
    curl -LO http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2
else
    echo "Using ffmpeg-${FFMPEG_VERSION}.tar.bz2"
fi

COMMON_FF_CFG_FLAGS=
SSL_EXTRA_CFLAGS=
SSL_EXTRA_LDFLAGS=
SSL_LD=
source ./FFMPEG_CONFIG_PARAMS.sh

tar -xf ffmpeg-${FFMPEG_VERSION}.tar.bz2 && echo "ffmpeg-${FFMPEG_VERSION}.tar.bz2 has been extracted"

for i in `find diffs -type f`; do
    (cd $FF_SOURCE_DIR && patch -p1 < ../$i)
done


params_help_file=$main_dir/ffmpeg${FFMPEG_VERSION}_options_help.md
echo "generating ffmpeg options file: $params_help_file"
rm -f $params_help_file
touch $params_help_file

pushd $FF_SOURCE_DIR
echo -e "\n \n### List of available decoders " >>  $params_help_file
./configure --list-decoders  >>  $params_help_file
echo -e "\n \n### List of available encoders " >>  $params_help_file
./configure --list-encoders  >> $params_help_file
echo -e "\n \n### List of available hwaccels " >>  $params_help_file
./configure --list-hwaccels  >> $params_help_file
echo -e "\n \n### List of available demuxers " >>  $params_help_file
./configure --list-demuxers  >> $params_help_file
echo -e "\n \n### List of available muxers   " >>  $params_help_file
./configure --list-muxers    >> $params_help_file
echo -e "\n \n### List of available parsers  " >>  $params_help_file
./configure --list-parsers   >> $params_help_file
echo -e "\n \n### List of available protocols" >>  $params_help_file
./configure --list-protocols >> $params_help_file
echo -e "\n \n### List of available bsfs     " >>  $params_help_file
./configure --list-bsfs      >> $params_help_file
echo -e "\n \n### List of available indevs   " >>  $params_help_file
./configure --list-indevs    >> $params_help_file
echo -e "\n \n### List of available outdevs  " >>  $params_help_file
./configure --list-outdevs   >> $params_help_file
echo -e "\n \n### List of available filters  " >>  $params_help_file
./configure --list-filters   >> $params_help_file
popd

function build_one
{
    CROSS_PREFIX=${PREBUILT}/bin/${HOST}-
    CC="${CROSS_PREFIX}gcc"
    CXX="${CROSS_PREFIX}c++"
    AR="${CROSS_PREFIX}ar"
    LD="${CROSS_PREFIX}ld"
    NM="${CROSS_PREFIX}nm"
    STRIP="${CROSS_PREFIX}strip"
    ANDROID_API=`echo $PLATFORM_API | cut -d'-' -f 2`

    # with openssl
    if [ -f "${SSL_LD}/lib/libssl.a" ]; then
        echo "OpenSSL detected"
        COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-openssl"
        SSL_EXTRA_CFLAGS="-I$SSL_LD/include"
        SSL_EXTRA_LDFLAGS="-L$SSL_LD/lib" # -lssl -lcrypto"
    else
      echo "OpenSSL lib not found in path: "
      echo "$SSL_LD/lib"
      echo "For building without openssl please call build_ffmpeg.sh script"
      exit 1
    fi

    echo $SSL_EXTRA_LDFLAGS
    echo $SSL_EXTRA_CFLAGS

    pushd $FF_SOURCE_DIR

    echo "Cleaning..."
  	rm -f config.h
  	make clean || true
  	rm -rf ${TOOLCHAIN_PREFIX}

    #    --prefix=$PREFIX \

    #--incdir=$BUILD_DIR/include \
    #--libdir=$BUILD_DIR/lib/$CPU \

    #    --extra-cflags="-fvisibility=hidden -fdata-sections -ffunction-sections -Os -fPIC -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS " \
    #    --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog" \

    # TODO Adding aac decoder brings "libnative.so has text relocations. This is wasting memory and prevents security hardening. Please fix." message in Android.
    # export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-linux-perf"

# --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog $SSL_EXTRA_LDFLAGS -DOPENSSL_API_COMPAT=0x00908000L" \
    echo "configuring ..."
    ./configure \
        --nm=${NM} \
      	--ar=${AR} \
      	--as=${CROSS_PREFIX}gcc \
      	--strip=${STRIP} \
      	--cc=${CC} \
      	--cxx=${CXX} \
      	--enable-stripping \
        --target-os=linux \
        --x86asmexe=$NDK/prebuilt/${BUILD_PLATFORM}/bin/yasm \
        --enable-pic \
        --cross-prefix=$CROSS_PREFIX \
        --sysroot=$PLATFORM \
        --incdir=$BUILD_DIR/${TARGET}/include \
        --libdir=$BUILD_DIR/${TARGET}/lib \
        --enable-cross-compile \
        --extra-libs="-lgcc" \
        --arch=$ARCH \
        --extra-cflags="-Wl,-Bsymbolic -Os -DCONFIG_LINUX_PERF=0 -DANDROID $OPTIMIZE_CFLAGS $SSL_EXTRA_CFLAGS -fPIE -pie -fPIC" \
        --enable-shared \
        --enable-debug \
        --extra-ldflags="-Wl,-Bsymbolic -Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -fPIC -llog $SSL_EXTRA_LDFLAGS -DOPENSSL_API_COMPAT=0x00908000L" \
        $COMMON_FF_CFG_FLAGS \
        $ADDITIONAL_CONFIGURE_FLAG

    make clean
    make
    make $FF_MAKE_FLAGS install V=1
    $PREBUILT/bin/$HOST-ar d libavcodec/libavcodec.a inverse.o
    #$PREBUILT/bin/$HOST-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -soname libffmpeg.so -shared -nostdlib  -z,noexecstack -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a -lc -lm -lz -ldl -llog  --warn-once  --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/$HOST/4.6/libgcc.a
    popd

    # copy the binaries
    mkdir -p $PREFIX
    cp -r $BUILD_DIR/$TARGET/* $PREFIX
}

TOOLCHAIN_PREFIX=${FF_SOURCE_DIR}/toolchain-android

if [ $TARGET == 'arm64-v8a' ]; then
    #arm64-v8a
    CPU=arm64-v8a
    ARCH=arm64
    PLATFORM_API=$PLATFORM_X64
    OPTIMIZE_CFLAGS=
    PREFIX=${main_dir}/../jni/ffmpeg/ffmpeg/arm64-v8a
    SSL_LD=${main_dir}/../jni/openssl-android/arm64-v8a
    PLATFORM=$ARM64_PLATFORM
    PREBUILT=$ARM64_PREBUILT
    HOST=aarch64-linux-android

    OPTIMIZE_CFLAGS=
    ADDITIONAL_CONFIGURE_FLAG="--enable-neon --enable-optimizations"
    build_one
fi

if [ $TARGET == 'x86_64' ]; then
    #x86_64
    CPU=x86_64
    ARCH=x86_64
    PLATFORM_API=$PLATFORM_X64
    PREFIX=${main_dir}/../jni/ffmpeg/ffmpeg/x86_64
    SSL_LD=${main_dir}/../jni/openssl-android/x86_64
    PLATFORM=$X86_64_PLATFORM
    PREBUILT=$X86_64_PREBUILT

    HOST=x86_64-linux-android
    OPTIMIZE_CFLAGS="-fomit-frame-pointer"

    ADDITIONAL_CONFIGURE_FLAG="--disable-asm"
    build_one
fi

if [ $TARGET == 'i686' ]; then
    #x86
    CPU=i686
    ARCH=x86
    PLATFORM_API=$PLATFORM_X32
    PLATFORM=$X86_PLATFORM
    PREBUILT=$X86_PREBUILT
    HOST=i686-linux-android
    OPTIMIZE_CFLAGS="-fomit-frame-pointer"
    PREFIX=${main_dir}/../jni/ffmpeg/ffmpeg/x86
    SSL_LD=${main_dir}/../jni/openssl-android/x86

    OPTIMIZE_CFLAGS="$OPTIMIZE_CFLAGS -march=$CPU"
    ADDITIONAL_CONFIGURE_FLAG="--disable-x86asm --disable-inline-asm --disable-asm -enable-yasm"
    build_one
fi

if [ $TARGET == 'armv7-a' ]; then
    #arm armv7-a
    CPU=armv7-a
    ARCH=arm
    PLATFORM_API=$PLATFORM_X32
    PLATFORM=$ARM_PLATFORM
    PREBUILT=$ARM_PREBUILT
    HOST=arm-linux-androideabi
    OPTIMIZE_CFLAGS="-mfloat-abi=softfp -marm -march=$CPU "
    PREFIX=${main_dir}/../jni/ffmpeg/ffmpeg/armeabi-v7a
    SSL_LD=${main_dir}/../jni/openssl-android/armeabi-v7a

    ADDITIONAL_CONFIGURE_FLAG="--enable-neon"
    build_one
fi

if [ $TARGET == 'arm' ]; then
    #arm arm
    CPU=arm
    ARCH=arm
    PLATFORM_API=$PLATFORM_X32
    PLATFORM=$ARM_PLATFORM
    PREBUILT=$ARM_PREBUILT
    HOST=arm-linux-androideabi
    OPTIMIZE_CFLAGS=""
    PREFIX=${main_dir}/../jni/ffmpeg/ffmpeg/armeabi
    SSL_LD=${main_dir}/../jni/openssl-android/armeabi

    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi
