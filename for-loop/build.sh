#!/bin/bash

rm -rf target/
mkdir target/

nasm -f elf loop.asm               # assemble
ld -m elf_i386 -s -o loop loop.o   # link
mv loop target/  
rm loop.o