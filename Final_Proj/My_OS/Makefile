# Makefile for MyOS

# Directories and source files
C_SOURCES = $(wildcard kernel/*.c) $(wildcard drivers/*.c)
HEADERS = $(wildcard kernel/include/*.h)
OBJ = $(C_SOURCES:.c=.o) kernel/kernel_entry.o

# Cross-compiler settings
CC = x86_64-elf-gcc
LD = x86_64-elf-ld
CFLAGS = -m32 -ffreestanding -O2 -Wall -Wextra -c
LDFLAGS = -T link.ld -Ttext=0x1000 -m elf_i386 -nostdlib

# Default target
all: os-image.bin

# Create the final OS image by concatenating boot sector and kernel.
os-image.bin: boot/bootsect.bin kernel.bin
	cat $^ > os-image.bin

# Link kernel object files to produce a flat binary.
kernel.bin: $(OBJ)
	$(LD) $(LDFLAGS) -o $@ $^ --oformat binary

# Compile C kernel files.
%.o: %.c $(HEADERS)
	$(CC) $(CFLAGS) $< -o $@

# Assemble kernel entry.
kernel/kernel_entry.o: kernel/kernel_entry.asm
	nasm $< -f elf32 -o $@

# Assemble the boot sector (and include all boot-related asm files).
# Assemble the boot sector (and include all boot-related asm files).
boot/bootsect.bin: boot/bootsect.asm boot/print_string.asm boot/print_hex.asm \
                   boot/disk_load.asm boot/gdt.asm boot/print_string_pm.asm \
                   boot/switch_to_pm.asm boot/print_nl.asm
	nasm boot/bootsect.asm -f bin -I './' -o $@

# Run the OS image using QEMU.
run: os-image.bin
	qemu-system-i386 -drive format=raw,file=os-image.bin,index=0,if=floppy

# Clean up build artifacts.
clean:
	rm -f kernel/*.o drivers/*.o boot/*.bin kernel.bin os-image.bin