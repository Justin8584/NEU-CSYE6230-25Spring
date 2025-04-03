; segmentation.asm
; ----------------------------------------------------------------------------
; Global Descriptor Table (GDT) Setup
;
; In protected mode, the CPU uses segment descriptors to determine the base,
; limit, and access rights for code and data segments. This file sets up a minimal
; GDT with:
;   - A null descriptor (mandatory)
;   - A code segment descriptor (for executing code)
;   - A data segment descriptor (for data access)
;
; It also defines a GDT descriptor structure (pointer) for the LGDT instruction.
; ----------------------------------------------------------------------------

gdt_start:
    ; Null descriptor (must be first)
    dq 0

    ; Code Segment Descriptor:
    ; - Base = 0x00000000, Limit = 0xFFFFF (with granularity = 4KB → 4GB)
    ; - Access: Present, Ring 0, Code Segment, Executable, Readable.
    ; - Flags: 32-bit segment, 4KB granularity.
gdt_code:
    dw 0xFFFF           ; Limit (low 16 bits)
    dw 0x0000           ; Base (low 16 bits)
    db 0x00             ; Base (next 8 bits)
    db 10011010b        ; Access byte: 1 00 1 1010b (Present, ring 0, code segment, executable, readable)
    db 11001111b        ; Flags: 1100 (4KB granularity, 32-bit) + high 4 bits of limit (0xF)
    db 0x00             ; Base (high 8 bits)

    ; Data Segment Descriptor:
    ; - Base = 0x00000000, Limit = 0xFFFFF (4GB with granularity)
    ; - Access: Present, Ring 0, Data Segment, Writable.
    ; - Flags: 32-bit segment, 4KB granularity.
gdt_data:
    dw 0xFFFF           ; Limit (low 16 bits)
    dw 0x0000           ; Base (low 16 bits)
    db 0x00             ; Base (next 8 bits)
    db 10010010b        ; Access byte: 1 00 1 0010b (Present, ring 0, data segment, writable)
    db 11001111b        ; Flags: 1100 (4KB granularity, 32-bit) + high 4 bits of limit (0xF)
    db 0x00             ; Base (high 8 bits)

gdt_end:

; GDT Descriptor (pointer) for LGDT:
gdt_descriptor:
    dw gdt_end - gdt_start - 1   ; Size of the GDT minus one
    dd gdt_start                 ; Linear address of the GDT

; For convenience, define segment selector constants:
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start