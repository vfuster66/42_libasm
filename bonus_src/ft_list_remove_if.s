section .note.GNU-stack noexec nowrite
section .text
   global ft_list_remove_if
   extern free
   default rel

ft_list_remove_if:
   test    rdi, rdi               ; Check begin_list
   jz      .return
   test    rdx, rdx               ; Check cmp function
   jz      .return
   
   push    rbp
   mov     rbp, rsp
   push    rbx                    
   push    r12
   push    r13
   push    r14
   push    r15

   mov     r12, rdi               ; r12 = begin_list
   mov     r13, rsi               ; r13 = data_ref
   mov     r14, rdx               ; r14 = cmp
   mov     r15, rcx               ; r15 = free_fct

.check_current:
   mov     rbx, [r12]             ; rbx = current node
   test    rbx, rbx               
   jz      .exit                  

   push    rdi                    
   push    rsi
   mov     rdi, [rbx]             ; First arg: current->data
   mov     rsi, r13               ; Second arg: data_ref
   call    r14                    ; Call cmp
   pop     rsi
   pop     rdi

   test    eax, eax               
   jnz     .next_node             

   ; Remove matching node
   mov     rdi, [rbx]             ; Get node data
   test    r15, r15               ; Check free_fct
   jz      .skip_free_data        
   
   push    rbx
   push    rax
   call    r15                    ; Call free_fct(data)
   pop     rax
   pop     rbx

.skip_free_data:
   mov     rdi, rbx               ; Free node
   mov     rax, [rbx + 8]         ; Get next node
   mov     [r12], rax             ; Update previous->next
   push    rax
   call    free wrt ..plt         
   pop     rax
   jmp     .check_current         

.next_node:
   lea     r12, [rbx + 8]         ; Move to next node
   jmp     .check_current         

.exit:
   pop     r15
   pop     r14
   pop     r13
   pop     r12
   pop     rbx
   leave
   
.return:
   ret