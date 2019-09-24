#!/bin/sh

CURRENT=`pwd`
BASENAME=`basename "$CURRENT"`
if [ $BASENAME != "ffmpeg" ]; then
  cd src/main/ffmpeg
fi

export WORKING_DIR=`pwd`
export PROPS=$WORKING_DIR/../../../../local.properties

export NDK=`grep ndk.dir $PROPS | cut -d'=' -f2`

export PLATFORM_DEPRECATED=
export PLATFORM_X32=
export PLATFORM_X64=
source $WORKING_DIR/min_support_platforms.sh

function setCurrentPlatform {
  UNAME_S=$(uname -s)
  case "$UNAME_S" in
      Darwin)
          export FF_MAKE_FLAGS="-j`sysctl -n machdep.cpu.thread_count`"
          # export FF_MAKE_FLAGS="-j`sysctl -n machdep.cpu.core_count`"
          export BUILD_PLATFORM=darwin-x86_64
          echo "FF_MAKE_FLAGS: ${FF_MAKE_FLAGS}"
      ;;
      Linux*)
          export FF_MAKE_FLAGS="-j$(nproc)"
          export BUILD_PLATFORM=linux-x86_64
          ;;
      CYGWIN_NT-*)
          export BUILD_PLATFORM=linux-x86_64
          FF_WIN_TEMP="$(cygpath -am /tmp)"
          export FF_MAKE_FLAGS="-j2"
          export TEMPDIR=$FF_WIN_TEMP/
          echo "Cygwin temp prefix=$FF_WIN_TEMP/"
      ;;
      *)
          export BUILD_PLATFORM=linux-x86_64
          export FF_MAKE_FLAGS="-j1"
          echo -e "\033[33mWarning! Unknown platform ${UNAME_S}! falling back compile linux-x86_64\033[0m"
          ;;
  esac
    echo "build platform: ${BUILD_PLATFORM}"
    echo "FF_MAKE_FLAGS: ${FF_MAKE_FLAGS}"
}

function checkPreRequisites {
    if [ -z "$NDK" -a "$NDK" == "" ]; then
        echo -e "\033[31mFailed! NDK is empty. Run 'export NDK=[PATH_TO_NDK]'\033[0m"
        exit
    fi
}

setCurrentPlatform
checkPreRequisites

# armeabi is deprecated in NDK r16. Removed in NDK r17. No hard float.
# TARGET_ARMEABI_DIR=$WORKING_DIR/../jni/ffmpeg/ffmpeg/armeabi
TARGET_ARMEABIV7A_DIR=$WORKING_DIR/../jni/ffmpeg/ffmpeg/armeabi-v7a
TARGET_X86_DIR=$WORKING_DIR/../jni/ffmpeg/ffmpeg/x86
# TARGET_MIPS_DIR=$WORKING_DIR/../jni/ffmpeg/ffmpeg/mips
TARGET_X86_64_DIR=$WORKING_DIR/../jni/ffmpeg/ffmpeg/x86_64
TARGET_ARMEABI_64_DIR=$WORKING_DIR/../jni/ffmpeg/ffmpeg/arm64-v8a

export ENABLE_OPENSSL=true

export NDK=`grep ndk.dir $PROPS | cut -d'=' -f2`

build_target() {
    if [ "$ENABLE_OPENSSL" = true ] ; then
        echo 'Build FFmpeg with openssl support'
        $WORKING_DIR/build_openssl.sh $1 && \
        $WORKING_DIR/build_ffmpeg_with_ssl.sh $1 || exit 1
    else
        ./build_ffmpeg.sh $1
    fi
}

if [ "$NDK" = "" ] || [ ! -d $NDK ]; then
	echo "NDK variable not set or path to NDK is invalid, exiting..."
	exit 1
fi

if [ "$#" -eq 1 ] && [ "$1" = "--with-openssl" ]; then
    ENABLE_OPENSSL=true
   # rm -rf $WORKING_DIR/../jni/ffmpeg/ffmpeg/*
fi

# Make the target JNI folder if it doesn't exist
if [ ! -d $WORKING_DIR/../jni/ffmpeg/ffmpeg ] && ! mkdir -p $WORKING_DIR/../jni/ffmpeg/ffmpeg; then
    echo "Error, could not make $WORKING_DIR/jni/ffmpeg/ffmpeg, exiting..."
    exit 1
fi

if [ ! -d $TARGET_ARMEABI_DIR ]; then
    # Build FFmpeg from ARM architecture and copy to the JNI folder
    cd $WORKING_DIR
    build_target arm
fi

if [ ! -d $TARGET_ARMEABIV7A_DIR ]; then
    # Build FFmpeg from ARM v7 architecture and copy to the JNI folder
    cd $WORKING_DIR
    build_target armv7-a
fi

if [ ! -d $TARGET_X86_DIR ]; then
    # Build FFmpeg from x86 architecture and copy to the JNI folder
    cd $WORKING_DIR
    build_target i686
fi

 if [ ! -d $TARGET_MIPS_DIR ]; then
     # Build FFmpeg from MIPS architecture and copy to the JNI folder
     cd $WORKING_DIR
     build_target mips
 fi

if [ ! -d $TARGET_X86_64_DIR ]; then
    # Build FFmpeg from x86_64 architecture and copy to the JNI folder
    cd $WORKING_DIR
    build_target x86_64
fi

if [ ! -d $TARGET_ARMEABI_64_DIR ]; then
    # Build FFmpeg from arneabi_64 architecture and copy to the JNI folder
    cd $WORKING_DIR
    build_target arm64-v8a
fi

echo Native build complete, exiting...
exit
