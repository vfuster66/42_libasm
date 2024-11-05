section .note.GNU-stack
section .text
    global ft_strcpy

ft_strcpy:
    push    rdi            ; save destination address
    xor     rcx, rcx      ; clear counter register

.copy_loop:
    mov     cl, byte [rsi] ; load byte from source
    mov     byte [rdi], cl ; store byte to destination
    test    cl, cl         ; check for null terminator
    jz      .return        ; if null, we're done
    inc     rdi           ; next destination byte
    inc     rsi           ; next source byte
    jmp     .copy_loop    ; continue copying

.return:
    pop     rax           ; restore original destination address to return
    ret