# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_strdup.s                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/16 21:51:23 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/19 16:08:52 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

; ****************************************************************************
;                                                                             
;   char *ft_strdup(const char *s);                                           
;                                                                             
;   Allocates memory and returns a new string which is a duplicate            
;   of the string pointed to by s.                                            
;                                                                             
;   - Computes the length of s using ft_strlen.                               
;   - Allocates (length + 1) bytes using malloc.                              
;   - Copies the string including the null terminator using ft_strcpy.        
;   - Returns NULL if memory allocation fails.                                
;                                                                             
;   Return value:                                                              
;     != NULL  -> pointer to newly allocated duplicated string                
;     NULL     -> allocation failed                                           
;                                                                             
;   C equivalent:                                                             
;                                                                             
;   char *ft_strdup(const char *s)                                            
;   {                                                                         
;       size_t i;                                                           
;       char *dst;                                                            
;                                                                             
;       i = ft_strlen(s) + 1;                                               
;       dst = (char *)malloc(i);                                            
;       if (!dst)                                                             
;           return NULL;                                                      
;       ft_strcpy(dst, s);                                                    
;       return dst;                                                           
;   }                                                                         
;                                                                             
; ****************************************************************************

;*****************************************************************************
;    char * ft_strdup(const char *s);
;
;                type    size    name    register
;  argument     char *   8(ptr)  s       rdi    ; source string pointer
;  variable     size_t   8(long) len     rax    ; length computed by ft_strlen (len)
;  saved        ptr      8(ptr)  src_save rbx   ; original src pointer saved in rbx
;  uses         void*    8(ptr)  dst     rax    ; destination pointer returned in rax
;*****************************************************************************

;**************************************************************************
; Uses wrapper: `utils/malloc_wrapper.S` (assembly wrapper for malloc)
;**************************************************************************

section .text
	global ft_strdup			; make ft_strdup visible to the linker
	
	;**********************************************************************
	; This implementation relies on a tiny assembly `malloc_wrapper`
	; (implemented in `utils/malloc_wrapper.S`) which forwards to libc's
	; `malloc`. The wrapper is assembled and linked only into the `test`
	; binary, so `libasm.a` remains mandatory-only and purely assembly.
	;**********************************************************************
	extern malloc_wrapper		; assembly wrapper: calls malloc@PLT
	extern ft_strlen			; External function to compute string length
	extern ft_strcpy			; External function to copy strings

ft_strdup:
	push rbx					; save rbx (callee-saved) and align stack
	mov rbx, rdi				; save source string pointer in rbx

	call ft_strlen				; compute length of source string (rax = len)
	inc rax						; add 1 byte (len + 1) for null terminator
	mov rdi, rax				; first argument to malloc: size = len + 1

	;**********************************************************************
	; call the assembly wrapper which forwards to libc malloc
	;**********************************************************************
	call malloc_wrapper			; allocate memory via wrapper, return pointer in rax
	test rax, rax				; check if malloc returned NULL
	je .alloc_fail				; if allocation failed, jump to error handling

	mov rdi, rax				; set destination pointer (dst) for ft_strcpy
	mov rsi, rbx				; restore source pointer from rbx
	call ft_strcpy				; copy source string to destination
	
	pop rbx						; restore rbx
	ret							; return destination pointer (rax)

	.alloc_fail:
		pop rbx					; restore rbx
		xor rax, rax			; return NULL (rax = 0)
		ret						; return to caller

; ****************************************************************************
; Stack execution protection
; ****************************************************************************
; This section is required by the linker (ld) to mark the stack as
; non-executable. It prevents security warnings about missing
; .note.GNU-stack sections. This is a compilation/linking requirement,
; not part of the project's algorithmic logic.
; ****************************************************************************
section .note.GNU-stack noalloc noexec nowrite progbits
