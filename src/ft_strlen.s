section .note.GNU-stack
section .text
    global ft_strlen                    ; exporter le nom de la fonction

; Fonction : ft_strlen
; Calcule la longueur d'une chaîne de caractères (sans inclure le caractère nul).
; Paramètres :
;   - rdi : pointeur vers la chaîne de caractères
; Retour :
;   - rax : longueur de la chaîne (nombre de caractères jusqu'au caractère nul)

ft_strlen:
    xor     rax, rax                   ; initialise le compteur de longueur à 0

.loop:                                 ; début de la boucle
    cmp     BYTE [rdi + rax], 0        ; vérifie si le caractère actuel est le caractère nul
    je      .return                    ; si oui, saute à la fin de la fonction
    inc     rax                        ; incrémente le compteur
    jmp     .loop                      ; continue la boucle

.return:
    ret                                ; retourne la longueur de la chaîne dans rax
