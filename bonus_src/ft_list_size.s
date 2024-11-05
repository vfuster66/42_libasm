section .note.GNU-stack
section .text
    global ft_list_size

; size_t ft_list_size(t_list *begin_list)
; Input: rdi = list head pointer
; Output: rax = number of elements in list

ft_list_size:
    push    rbp                 ; Setup stack frame
    mov     rbp, rsp
    push    rbx                 ; Preserve rbx (callee-saved)

    ; Initialize counter and check input
    xor     ebx, ebx           ; Use ebx as counter (32-bit is enough)
    test    rdi, rdi           ; Check if list is NULL
    jz      .return            ; If NULL, return 0

.count_loop:
    inc     ebx                ; Increment counter
    mov     rdi, [rdi + 8]     ; Get next node
    test    rdi, rdi           ; Check if next is NULL
    jnz     .count_loop        ; If not NULL, continue counting

.return:
    mov     eax, ebx           ; Set return value
    pop     rbx                ; Restore preserved register
    mov     rsp, rbp           ; Restore stack
    pop     rbp
    ret