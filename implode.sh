#!/bin/sh
#
# This scripts extracts object files from Espressif SDK libs, and
# links all objects together into a single relocatable object, and
# into a seld-contained executable file.
#

set -e

if [ "$1" == "" ]; then
    echo "Usage $0 <ver_dir>"
    exit 1
fi

if [ ! -d "$1" ]; then
    echo "Create $1/ subdir, and put into it all lib/lib*a from that SDK version, together with ld/eagle.app.v6.ld"
    exit 1
fi

cd $1

TOP=$PWD
echo $TOP
to_link=""

# Remove superfluous/duplicate libs
rm -f liblwip_536.a libupgrade.a libat.a libjson.a libdriver.a libgcc.a

for f in *.a; do
    dir=$(basename $f .a)
    echo $f $dir
    mkdir -p $dir
    cd $dir
    ar x ../$f
    to_link="$to_link $dir/*.o"
    cd $TOP
done

# This references ap_get_sta, which may be not defined in some (all?) SDK versions
rm -f libwpa/ieee802_1x.o
# Duplicate of wpa2/eap_common.o
rm -f libwps/eap_common.o
# Duplicate of wpa2/bignum.o
rm -f libcrypto/bignum.o

../unshare-strings.sh .

xtensa-lx106-elf-ld $to_link -r -o esp8266-sdk-$1.o

# Former implode.sh

xtensa-lx106-elf-gcc -c ../empty_user.c
xtensa-lx106-elf-gcc -c ../empty_libgcc.c

# Different SDK versions use different memory layouts, so we should
# use per-version linker script.
LDSCRIPT=eagle.app.v6.ld

xtensa-lx106-elf-ld \
--emit-relocs \
--no-check-sections \
-nostdlib \
-Map=esp8266-sdk-$1.map --cref \
-L. \
-T $LDSCRIPT \
-T ../region-override.ld \
$to_link ../empty_user.o ../empty_libgcc.o \
-o esp8266-sdk-$1 \
$(xtensa-lx106-elf-gcc -print-file-name=libc.a) \

# No longer link with libgcc to avoid iRAM segment overflow,
# replaced with empty_libgcc.o
#$(xtensa-lx106-elf-gcc -print-libgcc-file-name)

# Options to explore:
#--size-opt \
