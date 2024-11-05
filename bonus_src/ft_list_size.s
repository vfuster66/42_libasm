section .note.GNU-stack
section .text
    global ft_list_size

; Fonction : ft_list_size
; Compte le nombre d'éléments dans une liste chaînée.
; Paramètres :
;   - rdi : pointeur vers le premier nœud de la liste
; Retour :
;   - rax : nombre d'éléments dans la liste

ft_list_size:
    push    rbp                 ; Configuration du cadre de pile
    mov     rbp, rsp
    push    rbx                 ; Sauvegarde du registre rbx (non volatile)

    ; Initialisation du compteur et vérification du pointeur d'entrée
    xor     ebx, ebx           ; Initialise ebx à 0 pour servir de compteur
    test    rdi, rdi           ; Vérifie si le pointeur de liste est NULL
    jz      .return            ; Si la liste est NULL, retourne 0

.count_loop:
    inc     ebx                ; Incrémente le compteur pour chaque nœud
    mov     rdi, [rdi + 8]     ; Avance vers le nœud suivant en utilisant le pointeur `next`
    test    rdi, rdi           ; Vérifie si le pointeur vers le prochain nœud est NULL
    jnz     .count_loop        ; Si non NULL, continue la boucle de comptage

.return:
    mov     eax, ebx           ; Place le compteur final dans rax pour le retour
    pop     rbx                ; Restaure le registre rbx
    mov     rsp, rbp           ; Restaure le cadre de pile initial
    pop     rbp
    ret                        ; Retourne le nombre de nœuds (dans rax)
