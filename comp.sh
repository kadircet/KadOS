nasm -fbin -o boot/boot.o boot/boot.s
nasm -fbin -o boot/setup.o boot/setup.s
nasm -faout -o boot/head.o boot/head.s

gcc -Wall -O -fstrength-reduce -fomit-frame-pointer -finline-functions -nostdinc -c -o init/k_main.o init/k_main.c

ld -s -x -M --oformat binary -s -x -M --oformat binary -e _start -o bin/system boot/head.o init/k_main.o > ld.out

cat boot/boot.o boot/setup.o > bin/boot
cat bin/boot bin/system > bin/KadOS

#bochs -f asdf

