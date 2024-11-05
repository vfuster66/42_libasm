section .note.GNU-stack
section .text
    global ft_list_sort

; Fonction : ft_list_sort
; Trie une liste chaînée en utilisant un algorithme de tri par bulles.
; Paramètres :
;   - rdi : pointeur vers le début de la liste (t_list **begin_list)
;   - rsi : pointeur vers la fonction de comparaison (int (*cmp)())
; Retour :
;   Aucun retour explicite (liste triée en place)

ft_list_sort:
    push    rbp                     ; Configuration du cadre de pile
    mov     rbp, rsp
    push    rbx                     ; Sauvegarde des registres non volatiles
    push    r12
    push    r13
    push    r14
    push    r15

    ; Validation des paramètres d'entrée
    test    rdi, rdi               ; Vérifie si le pointeur begin_list est NULL
    jz      .exit
    test    rsi, rsi               ; Vérifie si la fonction cmp est NULL
    jz      .exit

    mov     r12, rdi               ; r12 = pointeur de début de la liste
    mov     r13, rsi               ; r13 = pointeur vers la fonction de comparaison

.bubble_sort:
    xor     r14, r14               ; Initialise le drapeau "swapped" à 0
    mov     rbx, [r12]             ; rbx = nœud actuel
    mov     r15, [r12]             ; r15 = tête de la liste pour la comparaison

.compare_loop:
    test    rbx, rbx               ; Vérifie si le nœud actuel est NULL
    jz      .check_swapped
    mov     rsi, [rbx + 8]         ; rsi = nœud suivant
    test    rsi, rsi               ; Vérifie si le nœud suivant existe
    jz      .check_swapped

    ; Comparaison des nœuds
    push    rdi                    ; Sauvegarde des registres pouvant être modifiés par cmp
    push    rsi
    mov     rdi, [rbx]             ; Premier argument : données du nœud actuel
    mov     rsi, [rsi]             ; Second argument : données du nœud suivant
    call    r13                    ; Appel de la fonction de comparaison
    pop     rsi
    pop     rdi

    ; Vérifie si un échange est nécessaire
    test    eax, eax
    jle     .no_swap

    ; Échange des nœuds
    mov     r14, 1                 ; Active le drapeau "swapped"
    mov     rdi, [rbx + 8]         ; rdi = nœud suivant
    mov     rdx, [rdi + 8]         ; rdx = suivant du suivant
    mov     [rbx + 8], rdx         ; current->next = next->next
    mov     [rdi + 8], rbx         ; next->next = current

    ; Mise à jour de la tête de la liste si nécessaire
    cmp     rbx, r15               ; Vérifie si on échange la tête
    jne     .continue_swap
    mov     [r12], rdi             ; Mise à jour du pointeur de tête
    mov     r15, rdi               ; Mise à jour de la référence de tête

.continue_swap:
    mov     rbx, rdi               ; Passe au nœud suivant
    jmp     .compare_loop

.no_swap:
    mov     rbx, [rbx + 8]         ; Passe au nœud suivant
    jmp     .compare_loop

.check_swapped:
    test    r14, r14               ; Vérifie si des échanges ont eu lieu
    jnz     .bubble_sort           ; Si oui, effectue un autre passage

.exit:
    pop     r15                    ; Restaure les registres sauvegardés
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    mov     rsp, rbp               ; Restaure le cadre de pile initial
    pop     rbp
    ret                            ; Retourne (liste triée en place)
