# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_list_push_front_bonus.s                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/17 11:26:42 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/21 22:17:00 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

; ****************************************************************************
;                                                                             
;   void ft_list_push_front(t_list **begin_list, void *data);                 
; 	
;	Uses wrapper: `utils/malloc_wrapper.S` (assembly wrapper for malloc)
;   Adds a new element of type t_list to the beginning of the list.           
;                                                                             
;   - Allocates memory for a new t_list node.                                 
;   - Sets the data field of the new node to the given data pointer.          
;   - Links the new node to the rest of the list.                             
;   - Updates the begin_list pointer to point to the new node.  
;              
;	extern malloc_wrapper				; wrapper implemented in utils/malloc_wrapper.S
;                                                                             
;   t_list structure:                                                         
;     struct s_list {                                                         
;         void *data;      (offset 0, 8 bytes)                                
;         struct s_list *next; (offset 8, 8 bytes)                            
;     } (total size: 16 bytes)                                                
;                                                                             
;   Algorithm:                                                                
;     1. Allocate 16 bytes for new node via malloc                            
;     2. If malloc fails, return (no action)                                  
;     3. Set new_node->data = data                                            
;     4. Set new_node->next = *begin_list (link to current head)              
;     5. Update *begin_list = new_node (new node becomes head)                
;                                                                             
;   Return value:                                                              
;     void (no return value)                                                  
;                                                                             
;   C equivalent:                                                              
;                                                                             
;   void ft_list_push_front(t_list **begin_list, void *data)                  
;   {                                                                         
;       t_list *new_node;                                                      
;                                                                             
;       new_node = (t_list *)malloc(sizeof(t_list));                          
;       if (!new_node)                                                        
;           return;                                                            
;       new_node->data = data;                                                
;       new_node->next = *begin_list;                                         
;       *begin_list = new_node;                                                
;   }                                                                         
;                                                                             
; ****************************************************************************

;*****************************************************************************
; void ft_list_push_front(t_list **begin_list, void *data);
;
; 			type		size		name		register 
; argument	t_list**	8(ptr)		begin_list	rdi    ; pointer to head pointer
; argument	void*		8(ptr)		data		rsi    ; data pointer to store in new node
;
; variable	t_list*		8(ptr)		new_node	rax    ; temporary result from malloc (also used for loads/stores)
; variable	t_list*		8(ptr)		temp		rcx    ; temporary new_node pointer while initializing
; variable	void*		8(ptr)		data_reg	rbx    ; saved data pointer (callee-saved - stored/restored)
; variable	t_list**	8(ptr)		head_ptr	r12    ; saved begin_list pointer (callee-saved - stored/restored)
; temp		temporaries	-			rdx, rcx	used briefly if needed (rcx used above)
; return	void		-			-			(no return value)
;*****************************************************************************

;**************************************************************************
; Uses wrapper: `utils/malloc_wrapper.S` (assembly wrapper for malloc)
;**************************************************************************

section .text
 	global ft_list_push_front			; make ft_list_push_front visible to the linker

	;**********************************************************************
	; This assembler implementation calls `malloc_wrapper` (assembly) which
	; forwards to libc `malloc` via the PLT. The wrapper lives in `utils/` as
	; `malloc_wrapper.S` and is assembled with gcc to produce a PLT-friendly
	; symbol on PIE builds.
	;**********************************************************************
	extern malloc_wrapper				; wrapper implemented in utils/malloc_wrapper.S

ft_list_push_front:
 	push rbx							; save rbx on stack
 	push r12							; save r12 on stack

 	mov r12, rdi						; r12 = begin_list pointer (t_list**)
 	mov rbx, rsi						; rbx = data pointer

 	;************************************************
 	; Allocate memory for new node (16 bytes)
 	;************************************************

	mov rdi, 16							; 16 bytes = sizeof(t_list)
	call malloc_wrapper					; allocate memory via wrapper, rax = new_node pointer
	test rax, rax						; check if malloc returned NULL
	jz .alloc_fail						; if allocation failed, return

 	mov rcx, rax						; rcx = new_node pointer

 	;************************************************
 	; Set new_node->data = data
 	;************************************************

 	mov [rcx + 0], rbx					; new_node->data = data (offset 0)

 	;************************************************
 	; Set new_node->next = *begin_list
 	;************************************************

 	mov rax, [r12]						; rax = *begin_list (current head)
 	mov [rcx + 8], rax					; new_node->next = current_head (offset 8)

 	;************************************************
 	; Update *begin_list = new_node
 	;************************************************

 	mov [r12], rcx						; *begin_list = new_node

 	;************************************************
 	; Return
 	;************************************************

 	pop r12								; restore r12 from stack
 	pop rbx								; restore rbx from stack
 	ret									; return to caller

 	;************************************************
 	; Allocation failed - just return
 	;************************************************

 	.alloc_fail:
 		pop r12							; restore r12 from stack
 		pop rbx							; restore rbx from stack
 		ret								; return to caller without doing anything

; ****************************************************************************
; Stack execution protection
; ****************************************************************************
; This section is required by the linker (ld) to mark the stack as
; non-executable. It prevents security warnings about missing
; .note.GNU-stack sections. This is a compilation/linking requirement,
; not part of the project's algorithmic logic.
; ****************************************************************************
section .note.GNU-stack noalloc noexec nowrite progbits
