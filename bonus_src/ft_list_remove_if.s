section .text
extern ft_strcmp  ; Déclaration de ft_strcmp
extern free       ; Déclaration de la fonction free
global ft_list_remove_if

ft_list_remove_if:
    ; Vérifier si la liste est vide
    mov rdi, [rsi]              ; rdi = début de la liste
    test rdi, rdi               ; vérifier si rdi est nul
    jz .exit                    ; sortir si la liste est vide

    ; Initialisation
    mov rcx, rdi                ; rcx = nœud courant
    mov rdx, rsi                ; rdx = adresse de la tête de la liste

.loop:
    ; Comparer les données avec data_ref
    mov rsi, [rcx]              ; rsi = données du nœud courant
    mov rdi, rdx                ; rdi = data_ref
    call ft_strcmp              ; appel à ft_strcmp

    ; Vérifier si ft_strcmp retourne 0 (élément à supprimer)
    cmp rax, 0                  ; si rax est 0, alors supprimer
    jne .not_to_remove          ; sauter si pas à supprimer

    ; Appeler free pour libérer l'élément
    mov rsi, rcx                ; rsi = nœud à libérer
    call free                   ; libérer la mémoire

    ; Supprimer l'élément de la liste
    mov rax, [rcx + 8]          ; rax = nœud suivant
    mov [rdx], rax              ; mettre à jour le début de la liste

    ; Avancer au nœud suivant
    jmp .loop

.not_to_remove:
    ; Mettre à jour le pointeur de la tête de la liste
    mov rdx, rcx                ; mettre rdx au nœud courant
    mov rcx, [rcx + 8]          ; passer au nœud suivant
    test rcx, rcx               ; vérifier si le prochain nœud est nul
    jnz .loop                   ; continuer la boucle si pas nul

.exit:
    ret
