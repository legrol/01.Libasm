; **************************************************************************** ;
;                                                                              ;
;                                                         :::      ::::::::    ;
;    ft_list_sort.s                                     :+:      :+:    :+:    ;
;                                                     +:+ +:+         +:+      ;
;    By: rdel-olm <rdel-olm@student.42malaga.com    +#+  +:+       +#+         ;
;                                                 +#+#+#+#+#+   +#+            ;
;    Created: 2025/12/17 11:27:00 by rdel-olm          #+#    #+#              ;
;    Updated: 2025/12/17 11:27:00 by rdel-olm         ###   ########.fr        ;
;                                                                              ;
; **************************************************************************** ;

; ****************************************************************************
;                                                                             
;   void ft_list_sort(t_list **begin_list, int (*cmp)());                     
;                                                                             
;   Sorts the linked list in ascending order using a comparison function.     
;                                                                             
;   - Uses bubble sort algorithm.                                             
;   - Calls cmp(node1->data, node2->data) to compare elements.                
;   - Swaps nodes if comparison returns positive value (out of order).        
;   - Continues until no more swaps are needed (list is sorted).              
;   - Updates begin_list if the first node changes position.                  
;                                                                             
;   t_list structure:                                                         
;     struct s_list {                                                         
;         void *data;      (offset 0, 8 bytes)                                
;         struct s_list *next; (offset 8, 8 bytes)                            
;     } (total size: 16 bytes)                                                
;                                                                             
;   Comparison function:                                                      
;     int (*cmp)(void *a, void *b)                                            
;       Returns: < 0 if a < b (sorted)                                        
;       Returns: = 0 if a == b (sorted)                                       
;       Returns: > 0 if a > b (swap needed)                                   
;                                                                             
;   Algorithm (Bubble Sort):                                                  
;     swapped = 1                                                             
;     while (swapped):                                                        
;         swapped = 0                                                         
;         current = begin_list                                                
;         while (current && current->next):                                   
;             if (cmp(current->data, current->next->data) > 0):               
;                 swap nodes                                                  
;                 swapped = 1                                                 
;             else:                                                           
;                 current = current->next                                     
;                                                                             
;   Return value:                                                             
;     void (no return value)                                                  
;                                                                             
;   C equivalent:                                                             
;                                                                             
;   void ft_list_sort(t_list **begin_list, int (*cmp)())                      
;   {                                                                         
;       int swapped;                                                          
;       t_list *current;                                                      
;       t_list *temp;                                                         
;                                                                             
;       swapped = 1;                                                          
;       while (swapped)                                                       
;       {                                                                     
;           swapped = 0;                                                      
;           current = *begin_list;                                            
;           while (current && current->next)                                  
;           {                                                                 
;               if (cmp(current->data, current->next->data) > 0)              
;               {                                                             
;                   temp = current->next;                                     
;                   current->next = temp->next;                               
;                   temp->next = current;                                     
;                   if (current == *begin_list)                               
;                       *begin_list = temp;                                   
;                   else                                                      
;                       prev->next = temp;                                    
;                   swapped = 1;                                              
;               }                                                             
;               else                                                          
;                   current = current->next;                                  
;           }                                                                 
;       }                                                                     
;   }                                                                         
;                                                                             
; ****************************************************************************

;***********************************************************
; void ft_list_sort(t_list **begin_list, int (*cmp)());
;
;			type		size		name		register 
; argument	t_list**	8(ptr)		begin_list	rdi
; argument	int(**)()	8(ptr)		cmp			rsi
;***********************************************************

section .text
	global ft_list_sort								; make ft_list_sort visible to the linker

ft_list_sort:
	push rbx										; save rbx on stack
	push r12										; save r12 on stack
	push r13										; save r13 on stack
	push r14										; save r14 on stack
	push r15										; save r15 on stack

	mov r12, rdi									; r12 = begin_list (pointer to head)
	mov r13, rsi									; r13 = cmp (comparison function pointer)
	
	mov r14, 1										; r14 = swapped (set to 1 to enter loop)

	;************************************************
	; Outer loop: repeat until no swaps occur
	;************************************************

	.outer_loop:
		test r14, r14								; check if swapped flag is set
		jz .done									; if not swapped, list is sorted
		
		xor r14, r14								; reset swapped to 0
		
		mov r15, [r12]								; r15 = current (start from head)

		;*******************************************
		; Inner loop: compare adjacent elements
		;*******************************************

		.inner_loop:
			test r15, r15							; check if current is NULL
			jz .outer_loop							; if NULL, go to next outer iteration
			
			mov rax, [r15 + 8]						; rax = current->next
			test rax, rax							; check if current->next is NULL
			jz .outer_loop							; if NULL, go to next outer iteration

			;****************************************
			; Compare current->data with next->data
			;****************************************

			mov rdi, [r15 + 0]						; rdi = current->data (first arg to cmp)
			mov rsi, [rax + 0]						; rsi = next->data (second arg to cmp)
			call r13								; call cmp(current->data, next->data)
			
			cmp eax, 0								; check return value
			jle .no_swap							; if <= 0, no swap needed

			;****************************************************
			; Swap nodes: current with current->next
			;****************************************************

			mov rbx, r15							; rbx = current
			mov rcx, [r15 + 8]						; rcx = current->next (temp)
			
			mov rax, [rcx + 8]						; rax = temp->next
			mov [rbx + 8], rax						; current->next = temp->next
			
			mov [rcx + 8], rbx						; temp->next = current
			
			;****************************************************
			; Update begin_list if first node changed
			;****************************************************

			cmp r15, [r12]							; check if current was the head
			jne .not_head							; if not head, update previous node
			
			mov [r12], rcx							; update begin_list to new head (temp)
			jmp .after_swap

			.not_head:
				;**********************************************
                ; For simplicity, restart from head after swap
				; This is less efficient but simpler to implement
                ;**********************************************

				jmp .outer_loop

			.after_swap:
				mov r14, 1							; set swapped = 1 (swap occurred)
				jmp .outer_loop						; restart outer loop

			.no_swap:
				mov r15, [r15 + 8]					; current = current->next
				jmp .inner_loop						; continue inner loop

	.done:
		pop r15										; restore r15 from stack
		pop r14										; restore r14 from stack
		pop r13										; restore r13 from stack
		pop r12										; restore r12 from stack
		pop rbx										; restore rbx from stack
		ret											; return to caller
