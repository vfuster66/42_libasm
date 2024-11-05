section .note.GNU-stack
section .text
    extern ft_strlen
    global ft_atoi_base

; Fonction : ft_atoi_base
; Convertit une chaîne de caractères en un entier selon une base donnée.
; Paramètres :
;   - rdi : pointeur vers la chaîne de caractères
;   - rsi : pointeur vers la chaîne représentant la base
; Retour :
;   - rax : l'entier converti, ou 0 en cas d'erreur de base

ft_atoi_base:
    push    rbp                 ; Met en place le cadre de pile
    mov     rbp, rsp
    push    rbx                 ; Sauvegarde rbx
    push    r12                 ; Sauvegarde r12
    push    r13                 ; Sauvegarde r13
    push    r14                 ; Sauvegarde r14
    push    r15                 ; Sauvegarde r15

    ; Sauvegarde des paramètres
    mov     r14, rdi           ; Sauvegarde str (chaîne d'entrée)
    mov     r15, rsi           ; Sauvegarde base (chaîne de base)

    ; Vérifie la validité de la base
    mov     rdi, rsi
    call    check_base
    test    rax, rax           ; Vérifie si la base est valide
    jz      .return            ; Si la base est invalide, retourne 0

    ; Récupère la longueur de la base
    mov     rdi, r15
    call    ft_strlen
    mov     r13, rax           ; Stocke la longueur de la base

    ; Initialisation des variables
    xor     r12, r12           ; result = 0
    mov     rbx, 1             ; sign = 1 (par défaut, nombre positif)

    ; Ignore les espaces blancs
.skip_space:
    movzx   eax, byte [r14]
    cmp     al, ' '
    je      .next_space
    cmp     al, 9              ; '\t'
    jl      .check_sign
    cmp     al, 13             ; '\r'
    jle     .next_space
    jmp     .check_sign

.next_space:
    inc     r14
    jmp     .skip_space

    ; Vérifie le signe du nombre
.check_sign:
    movzx   eax, byte [r14]
    cmp     al, '+'
    je      .next_sign
    cmp     al, '-'
    jne     .convert_loop
    neg     rbx                ; Inverse le signe si '-'
.next_sign:
    inc     r14
    jmp     .check_sign

    ; Boucle de conversion des caractères en entier
.convert_loop:
    movzx   edi, byte [r14]    ; Récupère le caractère actuel
    test    dil, dil           ; Vérifie la fin de la chaîne
    jz      .finish

    mov     rsi, r15           ; base (chaîne de base)
    call    get_digit          ; Convertit le caractère en chiffre de la base
    cmp     rax, -1
    je      .finish            ; Si caractère non valide, termine la conversion

    ; result = result * base_len + digit
    imul    r12, r13           ; Multiplie le résultat actuel par la longueur de la base
    add     r12, rax           ; Ajoute la valeur numérique du caractère

    inc     r14                ; Passe au caractère suivant
    jmp     .convert_loop

.finish:
    imul    r12, rbx           ; Applique le signe au résultat
    mov     rax, r12           ; Place le résultat dans rax

.return:
    ; Restaure les registres sauvegardés
    pop     r15
    pop     r14
    pop     r13
    pop     r12
    pop     rbx
    mov     rsp, rbp           ; Restaure le pointeur de pile
    pop     rbp
    ret                        ; Retourne le résultat

; Fonction auxiliaire : get_digit
; Retourne la valeur numérique d'un caractère dans la base, ou -1 si le caractère est invalide.
get_digit:
    xor     rax, rax           ; Initialise l'index à 0
.loop:
    movzx   edx, byte [rsi + rax]
    test    dl, dl             ; Vérifie la fin de la chaîne
    jz      .not_found
    cmp     dl, dil            ; Compare le caractère avec l'entrée
    je      .found
    inc     rax
    jmp     .loop
.not_found:
    mov     rax, -1            ; Retourne -1 si non trouvé
.found:
    ret

; Fonction auxiliaire : check_base
; Vérifie la validité de la base (caractères uniques et sans +, -, ou espaces)
check_base:
    xor     rcx, rcx           ; i = 0
.outer_loop:
    movzx   eax, byte [rdi + rcx]
    test    al, al             ; Vérifie la fin de la chaîne
    jz      .valid

    ; Vérifie les caractères invalides
    cmp     al, '+'
    je      .invalid
    cmp     al, '-'
    je      .invalid
    cmp     al, ' '
    je      .invalid
    cmp     al, 9              ; '\t'
    jl      .check_next
    cmp     al, 13             ; '\r'
    jle     .invalid

.check_next:
    ; Vérifie les caractères en double dans la base
    mov     rdx, rcx
    inc     rdx
.inner_loop:
    movzx   r8d, byte [rdi + rdx]
    test    r8b, r8b
    jz      .next_outer
    cmp     al, r8b
    je      .invalid
    inc     rdx
    jmp     .inner_loop

.next_outer:
    inc     rcx
    jmp     .outer_loop

.valid:
    mov     rax, 1             ; Base valide
    ret
.invalid:
    xor     rax, rax           ; Base invalide
    ret
