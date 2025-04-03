; print_nl.asm
; ----------------------------------------------------------------------------
; Function: print_nl
; Description:
;   Prints a newline (LF) followed by a carriage return (CR) using BIOS
;   teletype output (int 0x10). This function is used in 16-bit real mode.
;
; Input:
;   None (the routine uses BIOS interrupt 0x10).
;
; Registers:
;   Preserves registers using pusha/popa.
; ----------------------------------------------------------------------------
[bits 16]

print_nl:
    pusha
    mov ah, 0x0E         ; BIOS teletype function
    mov al, 0x0A         ; Newline (LF)
    int 0x10
    mov al, 0x0D         ; Carriage return (CR)
    int 0x10
    popa
    ret


; print_string:
;     pusha               ; Save all registers
;     mov ah, 0x0e        ; Set teletype mode for BIOS interrupt

; print_char:
;     mov al, [bx]        ; Load character from bx
;     cmp al, 0           ; Check if we've reached the end of the string
;     je print_end        ; If so, jump to end
    
;     int 0x10            ; Print the character
    
;     add bx, 1           ; Move to next character
;     jmp print_char      ; And repeat
    
; print_end:
;     popa                ; Restore all registers
;     ret                 ; Return to caller

; ; Function: print_nl
; ; Prints a new line
; print_nl:
;     pusha               ; Save all registers
    
;     mov ah, 0x0e        ; BIOS teletype function
;     mov al, 0x0a        ; newline character
;     int 0x10
;     mov al, 0x0d        ; carriage return
;     int 0x10
    
;     popa                ; Restore all registers
;     ret                 ; Return to caller