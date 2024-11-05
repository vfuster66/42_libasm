section .note.GNU-stack
section .text
    global ft_write
    extern __errno_location          ; import errno location function

ft_write:
    mov     rax, 1                  ; syscall number for write
    syscall                         ; perform syscall
    cmp     rax, 0                  ; check if syscall returned an error
    jl      error                   ; if rax < 0, handle error
    ret                             ; return rax (number of bytes written)

error:
    neg     rax                     ; convert error code to positive
    push    rax                     ; save error code
    call    __errno_location        ; get errno location
    pop     qword [rax]            ; store error code in errno
    mov     rax, -1                ; return -1 to indicate error
    ret