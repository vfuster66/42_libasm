section .note.GNU-stack noexec nowrite
section .text
    global ft_strdup
    extern malloc
    extern ft_strlen
    extern ft_strcpy

ft_strdup:
    push    rbp             ; Setup stack frame
    mov     rbp, rsp
    push    rdi            ; Save source string pointer
    
    ; Get string length
    call    ft_strlen
    inc     rax            ; Add 1 for null terminator
    
    ; Call malloc
    mov     rdi, rax       ; Set size for malloc
    call    malloc WRT ..plt
    
    test    rax, rax       ; Check if malloc failed
    jz      error
    
    ; Copy string
    mov     rdi, rax       ; Set destination for strcpy
    pop     rsi            ; Restore source string as second parameter
    push    rax            ; Save malloc'd pointer
    
    call    ft_strcpy
    
    pop     rax            ; Restore return value (malloc'd pointer)
    
    mov     rsp, rbp
    pop     rbp
    ret

error:
    pop     rdi            ; Clean up stack
    mov     rax, 0         ; Return NULL
    mov     rsp, rbp
    pop     rbp
    ret