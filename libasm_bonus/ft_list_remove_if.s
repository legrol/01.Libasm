# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_list_remove_if.s                                :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/17 13:35:00 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/18 21:31:14 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

; ****************************************************************************
;                                                                             
;   void ft_list_remove_if(t_list **begin_list, void *data_ref,              
;                          int (*cmp)(), void (*free_fct)(void *));           
;                                                                             
;   Removes all elements from the list whose data comparison with data_ref     
;   results in cmp returning 0 (match found).                                 
;                                                                             
;   - Traverses the entire linked list.                                       
;   - For each node, calls cmp(node->data, data_ref).                         
;   - If cmp returns 0, the node is removed:                                  
;     * Call free_fct(node->data) to free the data.                           
;     * Unlink the node from the list.                                        
;     * Call free(node) to deallocate the node structure itself.              
;   - Updates begin_list if the first node(s) is/are removed.                 
;   - Continues traversal until the end of the list (NULL).                   
;                                                                             
;   t_list structure:                                                         
;     struct s_list {                                                         
;         void *data;      (offset 0, 8 bytes)                                
;         struct s_list *next; (offset 8, 8 bytes)                            
;     } (total size: 16 bytes)                                                
;                                                                             
;   Comparison function:                                                      
;     int (*cmp)(void *a, void *b)                                            
;       Returns: 0 if match found (element should be removed)                 
;       Returns: non-zero if no match (element should remain)                 
;                                                                             
;   Free function:                                                            
;     void (*free_fct)(void *ptr)                                             
;       Called to free the data pointer before unlinking the node.            
;                                                                             
;   Algorithm (Linear Traversal with Conditional Removal):                    
;     while (current node exists):                                            
;         if (cmp(current->data, data_ref) == 0):                             
;             free_fct(current->data)                                         
;             if (current is first node):                                     
;                 update *begin_list to next node                             
;                 free(current)                                               
;             else:                                                           
;                 previous->next = current->next                              
;                 free(current)                                               
;             current = new next node                                         
;         else:                                                               
;             move to next node                                              
;                                                                             
;   Return value:                                                             
;     void (no return value)                                                  
;                                                                             
;   Registers used:                                                           
;     rdi (input): **begin_list - pointer to list head pointer                
;     rsi (input): *data_ref - reference data to compare                      
;     rdx (input): cmp function pointer                                       
;     rcx (input): free_fct function pointer                                  
;     r12: current node pointer                                               
;     r13: previous node pointer                                              
;     r14: temporary next pointer for traversal                               
;     rax: return value from cmp function                                     
;                                                                             
; ****************************************************************************

section .text
global ft_list_remove_if		; make ft_list_sort visible to the linker
extern malloc					; external libc malloc function
extern free					; external libc free function
; This file uses minimal C wrappers for allocation/deallocation to avoid
; PC32 relocations when building PIEs. See `src/malloc_wrapper.c` for the
; implementations of `malloc_wrapper` and `free_wrapper`.
extern free_wrapper				; wrapper in src/malloc_wrapper.c

ft_list_remove_if:
	;********************************
	; Save callee-saved registers
	;********************************
	push rbx						; Save rbx on stack (callee-saved)
	push r12						; Save r12: current node pointer
	push r13						; Save r13: previous node pointer
	push r14						; Save r14: temporary/next pointer
	push r15						; Save r15: free_fct pointer (easier access)

	;**********************************************
	; Parameter setup
	; rdi = **begin_list (pointer to head pointer)
	; rsi = *data_ref
	; rdx = cmp function pointer
	; rcx = free_fct function pointer
	;**********************************************

	sub rsp, 40						; Allocate stack space to save parameters safely
	mov [rsp + 0], rdi				; Save **begin_list
	mov [rsp + 8], rsi				; Save *data_ref
	mov [rsp + 16], rdx				; Save cmp function pointer
	mov [rsp + 24], rcx				; Save free_fct function pointer
	mov r15, rcx					; Save free_fct in r15 for later use
	mov r12, [rdi]					; Load first node into r12 (current = *begin_list)
	xor r13, r13					; Initialize r13 to 0 (previous = NULL, we're at head)

.loop_start:
	test r12, r12					; Check if current node is NULL
	jz .loop_end					; If NULL, exit loop

	;*******************************************************
	; Call cmp function to compare node->data with data_ref
	;*******************************************************

	mov rdi, [r12 + 0]				; Load current->data into rdi (first parameter for cmp)
	mov rsi, [rsp + 8]				; Load data_ref into rsi (second parameter)
	mov rax, [rsp + 16]				; Load cmp function pointer
	call rax						; Call (*cmp)(current->data, data_ref)

	;***************************************
	; Check if cmp returned 0 (match found)
	;***************************************

	test eax, eax					; Test if comparison result is 0
	jnz .no_match					; If not 0, skip removal and move to next

	;*******************************************
	; MATCH FOUND: Remove this node
	; Call free_fct(current->data) to free data
	;*******************************************

	mov rdi, [r12 + 0]				; Load current->data
	mov rax, r15					; Load free_fct function pointer
	call rax						; Call (*free_fct)(current->data)

	;***************************************
	; Handle node unlinking and freeing
	;***************************************

	mov r14, [r12 + 8]				; Load current->next into r14 (next node)

	test r13, r13					; Check if previous is NULL (current is first node)
	jnz .not_first_node				; If not NULL, it's not the first node

	;***********************************************
	; Current is the first node: update *begin_list
	;***********************************************

	mov rdi, [rsp + 0]				; Load **begin_list
	mov [rdi], r14					; Update *begin_list to point to next node
	jmp .free_current_node			; Jump to free the current node

.not_first_node:
	;******************************************************
	; Current is not the first node: update previous->next
	;******************************************************

	mov [r13 + 8], r14				; Set previous->next = current->next (unlink current)

.free_current_node:
	;***************************************
	; Free the node structure itself
	;***************************************

	mov rdi, r12					; Load current node pointer into rdi (free parameter)
	; call free via wrapper for PIE-friendliness
	call free_wrapper			; Call free(current) via wrapper

	;*********************************************
	; Move to next node without updating previous
	;*********************************************

	mov r12, r14					; Set current = next node
	jmp .loop_start					; Continue loop (previous stays same)

.no_match:
	;***************************************
	; No match: move to next node normally
	;***************************************

	mov r13, r12					; Save current as previous
	mov r12, [r12 + 8]				; Move to next node (current = current->next)
	jmp .loop_start					; Continue loop

.loop_end:
	;***************************************
	; Clean up allocated stack space
	;***************************************

	add rsp, 40						; Deallocate stack space

	;***************************************
	; Restore callee-saved registers
	;***************************************
	 
	pop r15							; Restore r15
	pop r14							; Restore r14
	pop r13							; Restore r13
	pop r12							; Restore r12
	pop rbx							; Restore rbx

	ret								; Return (void function)

; ****************************************************************************
; Stack execution protection
; ****************************************************************************
; This section is required by the linker (ld) to mark the stack as
; non-executable. It prevents security warnings about missing
; .note.GNU-stack sections. This is a compilation/linking requirement,
; not part of the project's algorithmic logic.
; ****************************************************************************
section .note.GNU-stack noalloc noexec nowrite progbits 
