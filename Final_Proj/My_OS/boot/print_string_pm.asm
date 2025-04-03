; print_string_pm.asm
; ----------------------------------------------------------------------------
; Function: print_string_pm
; Description:
;   Prints a null‑terminated string in protected mode by writing directly to
;   VGA video memory (starting at 0xB8000). The string pointer is expected in EBX.
;
; Registers:
;   Preserves registers using pusha/popa.
; ----------------------------------------------------------------------------
[bits 32]

print_string_pm:
    pusha
    mov edx, 0xB8000       ; VGA video memory base address
.pm_loop:
    mov al, [ebx]          ; Load character from string (in EBX)
    cmp al, 0              ; Check for end of string
    je .done_pm
    mov ah, 0x0F           ; Attribute byte: white on black
    mov [edx], ax          ; Write character and attribute to video memory
    inc ebx                ; Next character
    add edx, 2             ; Move to next cell (each cell is 2 bytes)
    jmp .pm_loop
.done_pm:
    popa
    ret