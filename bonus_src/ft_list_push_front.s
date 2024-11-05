section .note.GNU-stack noexec nowrite
section .text
    global ft_list_push_front
    extern malloc
    extern __errno_location
    default rel

; struct s_list {
;     void *data;    // +0
;     s_list *next;  // +8
; }

ft_list_push_front:
    push    rbp                     ; Set up stack frame
    mov     rbp, rsp
    push    rbx                     ; Save preserved registers
    push    r12
    
    test    rdi, rdi               ; Check if begin_list is NULL
    jz      .error
    mov     rbx, rdi               ; Save begin_list pointer
    mov     r12, rsi               ; Save data pointer
    mov     rdi, 16                ; Size of s_list structure
    call    malloc wrt ..plt
    test    rax, rax               ; Check malloc return
    jz      .malloc_error

    ; Initialize new node
    mov     [rax], r12             ; node->data = data
    mov     rcx, [rbx]             ; Get current first node
    mov     [rax + 8], rcx         ; node->next = *begin_list
    mov     [rbx], rax             ; *begin_list = node

    ; Success path
    xor     eax, eax               ; Return 0 for success
    jmp     .exit

.malloc_error:
    ; Handle malloc error
    call    __errno_location wrt ..plt
    mov     dword [rax], 12        ; Set errno to ENOMEM
    mov     eax, -1                ; Return -1 for error
    jmp     .exit

.error:
    mov     eax, -1                ; Return -1 for invalid input

.exit:
    pop     r12                    ; Restore preserved registers
    pop     rbx
    mov     rsp, rbp
    pop     rbp
    ret