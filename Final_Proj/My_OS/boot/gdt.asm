; gdt.asm
; -----------------------------------------------------------------------------
; Global Descriptor Table (GDT) setup for MyOS
; -----------------------------------------------------------------------------
; When switching to 32-bit protected mode, the CPU requires valid segment
; descriptors for code and data. The GDT defines these segments. Without a
; proper GDT, your system would crash or behave unpredictably in protected mode.
;
; This file defines a minimal GDT with:
;   - A null descriptor (mandatory as the first entry)
;   - A code segment descriptor (for executing code)
;   - A data segment descriptor (for data access)
;
; It also defines a GDT descriptor structure (pointer) used by the LGDT
; instruction to load the GDT into the CPU.
; -----------------------------------------------------------------------------

; Start of the GDT
gdt_start:
    ; 0. Null descriptor (must be the first entry)
    dd 0x0
    dd 0x0

; 1. Code Segment Descriptor
gdt_code:
    ; Limit: 0xFFFFF (20 bits, for a 4GB segment with 4KB granularity)
    ; Base:  0x00000000 (flat memory model)
    ; Access byte: 0x9A = 1 00 1 1010b
    ;    - Present (bit 7 = 1)
    ;    - DPL = 00 (ring 0)
    ;    - Descriptor Type = 1 (code/data)
    ;    - Executable = 1 (code segment)
    ;    - Direction/Conforming = 0
    ;    - Readable = 1
    ;    - Accessed = 0
    ; Flags: 0xCF = 1100 1111b
    ;    - Granularity = 1 (limit scaled by 4KB)
    ;    - 32-bit segment = 1
    ;    - 0 (always 0)
    ;    - 0 (available for system use)
    dw 0xFFFF            ; Limit (low 16 bits)
    dw 0x0000            ; Base (low 16 bits)
    db 0x00              ; Base (next 8 bits)
    db 10011010b         ; Access byte
    db 11001111b         ; Flags (high 4 bits of limit + flags)
    db 0x00              ; Base (high 8 bits)

; 2. Data Segment Descriptor
gdt_data:
    ; Data segment: similar to code, but Access byte differs slightly.
    ; Access byte: 0x92 = 1 00 1 0010b
    ;    - Present, Ring 0, data segment, writable.
    dw 0xFFFF            ; Limit (low 16 bits)
    dw 0x0000            ; Base (low 16 bits)
    db 0x00              ; Base (next 8 bits)
    db 10010010b         ; Access byte for data segment
    db 11001111b         ; Flags: same as code segment
    db 0x00              ; Base (high 8 bits)

; End of the GDT
gdt_end:

; GDT Descriptor (pointer to GDT)
; This structure is loaded into the GDTR using the LGDT instruction.
gdt_descriptor:
    dw gdt_end - gdt_start - 1   ; Size of the GDT in bytes minus one
    dd gdt_start                 ; Linear address of the start of the GDT

; For convenience, define constants for segment selectors.
; These values are offsets (in bytes) from gdt_start.
CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start