section .note.GNU-stack noexec nowrite
section .text
    global ft_write
    extern __errno_location
    default rel

ft_write:
    push    rbp
    mov     rbp, rsp
    
    mov     rax, 1          ; syscall number for write
    syscall
    
    cmp     rax, 0          ; Test if error
    jl      .error          ; Jump if negative (error)
    jmp     .done

.error:
    neg     rax             ; Make error code positive
    push    rax            ; Save error code
    lea     rdi, [rel __errno_location wrt ..got]
    call    [rdi]
    pop     qword [rax]    ; Set errno
    mov     rax, -1        ; Return -1

.done:
    mov     rsp, rbp
    pop     rbp
    ret