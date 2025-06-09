#!/bin/bash

rm -rf target/
mkdir target/

nasm -f elf main.asm               # assemble
ld -m elf_i386 -s -o main main.o  # link
mv main target/
rm main.o