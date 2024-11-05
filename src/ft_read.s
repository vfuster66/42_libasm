section .note.GNU-stack noexec nowrite
section .text
    global ft_read
    extern __errno_location
    default rel

; Fonction : ft_read
; Lit un certain nombre d'octets depuis un descripteur de fichier dans un buffer.
; Paramètres :
;   - rdi : descripteur de fichier
;   - rsi : adresse du buffer où stocker les données lues
;   - rdx : nombre d'octets à lire
; Retour :
;   - rax : nombre d'octets lus en cas de succès, ou -1 en cas d'erreur (et errno est mis à jour)

ft_read:
    push    rbp                   ; Sauvegarde le cadre de pile
    mov     rbp, rsp              ; Crée un nouveau cadre de pile
    
    mov     rax, 0                ; Initialise rax pour l'appel système "read" (numéro 0 pour lire)
    syscall                        ; Exécute l'appel système
    
    cmp     rax, 0                ; Vérifie si une erreur s'est produite
    jl      .error                ; Saute à l'erreur si le retour est négatif
    jmp     .done                 ; Sinon, va à la fin de la fonction

.error:
    neg     rax                   ; Rend le code d'erreur positif
    push    rax                   ; Sauvegarde le code d'erreur sur la pile
    lea     rdi, [rel __errno_location wrt ..got] ; Charge l'adresse de errno
    call    [rdi]                 ; Appelle la fonction pour récupérer errno
    pop     qword [rax]           ; Stocke le code d'erreur dans errno
    mov     rax, -1               ; Retourne -1 pour indiquer une erreur

.done:
    mov     rsp, rbp              ; Restaure le cadre de pile
    pop     rbp
    ret                           ; Retourne le nombre d'octets lus (ou -1 en cas d'erreur)
