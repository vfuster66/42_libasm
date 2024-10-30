section .text
global ft_list_sort

ft_list_sort:
    ; Vérifier si la liste est vide ou a un seul élément
    mov rdi, [rsi]              ; rdi = début de la liste
    test rdi, rdi               ; vérifier si rdi est nul
    jz .exit                    ; sortir si la liste est vide
    mov rbx, [rdi + 8]          ; rbx = nœud suivant

    ; Boucle principale pour le tri
.outer_loop:
    xor rcx, rcx                ; rcx = swapped (indique si un échange a eu lieu)
    mov rdi, [rsi]              ; rdi = début de la liste

.inner_loop:
    ; Vérifier si rdi et rbx ne sont pas nuls
    test rdi, rdi               ; vérifier si rdi est nul
    jz .no_swap                 ; sauter si rdi est nul

    ; Comparer les valeurs des nœuds
    mov rax, [rdi]              ; rax = données du nœud courant
    mov rdx, [rbx]              ; rdx = données du nœud suivant
    call rdi                    ; appeler la fonction de comparaison

    ; Si le résultat de cmp > 0, échanger les nœuds
    cmp rax, 0                  ; comparer le résultat
    jle .no_swap                ; sauter si pas besoin d'échanger

    ; Échanger les nœuds
    mov rax, [rdi + 8]          ; sauvegarder le pointeur vers le suivant
    mov [rdi + 8], rbx          ; mettre le suivant du nœud courant au nœud suivant
    mov [rbx + 8], rax          ; lier le nœud courant au nœud suivant de rb
    mov rdi, [rsi]              ; restaurer le début pour la prochaine itération
    mov rcx, 1                  ; marquer qu'un échange a eu lieu

.no_swap:
    mov rdi, [rbx + 8]          ; passer au nœud suivant
    mov rbx, [rbx + 8]          ; avancer dans la liste
    test rbx, rbx               ; vérifier si rbx est nul
    jnz .inner_loop             ; continuer tant qu'il y a des nœuds

    ; Si au moins un échange a eu lieu, continuer le tri
    cmp rcx, 0                  ; vérifier si un échange a eu lieu
    jnz .outer_loop             ; recommencer si un échange a été fait

.exit:
    ret
