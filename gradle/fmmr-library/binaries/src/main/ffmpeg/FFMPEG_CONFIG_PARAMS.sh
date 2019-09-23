#! /usr/bin/env bash

#--------------------
# Standard options:
export COMMON_FF_CFG_FLAGS=
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --prefix=PREFIX"

# Licensing options:
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-gpl"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-version3"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-nonfree"

# Configuration options:
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-static"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-shared"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-small"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-runtime-cpudetect"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-gray"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-swscale-alpha"

# Program options:
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-programs"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-ffmpeg"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-ffplay"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-ffprobe"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-ffserver"

# Documentation options:
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-doc"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-htmlpages"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-manpages"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-podpages"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-txtpages"

# Component options:
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-avdevice"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-avcodec"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-avformat"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-avutil"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-swresample"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-swresample"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-swscale"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-postproc"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-avfilter"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-avfilter"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-avresample"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-pthreads"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-w32threads"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-os2threads"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-network"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-dct"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-dwt"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-lsp"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-lzo"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mdct"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-rdft"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-fft"

# Hardware accelerators:
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-hwaccels"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-d3d11va"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-dxva2"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-vaapi"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-vda"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-vdpau"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-videotoolbox"

# Individual component options:
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-everything"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-encoders"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-encoder=png"

# ./configure --list-decoders
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-decoders"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=ac3" # need for aac parser
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=aac"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=aac_latm"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=h264*"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=hevc"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=mpeg4*"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=mpeg2*"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=mp3"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=vp6f"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=vp8"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-decoder=vp9"


# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-hwaccels"

# ./configure --list-muxers
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-muxers"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-muxer=mp4"

# ./configure --list-demuxers
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-demuxers"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=ac3"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=aac"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=mp3"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=concat"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=data"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=hls"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=mov"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=m4v"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=avi"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=avs"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=h264"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=mpeg*"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=yuv4mpegpipe" #jpeg
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=hevc"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-demuxer=webm_dash_manifest"

# ./configure --list-parsers
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-parsers"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=ac3"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=aac"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=aac_latm"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=h264"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=hevc"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=mpeg*"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=vp8"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=vp9"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-parser=png"


# ./configure --list-bsf
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-bsfs"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=aac_adtstoasc"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=imx_dump_header"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=null"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=chomp"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=mjpeg2jpeg"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=remove_extradata"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=dca_core"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=mjpega_dump_header"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=text2movsub"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=dump_extradata"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=mov2textsub"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=vp9_raw_reorder"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=extract_extradata"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=mp3_header_decompress"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=vp9_superframe"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=h264_mp4toannexb"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=mpeg4_unpack_bframes"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=vp9_superframe_split"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=hevc_mp4toannexb"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-bsf=noise"

# ./configure --list-protocols
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocols"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=async"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=librtmp"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=rtmpte"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=bluray"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=librtmpe"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=rtmpts"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=cache"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=librtmps"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=rtp"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=concat"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=librtmpt"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=sctp"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=crypto"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=librtmpte"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=srtp"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=data"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=libsmbclient"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=subfile"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=ffrtmpcrypt"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=libssh"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=tcp"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=ffrtmphttp"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=md5"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=tee"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=file"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=mmsh"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=tls_gnutls"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=ftp"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=mmst"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=tls_openssl"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=gopher"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=pipe"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=tls_schannel"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=hls"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=prompeg"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=tls_securetransport"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=http"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=rtmp"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=udp"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=httpproxy"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=rtmpe"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=udplite"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=https"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=rtmps"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=unix"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=icecast"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=rtmpt"
# old options:
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=async"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=bluray"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=concat"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=crypto"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=ffrtmpcrypt"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=ffrtmphttp"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=gopher"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=icecast"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=librtmp*"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=libssh"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=md5"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=mmsh"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=mmst"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=rtmp*"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=rtmp"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-protocol=rtmpt"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=rtp"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=sctp"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=srtp"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=subfile"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-protocol=unix"


COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-indevs"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-outdevs"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-devices"

COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-filters"

# External library support:
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-iconv"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-audiotoolbox"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-videotoolbox"

# ...

# Advanced options (experts only):
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --cross-prefix=${FF_CROSS_PREFIX}-"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-cross-compile"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --sysroot=PATH"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --sysinclude=PATH"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --target-os=TAGET_OS"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --target-exec=CMD"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --target-path=DIR"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --toolchain=NAME"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --nm=NM"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --ar=AR"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --as=AS"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --yasmexe=EXE"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --cc=CC"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --cxx=CXX"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --dep-cc=DEPCC"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --ld=LD"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-cc=HOSTCC"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-cflags=HCFLAGS"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-cppflags=HCPPFLAGS"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-ld=HOSTLD"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-ldflags=HLDFLAGS"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-libs=HLIBS"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --host-os=OS"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --extra-cflags=ECFLAGS"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --extra-cxxflags=ECFLAGS"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --extra-ldflags=ELDFLAGS"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --extra-libs=ELIBS"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --extra-version=STRING"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --optflags=OPTFLAGS"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --build-suffix=SUFFIX"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --malloc-prefix=PREFIX"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --progs-suffix=SUFFIX"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --arch=ARCH"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --cpu=CPU"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-pic"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-sram"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-thumb"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-symver"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-hardcoded-tables"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-safe-bitstream-reader"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-memalign-hack"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-lto"

# Optimization options (experts only):
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-asm"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-altivec"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-amd3dnow"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-amd3dnowext"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mmx"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mmxext"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-sse"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-sse2"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-sse3"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-ssse3"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-sse4"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-sse42"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-avx"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-fma4"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-armv5te"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-armv6"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-armv6t2"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-vfp"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-neon"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-vis"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-inline-asm"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-yasm"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mips32r2"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mipsdspr1"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mipsdspr2"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-mipsfpu"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-fast-unaligned"

# Developer options (useful when working on FFmpeg itself):
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-coverage"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-debug"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-debug=LEVEL"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-optimizations"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-extra-warnings"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-stripping"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --assert-level=level"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-memory-poisoning"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --valgrind=VALGRIND"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-ftrapv"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --samples=PATH"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-xmm-clobber-test"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-random"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-random"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --enable-random=LIST"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-random=LIST"
# COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --random-seed=VALUE"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-linux-perf"
COMMON_FF_CFG_FLAGS="$COMMON_FF_CFG_FLAGS --disable-bzlib"
