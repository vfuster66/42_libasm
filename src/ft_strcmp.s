section .note.GNU-stack
section .text
    global ft_strcmp

; Fonction : ft_strcmp
; Compare deux chaînes de caractères octet par octet.
; Paramètres :
;   - rdi : pointeur vers la première chaîne
;   - rsi : pointeur vers la seconde chaîne
; Retour :
;   - rax : 0 si les chaînes sont égales
;          un nombre positif ou négatif indiquant la différence si elles sont différentes

ft_strcmp:
    push    rbx                    ; Sauvegarde rbx, qui sera utilisé
    xor     rax, rax               ; Initialise rax à 0 (utilisé pour le caractère courant de la première chaîne)
    xor     rbx, rbx               ; Initialise rbx à 0 (utilisé pour le caractère courant de la seconde chaîne)

.compare_loop:
    movzx   eax, byte [rdi]        ; Charge l'octet actuel de la première chaîne dans eax avec extension à 0
    movzx   ebx, byte [rsi]        ; Charge l'octet actuel de la seconde chaîne dans ebx avec extension à 0
    cmp     al, bl                 ; Compare les octets actuels des deux chaînes
    jne     .not_equal             ; Si les octets sont différents, va au label .not_equal pour retourner la différence
    test    al, al                 ; Vérifie si le caractère nul (fin de chaîne) est atteint
    jz      .equal                 ; Si on a atteint le caractère nul, les chaînes sont égales, va au label .equal
    inc     rdi                    ; Avance au caractère suivant dans la première chaîne
    inc     rsi                    ; Avance au caractère suivant dans la seconde chaîne
    jmp     .compare_loop          ; Boucle pour continuer la comparaison

.not_equal:
    sub     eax, ebx               ; Calcule la différence entre les deux caractères courants
    pop     rbx                    ; Restaure rbx
    ret                            ; Retourne la différence (indique les chaînes sont différentes)

.equal:
    xor     eax, eax               ; Place 0 dans eax pour indiquer que les chaînes sont égales
    pop     rbx                    ; Restaure rbx
    ret                            ; Retourne 0
