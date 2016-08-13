#!/bin/sh

# Reset "Mergeable Shared" flags on constant string section of all objects,
# to prevent linker from overlapping them, which makes disassembly slightly
# more effortful.

if [ "$1" == "" ]; then
    echo "Usage $0 <ver_dir>"
    exit 1
fi

cd $1

find -mindepth 2 -name "*.o" | xargs -n1 xtensa-lx106-elf-objcopy --set-section-flags ".rodata.str1.4=alloc,readonly"
