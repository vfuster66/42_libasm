section .note.GNU-stack noexec nowrite
section .text
    global ft_list_remove_if
    extern free
    default rel

; Fonction : ft_list_remove_if
; Supprime les éléments d'une liste chaînée correspondant à une référence de données donnée (`data_ref`).
; Paramètres :
;   - rdi : pointeur vers le début de la liste (pointeur de pointeur)
;   - rsi : référence de données à comparer
;   - rdx : pointeur vers une fonction de comparaison `cmp()`
;   - rcx : pointeur vers une fonction de libération de mémoire `free_fct()`
; Retour :
;   - Aucun retour explicite, mais les éléments correspondants sont supprimés de la liste chaînée.

ft_list_remove_if:
    push    rbp                    ; Configuration du cadre de pile
    mov     rbp, rsp
    push    rbx                    ; Sauvegarde des registres non volatils
    push    r12
    push    r13
    push    r14
    push    r15

    ; Sauvegarde des paramètres et vérification de `begin_list`
    test    rdi, rdi               ; Vérifie si `begin_list` est NULL
    jz      .exit                  ; Si NULL, termine la fonction
    mov     r12, rdi               ; r12 = begin_list (adresse du pointeur de la liste)
    mov     r13, rsi               ; r13 = data_ref
    mov     r14, rdx               ; r14 = cmp (fonction de comparaison)
    mov     r15, rcx               ; r15 = free_fct (fonction de libération)

.check_current:
    mov     rbx, [r12]             ; rbx = pointeur vers le nœud actuel
    test    rbx, rbx               ; Vérifie si le nœud actuel est NULL
    jz      .exit                  ; Si NULL, fin de la liste, quitte la fonction

    ; Appel de la fonction de comparaison pour vérifier si les données correspondent
    push    rdi                    ; Sauvegarde des registres utilisés
    push    rsi
    mov     rdi, [rbx]             ; Premier argument : données du nœud actuel (rbx->data)
    mov     rsi, r13               ; Deuxième argument : data_ref
    call    r14                    ; Appel de la fonction `cmp`
    pop     rsi                    ; Restauration des registres
    pop     rdi

    test    eax, eax               ; Vérifie le résultat de la comparaison
    jnz     .next_node             ; Si non égal (eax != 0), passer au nœud suivant

    ; Suppression du nœud actuel si les données correspondent
    mov     rdi, [rbx]             ; rdi = données du nœud actuel (pour libération)
    test    r15, r15               ; Vérifie si `free_fct` existe
    jz      .skip_free_data        ; Si NULL, ne pas libérer les données
    push    rbx                    ; Sauvegarde du pointeur du nœud actuel
    push    rax                    ; Alignement de la pile pour l'appel
    call    r15                    ; Appel de `free_fct` pour libérer les données
    pop     rax                    ; Nettoyage de la pile
    pop     rbx                    ; Restauration du pointeur du nœud actuel

.skip_free_data:
    mov     rdi, rbx               ; rdi = nœud actuel à libérer
    mov     rax, [rbx + 8]         ; rax = pointeur vers le nœud suivant
    mov     [r12], rax             ; Met à jour le pointeur précédent pour sauter le nœud supprimé
    push    rax
    call    free wrt ..plt         ; Libère la mémoire du nœud actuel avec `free`
    pop     rax
    jmp     .check_current         ; Continue avec le nœud suivant

.next_node:
    mov     r12, rbx               ; Avance `begin_list` pour traiter le nœud suivant
    add     r12, 8                 ; Pointe vers le champ `next`
    jmp     .check_current         ; Continue le parcours de la liste

.exit:
    ; Restauration des registres
    pop     r15                    
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    mov     rsp, rbp               ; Restaure le cadre de pile
    pop     rbp
    ret                            ; Retourne
