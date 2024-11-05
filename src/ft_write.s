section .note.GNU-stack noexec nowrite
section .text
    global ft_write
    extern __errno_location
    default rel

; Fonction : ft_write
; Effectue une écriture de données en utilisant un appel système.
; Paramètres :
;   - rdi : descripteur de fichier (fd)
;   - rsi : adresse du buffer contenant les données à écrire
;   - rdx : nombre d'octets à écrire
; Retour :
;   - rax : nombre d'octets écrits, ou -1 en cas d'erreur

ft_write:
    push    rbp                     ; Sauvegarde le pointeur de base actuel
    mov     rbp, rsp                ; Crée un nouveau cadre de pile
    
    mov     rax, 1                  ; Définit rax à 1 (numéro de syscall pour write)
    syscall                         ; Exécute l'appel système pour write
    
    cmp     rax, 0                  ; Vérifie si rax est négatif (indiquant une erreur)
    jl      .error                  ; Si erreur, saute au code de gestion d'erreur
    jmp     .done                   ; Sinon, saute à la fin pour retourner

.error:
    neg     rax                     ; Rend le code d'erreur positif
    push    rax                     ; Sauvegarde le code d'erreur sur la pile
    lea     rdi, [rel __errno_location wrt ..got] ; Charge l'adresse de errno
    call    [rdi]                   ; Appelle __errno_location pour récupérer errno
    pop     qword [rax]             ; Stocke le code d'erreur dans errno
    mov     rax, -1                 ; Retourne -1 pour indiquer une erreur

.done:
    mov     rsp, rbp                ; Restaure le pointeur de pile
    pop     rbp                     ; Restaure le cadre de pile
    ret                             ; Retourne le nombre d'octets écrits ou -1 en cas d'erreur
