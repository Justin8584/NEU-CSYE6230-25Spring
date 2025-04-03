; print_hex.asm
; ----------------------------------------------------------------------------
; Function: print_hex
; Description:
;   Converts the 16‑bit value in DX into a hexadecimal string (e.g., "0x1A2B")
;   and then prints it using the 16‑bit print_string routine.
;
; Registers:
;   Uses pusha/pop to preserve registers.
;   DX contains the value to print.
;
; Data:
;   HEX_OUT is a buffer initialized with "0x0000" that will be overwritten.
; ----------------------------------------------------------------------------
[bits 16]

print_hex:
    pusha
    mov cx, 4               ; We will process 4 nibbles (4 hex digits)
    mov bx, HEX_OUT + 5     ; Set BX to point just past the last digit position
.hex_loop:
    cmp cx, 0
    je .done_hex
    mov ax, dx              ; Copy DX to AX
    and ax, 0x000F          ; Isolate the lowest 4 bits (a nibble)
    cmp al, 9
    jbe .digit_num
    add al, 55              ; For values 10-15, add 55 to convert to ASCII 'A'-'F'
    jmp .store_digit
.digit_num:
    add al, 48              ; For values 0-9, add 48 to convert to ASCII '0'-'9'
.store_digit:
    dec bx                 ; Move the pointer backward
    mov [bx], al           ; Store the ASCII digit
    shr dx, 4              ; Shift DX right by 4 bits to process the next nibblse
    dec cx
    jmp .hex_loop
.done_hex:
    ; Prepend "0x" to the string in the buffer
    mov byte [HEX_OUT], '0'
    mov byte [HEX_OUT+1], 'x'
    mov bx, HEX_OUT        ; Set BX to point to the start of the string
    call print_string      ; Use the 16-bit print_string to output the hex string
    popa
    ret

; Data buffer for hexadecimal output.
; This buffer must have enough space for "0x" + 4 digits + null terminator.
HEX_OUT: db "0x0000", 0