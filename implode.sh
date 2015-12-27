#!/bin/sh
#
# This script takes a single object file as produced by "explode.sh"
# tool and links it into self-contained executable file.
#

set -e

if [ "$1" == "" ]; then
    echo "Usage $0 <ver_dir>"
    exit 1
fi

xtensa-lx106-elf-gcc -c empty_user.c

# Different SDK versions use different memory layouts, so we should
# use per-version linker script.
LDSCRIPT=$1/eagle.app.v6.ld

xtensa-lx106-elf-ld \
--emit-relocs \
--no-check-sections \
-nostdlib \
-L$1 \
-T $LDSCRIPT \
-T region-override.ld \
$1/esp8266-sdk-$1.o empty_user.o \
-o $1/esp8266-sdk-$1 \
$(xtensa-lx106-elf-gcc -print-file-name=libc.a) \
$(xtensa-lx106-elf-gcc -print-libgcc-file-name)
