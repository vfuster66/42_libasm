section .note.GNU-stack
section .text
    extern ft_strlen
    global ft_atoi_base

ft_atoi_base:
    push    rbp
    mov     rbp, rsp
    push    rbx
    push    r12
    push    r13
    push    r14
    push    r15

    test    rdi, rdi           ; Check str
    jz      .return_zero
    test    rsi, rsi           ; Check base
    jz      .return_zero

    mov     r14, rdi           ; Save str
    mov     r15, rsi           ; Save base

    ; Check base validity
    mov     rdi, rsi
    call    check_base
    test    rax, rax
    jz      .return_zero

    ; Get base length
    mov     rdi, r15
    call    ft_strlen
    cmp     rax, 1            ; Base must be at least 2 chars
    jle     .return_zero
    mov     r13, rax          ; Store base length

    xor     r12, r12          ; result = 0
    mov     rbx, 1            ; sign = 1

.skip_space:
    movzx   eax, byte [r14]
    cmp     al, ' '
    je      .next_space
    cmp     al, 9
    jl      .check_sign
    cmp     al, 13
    jle     .next_space
    jmp     .check_sign

.next_space:
    inc     r14
    jmp     .skip_space

.check_sign:
    movzx   eax, byte [r14]
    cmp     al, '+'
    je      .next_sign
    cmp     al, '-'
    jne     .convert_loop
    neg     rbx
.next_sign:
    inc     r14
    jmp     .check_sign

.convert_loop:
    movzx   edi, byte [r14]
    test    dil, dil
    jz      .finish

    mov     rsi, r15
    call    get_digit
    cmp     rax, -1
    je      .return_zero      ; Invalid char = return 0

    imul    r12, r13
    add     r12, rax
    inc     r14
    jmp     .convert_loop

.finish:
    imul    r12, rbx
    mov     rax, r12
    jmp     .return

.return_zero:
    xor     rax, rax

.return:
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    mov     rsp, rbp
    pop     rbp
    ret

get_digit:
    xor     rax, rax
.loop:
    movzx   edx, byte [rsi + rax]
    test    dl, dl
    jz      .not_found
    cmp     dl, dil
    je      .found
    inc     rax
    jmp     .loop
.not_found:
    mov     rax, -1
.found:
    ret

check_base:
    cmp     byte [rdi], 0     ; Empty base
    je      .invalid
    
    xor     rcx, rcx
.outer_loop:
    movzx   eax, byte [rdi + rcx]
    test    al, al
    jz      .valid

    cmp     al, '+'
    je      .invalid
    cmp     al, '-'
    je      .invalid
    cmp     al, ' '
    je      .invalid
    cmp     al, 9
    jl      .check_next
    cmp     al, 13
    jle     .invalid

.check_next:
    mov     rdx, rcx
    inc     rdx
.inner_loop:
    movzx   r8d, byte [rdi + rdx]
    test    r8b, r8b
    jz      .next_outer
    cmp     al, r8b
    je      .invalid
    inc     rdx
    jmp     .inner_loop

.next_outer:
    inc     rcx
    jmp     .outer_loop

.valid:
    mov     rax, 1
    ret
.invalid:
    xor     rax, rax
    ret
