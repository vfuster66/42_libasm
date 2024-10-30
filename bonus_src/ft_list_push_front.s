section .text
extern malloc
global ft_list_push_front

ft_list_push_front:
    push    rdi                 ; sauvegarder rdi
    push    rsi                 ; sauvegarder rsi

    mov     rsi, [rdi]          ; rsi = début de la liste
    call    malloc              ; allouer de la mémoire pour le nouveau nœud
    test    rax, rax            ; vérifier l'allocation
    jz      .exit               ; sortir si échec

    mov     [rax], rdx          ; stocker les données dans le nouveau nœud
    mov     [rax + 8], rsi      ; lier le nouveau nœud au début de la liste
    mov     [rdi], rax          ; mettre à jour le début de la liste

.exit:
    pop     rsi                 ; restaurer rsi
    pop     rdi                 ; restaurer rdi
    ret
