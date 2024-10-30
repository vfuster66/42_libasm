section .text
global ft_list_size

ft_list_size:
    xor     rcx, rcx            ; compteur d'éléments
.loop:
    cmp     rdi, 0              ; vérifier si le nœud est nul
    je      .done                ; si oui, finir
    inc     rcx                 ; incrémenter le compteur
    mov     rdi, [rdi + 8]      ; passer au nœud suivant
    jmp     .loop
.done:
    mov     rax, rcx            ; retourner le compteur
    ret
