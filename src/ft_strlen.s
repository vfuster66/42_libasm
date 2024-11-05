section .note.GNU-stack
section .text
    global ft_strlen                    ; export function name

ft_strlen:
    xor     rax, rax                   ; initialize counter to 0
.loop:                                 ; local label with dot prefix is cleaner
    cmp     BYTE [rdi + rax], 0        ; check for null terminator
    je      .return                    ; jump if null found
    inc     rax                        ; increment counter
    jmp     .loop                      ; continue loop
.return:
    ret                                ; return string length in rax