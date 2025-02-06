section .note.GNU-stack noexec nowrite
section .text
    global ft_list_sort

ft_list_sort:
    push    rbp
    mov     rbp, rsp
    push    rbx 
    push    r12
    push    r13
    push    r14
    push    r15

    test    rdi, rdi
    jz      .exit
    test    rsi, rsi
    jz      .exit

    mov     r12, rdi        ; begin_list
    mov     r13, rsi        ; cmp function
    mov     r14, 1          ; swapped flag

.sort_loop:
    test    r14, r14
    jz      .exit

    xor     r14, r14
    mov     rbx, [r12]      ; current = *begin_list
    test    rbx, rbx
    jz      .exit

.compare:
    mov     r15, [rbx + 8]  ; next
    test    r15, r15
    jz      .sort_loop      ; if next is null, restart sort

    push    rdi
    push    rsi
    mov     rdi, [rbx]      ; current->data
    mov     rsi, [r15]      ; next->data
    call    r13             ; compare
    pop     rsi
    pop     rdi

    test    eax, eax
    jle     .next           ; if <= 0, no swap needed

    ; Swap data
    mov     rdi, [rbx]
    mov     rsi, [r15]
    mov     [rbx], rsi
    mov     [r15], rdi
    mov     r14, 1          ; mark as swapped

.next:
    mov     rbx, r15
    jmp     .compare

.exit:
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    pop     rbp
    ret