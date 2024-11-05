section .note.GNU-stack
section .text
    global ft_list_sort

; void ft_list_sort(t_list **begin_list, int (*cmp)())
; rdi = begin_list, rsi = cmp function pointer

ft_list_sort:
    push    rbp                     ; Setup stack frame
    mov     rbp, rsp
    push    rbx                     ; Save preserved registers
    push    r12
    push    r13
    push    r14
    push    r15

    ; Save parameters and validate input
    test    rdi, rdi               ; Check if begin_list is NULL
    jz      .exit
    test    rsi, rsi               ; Check if cmp function is NULL
    jz      .exit

    mov     r12, rdi               ; r12 = begin_list ptr
    mov     r13, rsi               ; r13 = cmp function

.bubble_sort:
    xor     r14, r14              ; r14 = swapped flag
    mov     rbx, [r12]            ; rbx = current node
    mov     r15, [r12]            ; r15 = list head (for comparison)

.compare_loop:
    test    rbx, rbx              ; Check if current node is NULL
    jz      .check_swapped
    mov     rsi, [rbx + 8]        ; rsi = next node
    test    rsi, rsi              ; Check if next node exists
    jz      .check_swapped

    ; Compare nodes
    push    rdi                   ; Save registers that might be modified by cmp
    push    rsi
    mov     rdi, [rbx]           ; First argument: current node data
    mov     rsi, [rsi]           ; Second argument: next node data
    call    r13                   ; Call comparison function
    pop     rsi
    pop     rdi

    ; Check if swap needed
    test    eax, eax
    jle     .no_swap

    ; Swap nodes
    mov     r14, 1               ; Set swapped flag
    mov     rdi, [rbx + 8]       ; rdi = next node
    mov     rdx, [rdi + 8]       ; rdx = next->next
    mov     [rbx + 8], rdx       ; current->next = next->next
    mov     [rdi + 8], rbx       ; next->next = current

    ; Update list head if needed
    cmp     rbx, r15             ; Check if we're swapping the head
    jne     .continue_swap
    mov     [r12], rdi           ; Update head pointer
    mov     r15, rdi             ; Update head reference

.continue_swap:
    mov     rbx, rdi             ; Move to next node
    jmp     .compare_loop

.no_swap:
    mov     rbx, [rbx + 8]       ; Move to next node
    jmp     .compare_loop

.check_swapped:
    test    r14, r14             ; Check if any swaps occurred
    jnz     .bubble_sort         ; If yes, do another pass

.exit:
    pop     r15                  ; Restore preserved registers
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    mov     rsp, rbp
    pop     rbp
    ret