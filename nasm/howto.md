./abap program.ok > program.asm
nasm -f elf32 program.asm
gcc -m32 -o program program.o io.c
./program

