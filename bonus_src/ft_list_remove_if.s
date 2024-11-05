section .note.GNU-stack
section .text
    global ft_list_remove_if
    extern free

; void ft_list_remove_if(t_list **begin_list, void *data_ref, 
;                        int (*cmp)(), void (*free_fct)(void*))
; rdi = begin_list, rsi = data_ref, rdx = cmp, rcx = free_fct

ft_list_remove_if:
    push    rbp
    mov     rbp, rsp
    push    rbx                    ; Preserve callee-saved registers
    push    r12
    push    r13
    push    r14
    push    r15

    ; Save parameters
    test    rdi, rdi              ; Check if begin_list is NULL
    jz      .exit
    mov     r12, rdi              ; r12 = begin_list
    mov     r13, rsi              ; r13 = data_ref
    mov     r14, rdx              ; r14 = cmp
    mov     r15, rcx              ; r15 = free_fct

.check_current:
    mov     rbx, [r12]            ; rbx = current node
    test    rbx, rbx              ; Check if current is NULL
    jz      .exit

    ; Compare current node
    push    rdi                   ; Save registers
    push    rsi
    mov     rdi, [rbx]            ; First arg: current->data
    mov     rsi, r13              ; Second arg: data_ref
    call    r14                   ; Call compare function
    pop     rsi
    pop     rdi

    test    eax, eax              ; Check compare result
    jnz     .next_node

    ; Remove current node
    mov     rdi, [rbx]            ; Get data to free
    test    r15, r15              ; Check if free_fct exists
    jz      .skip_free_data
    push    rbx
    call    r15                   ; Call free_fct on data
    pop     rbx

.skip_free_data:
    mov     rdi, rbx              ; Prepare to free node
    mov     rax, [rbx + 8]        ; Save next pointer
    mov     [r12], rax            ; Update list pointer
    push    rax
    call    free                  ; Free current node
    pop     rax
    jmp     .check_current

.next_node:
    mov     r12, rbx              ; Move to next node's address
    add     r12, 8                ; Point to next pointer
    jmp     .check_current

.exit:
    pop     r15                   ; Restore callee-saved registers
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    mov     rsp, rbp
    pop     rbp
    ret