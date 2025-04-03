; switch_to_pm.asm
; ----------------------------------------------------------------------------
; Switch to Protected Mode
;
; This file contains the necessary instructions to switch the CPU from 16-bit
; real mode into 32-bit protected mode:
;   1. Disable interrupts (CLI).
;   2. Load the GDT using LGDT (the GDT descriptor is defined in segmentation.asm).
;   3. Set the Protection Enable (PE) bit in CR0.
;   4. Perform a far jump to flush the prefetch queue and load a new CS.
;
; After the jump, execution continues in 32-bit mode at the label "init_pm".
; ----------------------------------------------------------------------------

[bits 16]
switch_to_pm:
    cli                      ; Disable interrupts
    lgdt [gdt_descriptor]    ; Load GDT (defined in segmentation.asm)
    
    ; Enable Protected Mode by setting PE in CR0:
    mov eax, cr0
    or eax, 0x1              ; Set bit 0 (PE)
    mov cr0, eax

    ; Far jump to update CS. Jump to the label "init_pm" in the new code segment.
    ; CODE_SEG is defined in segmentation.asm.
    jmp CODE_SEG:init_pm

[bits 32]
init_pm:
    ; In protected mode, update all segment registers to use the data segment.
    mov ax, DATA_SEG
    mov ds, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ss, ax

    ; Set up the stack for protected mode.
    mov ebp, 0x90000         ; Set base pointer for the new stack (adjust as needed)
    mov esp, ebp             ; Set the stack pointer

    ; Continue execution in your kernel.
    ; Typically, you'll jump or call a known label (e.g., BEGIN_PM in your boot sector).
    call BEGIN_PM            ; Jump to your kernel's protected mode entry point

    jmp $                    ; Infinite loop in case the call returns