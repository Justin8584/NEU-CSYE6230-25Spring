; -------------------------------------------------------------
; Function: disk_load
; Description:
;   Loads sectors from disk using BIOS interrupt 0x13.
;   Expects:
;     - DH: number of sectors to read.
;     - DL: drive number (passed from boot sector).
;     - ES:BX: destination address in memory for the loaded sectors.
;   On success, the BIOS returns the number of sectors read in AL.
;   On error, error messages are printed and the system hangs.
;
; The function will attempt to read the sectors up to 5 times before
; reporting an error.
; -------------------------------------------------------------

disk_load:
    pusha                   ; Save all general-purpose registers
    push dx                 ; Save DX (contains the original sector count)

    mov cx, 5               ; Set retry counter: try up to 5 times

retry:
    push cx                 ; Save current retry count on stack

    ; --- Reset Disk System ---
    mov ah, 0x00            ; BIOS disk reset function
    int 0x13
    jc reset_error          ; If error (carry set), jump to reset_error

    ; --- Read Sectors from Disk ---
    mov ah, 0x02            ; BIOS read sector function
    mov al, dh              ; Number of sectors to read (from DH)
    mov cl, 0x02            ; Start reading from sector 2 (sector 1 is the boot sector)
    mov ch, 0x00            ; Cylinder 0
    mov dh, 0x00            ; Head 0
    ; DL already contains the boot drive number
    int 0x13                ; BIOS disk read interrupt

    pop cx                  ; Restore retry counter
    jnc success             ; Jump to success if no error (carry clear)

    ; --- Retry if an error occurred ---
    dec cx                  ; Decrement retry counter
    jnz retry               ; If not zero, retry reading
    jmp disk_error          ; If retries exhausted, jump to error handling

reset_error:
    pop cx                  ; Clean up the saved retry count
    dec cx                  ; Decrement retry counter
    jnz retry               ; If retries remain, try again

    ; Fall-through to error handling if still failing

success:
    pop dx                  ; Restore DX (original sector count)
    ; Verify that the BIOS read the expected number of sectors:
    cmp al, dh              ; AL: number of sectors actually read; DH: expected number
    jne sectors_error       ; Jump if the numbers do not match

    popa                    ; Restore all registers saved by pusha
    ret                     ; Return successfully

disk_error:
    ; Print disk read error message and error code, then hang.
    mov bx, DISK_ERROR_MSG
    call print_string
    call print_nl
    mov dx, ax              ; Move error code (AX) into DX for printing
    call print_hex
    jmp disk_loop           ; Infinite loop to halt execution

sectors_error:
    ; Print error message for incorrect number of sectors read.
    mov bx, SECTORS_ERROR_MSG
    call print_string

disk_loop:
    jmp disk_loop           ; Infinite loop to halt execution

; -------------------------------------------------------------
; Error message strings:
RESET_ERROR_MSG   db "Disk reset error", 0
DISK_ERROR_MSG    db "Disk read error", 0
SECTORS_ERROR_MSG db "Incorrect number of sectors read", 0