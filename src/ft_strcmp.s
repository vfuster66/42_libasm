
section .text
global ft_strcmp

ft_strcmp:
    xor rax, rax
.compare_loop:
    mov al, [rdi]
    mov bl, [rsi]
    cmp al, bl
    jne .not_equal
    test al, al
    jz .equal
    inc rdi
    inc rsi
    jmp .compare_loop

.not_equal:
    movzx rax, al
    movzx rbx, bl
    sub rax, rbx
    ret

.equal:
    xor rax, rax
    ret
