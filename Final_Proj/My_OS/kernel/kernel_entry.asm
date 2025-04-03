[bits 32]               ; We're in 32-bit protected mode
[extern main]           ; Declare that we will be referencing the external symbol 'main'
                        ; so the linker can substitute the final address

global _start           ; Export the _start symbol for the linker

_start:
    call main           ; invoke main() in our C kernel
    jmp $               ; Hang forever when we return from the kernel