#!/bin/bash

rm -rf target/
mkdir target/

nasm -f elf hello.asm               # assemble
ld -m elf_i386 -s -o hello hello.o  # link
mv hello target/
rm hello.o