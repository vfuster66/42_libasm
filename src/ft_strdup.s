section .note.GNU-stack
section .text
    global  ft_strdup
    extern  malloc
    extern  ft_strlen
    extern  ft_strcpy
    extern  __errno_location    ; for errno handling

ft_strdup:
    push    rbx                 ; preserve rbx as per calling convention
    push    rdi                 ; save source string pointer
    
    call    ft_strlen          ; get length of source string
    inc     rax                ; add 1 for null terminator
    
    mov     rdi, rax           ; set malloc argument
    mov     rbx, rax           ; save size in rbx
    
    call    malloc            ; allocate memory
    test    rax, rax          ; check if malloc failed
    jz      .error            ; handle malloc failure
    
    mov     rdi, rax          ; set destination for strcpy
    pop     rsi               ; restore source string pointer
    push    rax               ; save malloc'd pointer
    
    call    ft_strcpy        ; copy string
    
    pop     rax              ; restore return value (malloc'd pointer)
    pop     rbx              ; restore rbx
    ret

.error:
    pop     rdi              ; clean up stack
    pop     rbx              ; restore rbx
    push    rax              ; save error code
    call    __errno_location ; get errno location
    mov     dword [rax], 12  ; set errno to ENOMEM
    pop     rax              ; restore error code
    xor     rax, rax         ; return NULL
    ret