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
ARM_PREBUILT=$NDK/toolchains/arm-linux-androideabi-4.9/prebuilt/darwin-x86_64

ARM64_PLATFORM=$NDK/platforms/${PLATFORM_X64}/arch-arm64
ARM64_PREBUILT=$NDK/toolchains/aarch64-linux-android-4.9/prebuilt/darwin-x86_64

X86_PLATFORM=$NDK/platforms/${PLATFORM_X32}/arch-x86
X86_PREBUILT=$NDK/toolchains/x86-4.9/prebuilt/darwin-x86_64

X86_64_PLATFORM=$NDK/platforms/${PLATFORM_X64}/arch-x86_64
X86_64_PREBUILT=$NDK/toolchains/x86_64-4.9/prebuilt/darwin-x86_64

# MIPS_PLATFORM=$NDK/platforms/${PLATFORM_DEPRECATED}/arch-mips
# MIPS_PREBUILT=$NDK/toolchains/mipsel-linux-android-4.9/prebuilt/darwin-x86_64

BUILD_DIR=`pwd`/ffmpeg-android

FFMPEG_VERSION="3.4.6"

if [ ! -e "ffmpeg-${FFMPEG_VERSION}.tar.bz2" ]; then
    echo "Downloading ffmpeg-${FFMPEG_VERSION}.tar.bz2"
    curl -LO http://ffmpeg.org/releases/ffmpeg-${FFMPEG_VERSION}.tar.bz2
else
    echo "Using ffmpeg-${FFMPEG_VERSION}.tar.bz2"
fi

tar -xf ffmpeg-${FFMPEG_VERSION}.tar.bz2 && echo "ffmpeg-${FFMPEG_VERSION}.tar.bz2 has been extracted"

for i in `find diffs -type f`; do
    (cd ffmpeg-${FFMPEG_VERSION} && patch -p1 < ../$i)
done

SSL_LD=`pwd`/openssl-android/build


function build_one
{
    openssl_output=$SSL_LD/${TARGET}
    SSL_EXTRA_LDFLAGS="-L$openssl_output/lib -lssl -lcrypto"
    SSL_EXTRA_CFLAGS="-I$openssl_output/include"

    echo $SSL_EXTRA_LDFLAGS
    echo $SSL_EXTRA_CFLAGS

    if [ $ARCH == "arm" ]
    then
        PLATFORM=$ARM_PLATFORM
        PREBUILT=$ARM_PREBUILT
        HOST=arm-linux-androideabi
    #added by alexvas
    elif [ $ARCH == "arm64" ]
    then
        PLATFORM=$ARM64_PLATFORM
        PREBUILT=$ARM64_PREBUILT
        HOST=aarch64-linux-android
    # elif [ $ARCH == "mips" ]
    # then
    #     PLATFORM=$MIPS_PLATFORM
    #     PREBUILT=$MIPS_PREBUILT
    #     HOST=mipsel-linux-android
    #alexvas
    elif [ $ARCH == "x86_64" ]
    then
        PLATFORM=$X86_64_PLATFORM
        PREBUILT=$X86_64_PREBUILT
        HOST=x86_64-linux-android
    else
        PLATFORM=$X86_PLATFORM
        PREBUILT=$X86_PREBUILT
        HOST=i686-linux-android
    fi
    FF_ASM_FLAGS=
    if [ "$ARCH" = "x86" ]; then
        FF_ASM_FLAGS="$FF_ASM_FLAGS --disable-asm  --enable-yasm"
    else
        # Optimization options (experts only):
        FF_ASM_FLAGS="$FF_ASM_FLAGS --enable-asm"
    fi
    #    --prefix=$PREFIX \

    #--incdir=$BUILD_DIR/include \
    #--libdir=$BUILD_DIR/lib/$CPU \

    #    --extra-cflags="-fvisibility=hidden -fdata-sections -ffunction-sections -Os -fPIC -DANDROID -DHAVE_SYS_UIO_H=1 -Dipv6mr_interface=ipv6mr_ifindex -fasm -Wno-psabi -fno-short-enums -fno-strict-aliasing -finline-limit=300 $OPTIMIZE_CFLAGS " \
    #    --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog" \

    # TODO Adding aac decoder brings "libnative.so has text relocations. This is wasting memory and prevents security hardening. Please fix." message in Android.
    # export COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-linux-perf"
    pushd ffmpeg-$FFMPEG_VERSION

# --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -nostdlib -lc -lm -ldl -llog $SSL_EXTRA_LDFLAGS -DOPENSSL_API_COMPAT=0x00908000L" \
    ./configure --target-os=linux \
        --enable-pic \
        --incdir=$BUILD_DIR/$TARGET/include \
        --libdir=$BUILD_DIR/$TARGET/lib \
        --enable-cross-compile \
        --enable-pthreads \
        --enable-runtime-cpudetect \
        --extra-libs="-lgcc" \
        --arch=$ARCH \
        --cc=$PREBUILT/bin/${HOST}-gcc \
        --cross-prefix=$PREBUILT/bin/${HOST}- \
        --nm=$PREBUILT/bin/${HOST}-nm \
        --sysroot=$PLATFORM \
        --extra-cflags="$OPTIMIZE_CFLAGS $SSL_EXTRA_CFLAGS" \
        --enable-shared \
        --enable-debug \
        --enable-small \
        --extra-ldflags="-Wl,-rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib -lc -lm -ldl -llog $SSL_EXTRA_LDFLAGS" \
        --disable-ffplay \
        --disable-ffmpeg \
        --disable-ffprobe \
        --disable-avfilter \
        --disable-avdevice \
        --disable-ffserver \
        --disable-doc \
        --disable-htmlpages \
        --disable-manpages \
        --disable-podpages \
        --disable-txtpages \
        --disable-swresample \
        --disable-postproc \
        --disable-gpl \
        --disable-hwaccels \
        --disable-encoders \
        --enable-encoder=png \
        --disable-decoders \
        --enable-decoder=ac3 \
        --enable-decoder=aac \
        --enable-decoder=mp3 \
        --enable-decoder=h264 \
        --enable-decoder=hevc \
        --enable-decoder=vp8 \
        --enable-decoder=vp9 \
        --disable-muxers \
        --disable-demuxers \
        --enable-demuxer=aac \
        --enable-demuxer=concat \
        --enable-demuxer=data \
        --enable-demuxer=mp3 \
        --enable-demuxer=mpegps \
        --enable-demuxer=mpegts \
        --enable-demuxer=mpegtsraw \
        --enable-demuxer=mpegvideo \
        --enable-demuxer=hevc \
        --enable-demuxer=dash \
        --enable-demuxer=mov \
        --enable-demuxer=webm_dash_manifest \
        --disable-parsers \
        --enable-parser=aac \
        --enable-parser=h264 \
        --enable-parser=hevc \
        --disable-bsfs \
        --disable-indevs \
        --disable-outdevs \
        --disable-devices \
        --disable-filters \
        --disable-debug \
        --enable-openssl \
        --disable-linux-perf \
        $FF_ASM_FLAGS \
        $ADDITIONAL_CONFIGURE_FLAG
    # not needed protocols disabling because of they don't increase library size
    #--disable-protocols \
    #--enable-protocol=file,http,https,mmsh,mmst,pipe,rtmp \

    make clean
    make
    make -j6 install # V=1
    $PREBUILT/bin/$HOST-ar d libavcodec/libavcodec.a inverse.o
    #$PREBUILT/bin/$HOST-ld -rpath-link=$PLATFORM/usr/lib -L$PLATFORM/usr/lib  -soname libffmpeg.so -shared -nostdlib  -z,noexecstack -Bsymbolic --whole-archive --no-undefined -o $PREFIX/libffmpeg.so libavcodec/libavcodec.a libavformat/libavformat.a libavutil/libavutil.a libswscale/libswscale.a -lc -lm -lz -ldl -llog  --warn-once  --dynamic-linker=/system/bin/linker $PREBUILT/lib/gcc/$HOST/4.6/libgcc.a
    popd

    # copy the binaries
    mkdir -p $PREFIX
    cp -r $BUILD_DIR/$TARGET/* $PREFIX
}

if [ $TARGET == 'arm64-v8a' ]; then
    #arm64-v8a
    CPU=arm64-v8a
    ARCH=arm64
    OPTIMIZE_CFLAGS=
    PREFIX=$BUILD_DIR/$CPU
    PREFIX=`pwd`/../jni/ffmpeg/ffmpeg/arm64-v8a
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'x86_64' ]; then
    #x86_64
    CPU=x86_64
    ARCH=x86_64
    OPTIMIZE_CFLAGS="-fomit-frame-pointer"
    #PREFIX=$BUILD_DIR/$CPU
    PREFIX=`pwd`/../jni/ffmpeg/ffmpeg/x86_64
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'i686' ]; then
    #x86
    CPU=i686
    ARCH=x86
    OPTIMIZE_CFLAGS="-fomit-frame-pointer"
    #PREFIX=$BUILD_DIR/$CPU
    PREFIX=`pwd`/../jni/ffmpeg/ffmpeg/x86
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

# if [ $TARGET == 'mips' ]; then
#     #mips
#     CPU=mips
#     ARCH=mips
#     OPTIMIZE_CFLAGS="-std=c99 -O3 -Wall -pipe -fpic -fasm \
# -ftree-vectorize -ffunction-sections -funwind-tables -fomit-frame-pointer -funswitch-loops \
# -finline-limit=300 -finline-functions -fpredictive-commoning -fgcse-after-reload -fipa-cp-clone \
# -Wno-psabi -Wa,--noexecstack"
#     #PREFIX=$BUILD_DIR/$CPU
#     PREFIX=`pwd`/../jni/ffmpeg/ffmpeg/mips
#     ADDITIONAL_CONFIGURE_FLAG=
#     build_one
# fi

if [ $TARGET == 'armv7-a' ]; then
    #arm armv7-a
    CPU=armv7-a
    ARCH=arm
    OPTIMIZE_CFLAGS="-mfloat-abi=softfp -marm -march=$CPU "
    #PREFIX=`pwd`/ffmpeg-android/$CPU
    PREFIX=`pwd`/../jni/ffmpeg/ffmpeg/armeabi-v7a
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi

if [ $TARGET == 'arm' ]; then
    #arm arm
    CPU=arm
    ARCH=arm
    OPTIMIZE_CFLAGS=""
    #PREFIX=`pwd`/ffmpeg-android/$CPU
    PREFIX=`pwd`/../jni/ffmpeg/ffmpeg/armeabi
    ADDITIONAL_CONFIGURE_FLAG=
    build_one
fi
