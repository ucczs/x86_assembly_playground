# x86 assembler playground

## Purpose
* This is a playground to learn x86 assembler on a 64-bit linux system.
* For building up a first basic understanding of x86 assembler this series of post is used: https://github.com/0xAX/asm/blob/master/README.md
* install necessary tools via:
  ```
  sudo apt-get install gcc nasm binutils
  ```
* build and run binary:
  ```
  export BIN_NAME=01_hello_world
  nasm -f elf64 -o build/$BIN_NAME.o $BIN_NAME.asm && ld -o build/$BIN_NAME build/$BIN_NAME.o
  ./build/$BIN_NAME
  ```