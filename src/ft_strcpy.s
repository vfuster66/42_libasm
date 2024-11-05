section .note.GNU-stack
section .text
    global ft_strcpy

; Fonction : ft_strcpy
; Copie le contenu d'une chaîne source dans une chaîne de destination.
; Paramètres :
;   - rdi : pointeur vers la chaîne de destination
;   - rsi : pointeur vers la chaîne source
; Retour :
;   - rax : retourne l'adresse de la chaîne de destination

ft_strcpy:
    push    rdi               ; Sauvegarde l'adresse de la destination pour la retourner plus tard
    xor     rcx, rcx          ; Initialise rcx à 0 (utilisé pour charger chaque caractère de la source)

.copy_loop:
    mov     cl, byte [rsi]    ; Charge un octet de la chaîne source dans cl
    mov     byte [rdi], cl    ; Copie l'octet dans la chaîne de destination
    test    cl, cl            ; Vérifie si on a atteint le caractère nul (fin de chaîne)
    jz      .return           ; Si le caractère nul est atteint, la copie est terminée
    inc     rdi               ; Avance au prochain emplacement dans la chaîne de destination
    inc     rsi               ; Avance au prochain caractère dans la chaîne source
    jmp     .copy_loop        ; Continue la boucle de copie

.return:
    pop     rax               ; Restaure l'adresse de départ de la destination pour la retourner
    ret                       ; Retourne l'adresse de la chaîne de destination
