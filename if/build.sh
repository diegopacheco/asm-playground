#!/bin/bash

rm -rf target/
mkdir target/

nasm -f elf if.asm               # assemble
ld -m elf_i386 -s -o if if.o     # link
mv if target/
rm if.o