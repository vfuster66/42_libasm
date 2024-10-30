section .text
extern ft_strlen
global ft_atoi_base

ft_atoi_base:
    push    rdi                 ; sauvegarder rdi
    push    rsi                 ; sauvegarder rsi

    mov     rdi, rsi            ; rdi = base
    call    check_base          ; vérifier la validité de la base
    pop     rsi                 ; restaurer rsi
    pop     rdi                 ; restaurer rdi

    mov     r11, 0              ; nbr = 0
    mov     r12, 1              ; sign = 1
    cmp     rax, 0              ; si ret == 0
    je      end                 ; alors fin

    push    rdi                 ; sauvegarder rdi
    push    rsi                 ; sauvegarder rsi
    mov     rdi, rsi            ; rdi = str
    call    ft_strlen          ; appel à strlen
    pop     rsi                 ; restaurer rsi
    pop     rdi                 ; restaurer rdi

    cmp     rax, 2              ; si ret < 2
    jl      end                 ; alors fin

    mov     r10, rax            ; baselen = strlen(base)
    dec     rdi                 ; str--

skipspace:
    inc     rdi                 ; str++
    mov     dl, byte [rdi]      ; dl = str[0]
    
    ; Skip white space
    cmp     dl, 9               ; if str[0] == '\t'
    je      skipspace
    cmp     dl, 10              ; if str[0] == '\n'
    je      skipspace
    cmp     dl, 11              ; if str[0] == '\v'
    je      skipspace
    cmp     dl, 12              ; if str[0] == '\f'
    je      skipspace
    cmp     dl, 13              ; if str[0] == '\r'
    je      skipspace
    cmp     dl, 32              ; if str[0] == ' '
    je      skipspace
    dec     rdi                 ; str--

skipsign:
    inc     rdi                 ; str++
    mov     dl, byte [rdi]      ; dl = str[0]
    cmp     dl, 43              ; if str[0] == '+'
    je      skipsign
    cmp     dl, 45              ; if str[0] == '-'
    je      sign                ; alors change le signe et boucle

loop:
    mov     dl, byte [rdi]      ; dl = str[0]
    push    rdi                 ; sauvegarder rdi
    push    rsi                 ; sauvegarder rsi
    mov     dil, dl             ; 1st = str[0]
    call    in_str              ; in_str(str[0], base)
    pop     rsi                 ; restaurer rsi
    pop     rdi                 ; restaurer rdi

    cmp     rax, 0              ; if (ret < 0)
    jl      end                 ; alors fin

    imul    r11, r10            ; nbr *= baselen
    add     r11, rax            ; nbr += index
    inc     rdi                 ; str++
    jmp     loop                ; boucle

sign:
    imul    r12, -1             ; changer le signe
    jmp     skipsign            ; retourner à skipsign

end:
    imul    r11, r12            ; nbr * sign
    mov     rax, r11            ; retour (nbr)
    ret

in_str:
    mov     rax, -1             ; i = -1
index:
    inc     rax                  ; i++
    mov     dl, byte [rsi + rax] ; dl = base[i]
    cmp     dl, 0                ; if (base[i] == '\0')
    je      error                ; alors retourner (-1)
    cmp     dl, dil              ; if (base[i] == c)
    je      stop                 ; alors retourner (i)
    jmp     index                ; boucle
stop:
    ret
error:
    mov     rax, -1
    ret

check_base:
    mov     rax, 0               ; ret = 0
    mov     r11, 0                ; i = 0
    mov     r12, 0                ; j = 0
whilei:
    mov     sil, byte [rdi + r11] ; sil = base[i]
    cmp     sil, 0                ; if base[i] == '\0'
    je      donei                 ; alors fin while
    mov     r12, r11              ; j = i
    inc     r12                    ; i + 1
    cmp     sil, 43               ; if base[i] == '+'
    je      done                  ; alors retourner
    cmp     sil, 45               ; if base[i] == '-'
    je      done                  ; alors retourner
    cmp     sil, 33               ; if base[i] < 33
    jl      done                  ; alors retourner
    cmp     sil, 127              ; if base[i] > 127
    jg      done                  ; alors retourner
whilej:
    mov     dl, byte [rdi + r12]  ; dl = base[j]
    cmp     dl, 0                  ; if base[j] == '\0'
    je      donej                 ; alors fin while
    cmp     sil, dl                ; if base[i] == base[j]
    je      done                   ; alors retourner
    inc     r12                    ; j++
    jmp     whilej                ; while loop
donej:
    inc     r11                    ; i++
    jmp     whilei                ; while loop
donei:
    mov     rax, 1                ; valid, ret = 1
done:
    ret
