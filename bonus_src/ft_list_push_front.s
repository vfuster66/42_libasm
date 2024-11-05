section .note.GNU-stack noexec nowrite
section .text
    global ft_list_push_front
    extern malloc
    extern __errno_location
    default rel

; Fonction : ft_list_push_front
; Ajoute un nouvel élément en tête de la liste chaînée.
; Paramètres :
;   - rdi : pointeur vers le pointeur du début de la liste (begin_list)
;   - rsi : pointeur vers les données à insérer dans le nouvel élément
; Retour :
;   - eax : 0 en cas de succès, -1 en cas d'erreur (avec errno défini si malloc échoue)

ft_list_push_front:
    push    rbp                     ; Configuration du cadre de pile
    mov     rbp, rsp
    push    rbx                     ; Sauvegarde des registres préservés
    push    r12
    
    test    rdi, rdi               ; Vérifie si begin_list est NULL
    jz      .error                 ; Si NULL, retourne une erreur
    mov     rbx, rdi               ; Sauvegarde le pointeur de begin_list
    mov     r12, rsi               ; Sauvegarde le pointeur de données
    mov     rdi, 16                ; Taille de la structure s_list (16 octets)
    call    malloc wrt ..plt       ; Appelle malloc pour allouer la mémoire
    test    rax, rax               ; Vérifie le retour de malloc
    jz      .malloc_error          ; Si malloc échoue, retourne une erreur

    ; Initialisation du nouveau nœud
    mov     [rax], r12             ; node->data = data (le champ data pointe sur les données)
    mov     rcx, [rbx]             ; Récupère l'actuel premier nœud
    mov     [rax + 8], rcx         ; node->next = *begin_list (le champ next pointe sur l'actuel premier nœud)
    mov     [rbx], rax             ; *begin_list = node (begin_list pointe sur le nouveau nœud)

    ; Chemin de succès
    xor     eax, eax               ; Retourne 0 pour indiquer le succès
    jmp     .exit

.malloc_error:
    ; Gestion de l'erreur malloc
    call    __errno_location wrt ..plt    ; Obtient l'emplacement de errno
    mov     dword [rax], 12               ; Définit errno à ENOMEM (erreur de mémoire)
    mov     eax, -1                       ; Retourne -1 pour indiquer une erreur
    jmp     .exit

.error:
    mov     eax, -1                        ; Retourne -1 pour une entrée invalide

.exit:
    pop     r12                            ; Restaure les registres préservés
    pop     rbx
    mov     rsp, rbp                       ; Restaure le cadre de pile
    pop     rbp
    ret                                    ; Retourne
