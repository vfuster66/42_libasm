section .note.GNU-stack noexec nowrite
section .text
    global ft_strdup
    extern malloc
    extern ft_strlen
    extern ft_strcpy

; Fonction : ft_strdup
; Alloue de la mémoire pour copier une chaîne de caractères et retourne un pointeur vers cette copie.
; Paramètres :
;   - rdi : pointeur vers la chaîne source
; Retour :
;   - rax : pointeur vers la chaîne dupliquée, ou NULL si l'allocation de mémoire échoue

ft_strdup:
    push    rbp             ; Prépare le cadre de pile
    mov     rbp, rsp
    push    rdi             ; Sauvegarde le pointeur de la chaîne source

    ; Obtenir la longueur de la chaîne source
    call    ft_strlen       ; Appelle ft_strlen pour obtenir la taille de la chaîne
    inc     rax             ; Ajoute 1 pour inclure le caractère nul de fin

    ; Appeler malloc pour allouer la mémoire
    mov     rdi, rax        ; Prépare la taille de l'allocation pour malloc
    call    malloc WRT ..plt; Appel de malloc via la table des procédures PLT

    test    rax, rax        ; Vérifie si malloc a échoué
    jz      error           ; Si malloc échoue, aller au gestionnaire d'erreurs

    ; Copier la chaîne source dans la mémoire allouée
    mov     rdi, rax        ; Prépare l'adresse de destination pour strcpy
    pop     rsi             ; Restaure le pointeur source (paramètre pour ft_strcpy)
    push    rax             ; Sauvegarde le pointeur alloué pour le retour

    call    ft_strcpy       ; Copie la chaîne source dans la mémoire allouée

    pop     rax             ; Récupère le pointeur alloué pour le retourner

    mov     rsp, rbp        ; Rétablit le cadre de pile
    pop     rbp
    ret

error:
    pop     rdi             ; Nettoie la pile en cas d'erreur
    mov     rax, 0          ; Retourne NULL pour indiquer l'échec
    mov     rsp, rbp        ; Rétablit le cadre de pile
    pop     rbp
    ret
