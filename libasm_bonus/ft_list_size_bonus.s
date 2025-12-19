# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_list_size_bonus.s                               :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/17 11:26:57 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/19 18:03:35 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

; ****************************************************************************
;                                                                             
;   int ft_list_size(t_list *begin_list);                                     
;                                                                             
;   Returns the number of elements in the linked list.                        
;                                                                             
;   - Iterates through the list from the beginning.                           
;   - Counts each node encountered.                                            
;   - Stops when reaching a NULL pointer (end of list).                       
;   - Returns the total count.                                                 
;                                                                             
;   t_list structure:                                                         
;     struct s_list {                                                         
;         void *data;      (offset 0, 8 bytes)                                
;         struct s_list *next; (offset 8, 8 bytes)                            
;     } (total size: 16 bytes)                                                
;                                                                             
;   Algorithm:                                                                
;     count = 0                                                                
;     while (current_node != NULL):                                            
;         count++                                                              
;         current_node = current_node->next                                    
;     return count                                                             
;                                                                             
;   Return value:                                                              
;     The number of elements (nodes) in the list.                              
;     Returns 0 if begin_list is NULL (empty list).                           
;                                                                             
;   C equivalent:                                                              
;                                                                             
;   int ft_list_size(t_list *begin_list)                                      
;   {                                                                         
;       int count = 0;                                                        
;                                                                             
;       while (begin_list)                                                    
;       {                                                                     
;           count++;                                                           
;           begin_list = begin_list->next;                                    
;       }                                                                     
;       return count;                                                         
;   }                                                                         
;                                                                             
; ****************************************************************************

; ****************************************************************************
; int ft_list_size(t_list *begin_list);
;
; 			type		size		name		register 
; argument	t_list*		8(ptr)		begin_list	rdi    ; pointer to first node
;
; variable	int			4(int)		count		eax    ; counter (return value)
; variable	t_list*		8(ptr)		current		rdi    ; current node pointer (updated during loop)
; temp		none		-			-			(no additional temporaries required)
; return	int			4(int)		(return)	eax    ; final count in eax
; ****************************************************************************

section .text
 	global ft_list_size					; make ft_list_size visible to the linker

ft_list_size:
 	xor eax, eax						; count = 0 (initialize counter)

 	;****************************************
 	; Loop through list and count elements
 	;****************************************

 	.count_loop:
 		test rdi, rdi					; check if current node is NULL
 		jz .done						; if NULL, list traversal complete

 		inc eax							; increment count

 		;***********************************
 		; Move to next node
 		;***********************************

 		mov rdi, [rdi + 8]				; current = current->next (offset 8)
 		jmp .count_loop					; continue looping

 	.done:
 		ret								; return count in eax

; ****************************************************************************
; Stack execution protection
; ****************************************************************************
; This section is required by the linker (ld) to mark the stack as
; non-executable. It prevents security warnings about missing
; .note.GNU-stack sections. This is a compilation/linking requirement,
; not part of the project's algorithmic logic.
; ****************************************************************************
section .note.GNU-stack noalloc noexec nowrite progbits
