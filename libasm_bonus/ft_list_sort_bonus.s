# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_list_sort_bonus.s                               :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/17 11:27:00 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/23 20:57:51 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

; ****************************************************************************
;
;   void ft_list_sort(t_list **begin_list, int (*cmp)());
;
;   Sorts the linked list in ascending order using a comparison function.
;
;   Implementation details:
;   - Uses a bubble sort algorithm.
;   - Iterates repeatedly over the list until no swaps occur.
;   - Compares adjacent elements using the comparison function `cmp`.
;   - If cmp(current->data, next->data) > 0, the elements are out of order.
;   - Instead of rearranging nodes, this implementation swaps the `data`
;     pointers stored inside the nodes.
;
;   Important notes:
;   - Nodes themselves are never moved or relinked.
;   - Only the `data` fields (offset 0 of each node) are exchanged.
;   - The structure of the list (`next` pointers) remains unchanged.
;   - As a consequence, `begin_list` never needs to be updated.
;
;   t_list structure:
;     struct s_list {
;         void *data;              ; offset 0 (8 bytes)
;         struct s_list *next;     ; offset 8 (8 bytes)
;     };
;
;   Comparison function:
;     int (*cmp)(void *a, void *b)
;       Returns:
;         < 0  if a < b   (already in correct order)
;         = 0  if a == b  (already in correct order)
;         > 0  if a > b   (swap required)
;
;   Algorithm (Bubble Sort, data swap version):
;
;     do {
;         swapped = 0;
;         current = head;
;
;         while (current != NULL && current->next != NULL) {
;             if (cmp(current->data, current->next->data) > 0) {
;                 swap(current->data, current->next->data);
;                 swapped = 1;
;             }
;             current = current->next;
;         }
;     } while (swapped);
;
;   Return value:
;     void
;
;
; 	C equivalent:
;
;   void ft_list_sort(t_list **begin_list, int (*cmp)(void *, void *))
;   {
;       int     swapped;
;       t_list  *current;
;   
;       if (!begin_list || !*begin_list)
;           return;
;   
;       do {
;           swapped = 0;
;           current = *begin_list;
;   
;           while (current && current->next)
;           {
;               if (cmp(current->data, current->next->data) > 0)
;               {
;                   void *tmp = current->data;
;                   current->data = current->next->data;
;                   current->next->data = tmp;
;   
;                   swapped = 1;
;               }
;               current = current->next;
;           }
;       } while (swapped);
;   }
;
; ****************************************************************************

; ****************************************************************************

; NOTE (clarification):
; - This implementation uses the comparison function pointer `cmp` passed
;   as the second argument. It calls the function as
;     (*cmp)(a, b)
;   by loading `a` into `rdi`, `b` into `rsi` and then executing `call r13`.
; - Important: this implementation swaps the `data` fields of the nodes
;   (i.e. the 8-byte pointers stored at offset 0 of each node) rather than
;   rearranging the `next` links (swapping whole nodes). Both approaches
;   produce a correctly ordered sequence of element values; here we chose
;   to swap `data` because it is simpler and avoids handling `prev` and
;   head-pointer adjustments.
; ****************************************************************************

; ****************************************************************************
; void ft_list_sort(t_list **begin_list, int (*cmp)());
;
; 			type		size		name		register
; argument	t_list**	8(ptr)		begin_list	rdi    ; pointer to head pointer
; argument	int(*)()	8(ptr)		cmp			rsi    ; comparison function pointer
;
; variable	t_list*		8(ptr)		head		r12    ; head = *begin_list (saved)
; variable	int(*)()	8(ptr)		cmp_fn		r13    ; comparison function pointer (saved from rsi)
; variable	_list*		8(ptr)		current		r15    ; current node pointer (iterates)
; variable	t_list*		8(ptr)		next		rbx    ; next node pointer (temporary, callee-saved)
; variable	int			4(int)		swapped		r14d   ; swap flag (0/1)
; temp		int			4(int)		cmp_res		eax    ; result returned by cmp
; temp		regs		-			rcx, rdx	temporaries used when swapping data
; saved		regs		-			rbx, r12, r13, r14, r15	callee-saved registers preserved by the function
; return	void		-			-			(no return value)
; ****************************************************************************

section .text
 	global ft_list_sort						; make ft_list_sort visible to the linker

ft_list_sort:
 	push rbx								; save rbx
 	push r12								; save r12
 	push r13								; save r13
 	push r14								; save r14
 	push r15								; save r15

 	mov r12, [rdi]							; r12 = *begin_list (head)
 	mov r13, rsi							; r13 = cmp function

 	test r12, r12							; check if head is NULL
 	jz .done								; if empty list, return

 	;******************************************************
 	; Outer loop: repeat until no swaps occur (bubble sort)
 	;******************************************************

 	.outer_loop:
 		xor r14, r14						; swapped = 0
 		mov r15, r12						; current = head

 		;*******************************************
 		; Inner loop: iterate through list
 		;*******************************************

 		.inner_loop:
 			test r15, r15					; check if current is NULL
 			jz .check_swapped				; if end of list, check if swapped

 			mov rbx, [r15 + 8]				; rbx = current->next
 			test rbx, rbx					; check if next is NULL
 			jz .check_swapped				; if next is NULL, end of inner loop

 			;******************************************************
 			; Compare current->data with next->data. Equivalent to 
			; (*cmp)(list_ptr->data, list_other_ptr->data)
 			;******************************************************

 			mov rdi, [r15]					; rdi = current->data
 			mov rsi, [rbx]					; rsi = next->data
			
 			call r13						; call cmp(data1, data2)
			
 			cmp eax, 0						; check result
 			jle .next_node					; if <= 0, correct order

 			;****************************************
 			; Swap data
 			;****************************************

 			mov rcx, [r15]					; rcx = current->data
 			mov rdx, [rbx]					; rdx = next->data
 			mov [r15], rdx					; current->data = next->data
 			mov [rbx], rcx					; next->data = current->data

 			mov r14, 1						; swapped = 1

 		.next_node:
 			mov r15, rbx					; current = next
 			jmp .inner_loop					; continue inner loop

 	.check_swapped:
 		test r14, r14						; check if swapped
 		jnz .outer_loop						; if swapped, repeat outer loop

 	.done:
 		pop r15								; restore r15
 		pop r14								; restore r14
 		pop r13								; restore r13
 		pop r12								; restore r12
 		pop rbx								; restore rbx
 		ret									; return to caller

; ****************************************************************************
; Stack execution protection
; ****************************************************************************
; This section is required by the linker (ld) to mark the stack as
; non-executable. It prevents security warnings about missing
; .note.GNU-stack sections. This is a compilation/linking requirement,
; not part of the project's algorithmic logic.
; ****************************************************************************
section .note.GNU-stack noalloc noexec nowrite progbits
