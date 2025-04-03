; kernel_entry.asm
; ----------------------------------------------------------------------------
; This file serves as the kernel's entry point after the bootloader switches
; the CPU to 32-bit protected mode. It calls the main() function defined in your
; C kernel code. Ensure that your linker script places _start at virtual address 0x1000.
; ----------------------------------------------------------------------------

[bits 32]
global _start
extern main

section .text
_start:
    call main
.hang:
    jmp .hang
    