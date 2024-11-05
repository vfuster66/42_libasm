section .note.GNU-stack
section .text
    global ft_strcmp

ft_strcmp:
    push    rbx                    ; save rbx as we'll use it
    xor     rax, rax              ; clear rax
    xor     rbx, rbx              ; clear rbx

.compare_loop:
    movzx   eax, byte [rdi]       ; load byte from first string, zero-extended
    movzx   ebx, byte [rsi]       ; load byte from second string, zero-extended
    cmp     al, bl                ; compare bytes
    jne     .not_equal            ; if not equal, jump to return difference
    test    al, al                ; test if we hit null terminator
    jz      .equal                ; if yes, strings are equal
    inc     rdi                   ; move to next char in first string
    inc     rsi                   ; move to next char in second string
    jmp     .compare_loop         ; continue comparing

.not_equal:
    sub     eax, ebx              ; calculate difference
    pop     rbx                   ; restore rbx
    ret

.equal:
    xor     eax, eax              ; return 0
    pop     rbx                   ; restore rbx
    ret