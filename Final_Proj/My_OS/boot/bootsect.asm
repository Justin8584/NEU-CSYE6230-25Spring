; ---------------------------------------------------------------------------
; Boot sector for MyOS.
; This file is assembled as a flat binary and loaded by the BIOS at 0x7c00.
; It loads the kernel from disk into memory at KERNEL_OFFSET (0x1000),
; then switches to 32-bit Protected Mode and jumps to the kernel.
; ---------------------------------------------------------------------------

[org 0x7c00]               ; BIOS loads the boot sector at 0x7c00
KERNEL_OFFSET equ 0x1000    ; Memory offset where the kernel will be loaded

; Save boot drive (passed in DL by BIOS) into our global variable.
    mov [BOOT_DRIVE], dl

; Set up the stack.
    mov bp, 0x9000         ; Use 0x9000 as stack base (adjust if needed)
    mov sp, bp

; Print a message in 16-bit real mode.
    mov bx, MSG_REAL_MODE
    call print_string

; Load the kernel from disk.
    call load_kernel

; Switch to Protected Mode.
    call switch_to_pm

; Execution should never reach here.
    jmp $

; ---------------------------------------------------------------------------
; Include additional assembly routines.
%include "boot/print_string.asm"
%include "boot/print_hex.asm"
%include "boot/print_nl.asm"
%include "boot/disk_load.asm"
%include "boot/gdt.asm"
%include "boot/print_string_pm.asm"
%include "boot/switch_to_pm.asm"

; ---------------------------------------------------------------------------
; 16-bit code: Kernel loading routine.
[bits 16]
load_kernel:
    ; Print a message indicating kernel loading.
    mov bx, MSG_LOAD_KERNEL
    call print_string

    ; Set up ES:BX so that the kernel is loaded at physical address 0x1000.
    mov ax, 0x0000
    mov es, ax
    mov bx, KERNEL_OFFSET

    ; Load 32 sectors (16 KB) from disk.
    mov dh, 32             ; Number of sectors to read (adjust if needed)
    mov dl, [BOOT_DRIVE]   ; Use the boot drive stored earlier
    call disk_load
    ret

; ---------------------------------------------------------------------------
; 32-bit code: Entry point after switching to Protected Mode.
[bits 32]
BEGIN_PM:
    ; Print a message indicating that we are in protected mode.
    mov ebx, MSG_PROT_MODE
    call print_string_pm

    ; Jump to the kernel's entry point at 0x1000.
    call KERNEL_OFFSET

    ; Hang if the kernel ever returns.
    jmp $

; ---------------------------------------------------------------------------
; Global variables and messages.
BOOT_DRIVE      db 0
MSG_REAL_MODE   db "Started in 16-bit Real Mode", 0
MSG_PROT_MODE   db "Successfully landed in 32-bit Protected Mode", 0
MSG_LOAD_KERNEL db "Loading kernel into memory", 0

; ---------------------------------------------------------------------------
; Fill the boot sector to 510 bytes, then add the boot signature.
times 510-($-$$) db 0
dw 0xaa55