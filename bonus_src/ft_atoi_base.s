section .note.GNU-stack
section .text
    extern ft_strlen
    global ft_atoi_base

ft_atoi_base:
    push    rbp                 ; Set up stack frame
    mov     rbp, rsp
    push    rbx                 ; Preserve rbx
    push    r12                 ; Preserve r12
    push    r13                 ; Preserve r13
    push    r14                 ; Preserve r14
    push    r15                 ; Preserve r15

    ; Save parameters
    mov     r14, rdi           ; Save str
    mov     r15, rsi           ; Save base

    ; Check base validity
    mov     rdi, rsi
    call    check_base
    test    rax, rax           ; Check if base is valid
    jz      .return            ; If not valid, return 0

    ; Get base length
    mov     rdi, r15
    call    ft_strlen
    mov     r13, rax           ; Store base length

    ; Initialize variables
    xor     r12, r12          ; result = 0
    mov     rbx, 1            ; sign = 1

    ; Skip whitespace
.skip_space:
    movzx   eax, byte [r14]
    cmp     al, ' '
    je      .next_space
    cmp     al, 9             ; '\t'
    jl      .check_sign
    cmp     al, 13            ; '\r'
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
    neg     rbx               ; Negate sign
.next_sign:
    inc     r14
    jmp     .check_sign

.convert_loop:
    movzx   edi, byte [r14]   ; Get current char
    test    dil, dil          ; Check for null terminator
    jz      .finish
    
    mov     rsi, r15          ; base string
    call    get_digit
    cmp     rax, -1
    je      .finish

    ; result = result * base_len + digit
    imul    r12, r13
    add     r12, rax
    
    inc     r14
    jmp     .convert_loop

.finish:
    imul    r12, rbx          ; Apply sign
    mov     rax, r12          ; Set return value

.return:
    pop     r15               ; Restore preserved registers
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    mov     rsp, rbp
    pop     rbp
    ret

; Get digit value from character
get_digit:
    xor     rax, rax          ; index = 0
.loop:
    movzx   edx, byte [rsi + rax]
    test    dl, dl            ; Check for end of string
    jz      .not_found
    cmp     dl, dil           ; Compare with input char
    je      .found
    inc     rax
    jmp     .loop
.not_found:
    mov     rax, -1
.found:
    ret

; Check if base is valid
check_base:
    xor     rcx, rcx          ; i = 0
.outer_loop:
    movzx   eax, byte [rdi + rcx]
    test    al, al            ; Check for end of string
    jz      .valid
    
    ; Check for invalid characters
    cmp     al, '+'
    je      .invalid
    cmp     al, '-'
    je      .invalid
    cmp     al, ' '
    je      .invalid
    cmp     al, 9             ; '\t'
    jl      .check_next
    cmp     al, 13            ; '\r'
    jle     .invalid

.check_next:
    ; Check for duplicates
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