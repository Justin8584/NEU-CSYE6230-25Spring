; print_string.asm
; ----------------------------------------------------------------------------
; Function: print_string
; Description:
;   Prints a null‑terminated string using the BIOS teletype function.
;   The pointer to the string is expected in BX.
;
; Registers:
;   Preserves registers by pushing all (pusha/popa).
; ----------------------------------------------------------------------------
[bits 16]

print_string:
    pusha                  ; Save registers
.print_loop:
    mov al, [bx]           ; Load next character from string
    cmp al, 0              ; Check for null terminator
    je .done
    mov ah, 0x0E           ; BIOS teletype function (print character)
    int 0x10               ; Call BIOS interrupt
    inc bx                 ; Move to next character
    jmp .print_loop        ; Repeat
.done:
    popa                   ; Restore registers
    ret