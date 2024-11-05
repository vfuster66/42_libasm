section .note.GNU-stack
section .text
    global ft_read
    extern __errno_location

; ssize_t ft_read(int fd, void *buf, size_t count)
; rdi = file descriptor, rsi = buffer, rdx = count

ft_read:
    push    rbp                     ; Setup stack frame
    mov     rbp, rsp

    mov     rax, 0                  ; syscall number for read
    syscall                         ; make syscall

    ; Check for error
    cmp     rax, 0                  ; check if return value is negative
    jl      .error                  ; if negative, handle error
    jmp     .return                 ; otherwise return normally

.error:
    neg     rax                     ; make error code positive
    push    rax                     ; save error code
    call    __errno_location        ; get errno location
    pop     qword [rax]            ; store error code in errno
    mov     rax, -1                 ; return -1 to indicate error

.return:
    mov     rsp, rbp               ; restore stack
    pop     rbp
    ret