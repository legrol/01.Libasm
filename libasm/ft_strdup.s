; **************************************************************************** #
;                                                                              #
;                                                         :::      ::::::::    #
;    ft_strdup.s                                        :+:      :+:    :+:    #
;                                                     +:+ +:+         +:+      #
;    By: rdel-olm <rdel-olm@student.42malaga.com    +#+  +:+       +#+         #
;                                                 +#+#+#+#+#+   +#+            #
;    Created: 2025/12/16 21:51:23 by rdel-olm          #+#    #+#              #
;    Updated: 2025/12/16 21:51:23 by rdel-olm         ###   ########.fr        #
;                                                                              #
; **************************************************************************** #

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
;       size_t len;                                                           
;       char *dst;                                                            
;                                                                             
;       len = ft_strlen(s) + 1;                                               
;       dst = (char *)malloc(len);                                            
;       if (!dst)                                                             
;           return NULL;                                                      
;       ft_strcpy(dst, s);                                                    
;       return dst;                                                           
;   }                                                                         
;                                                                             
; ****************************************************************************

;***************************************************************
;	char	*ft_strdup(const char *s);
;				type	size	name	register
;	argument	char *	8(ptr)	s   	rdi 
;	variable	size_t	8(long)	i		rax
;***************************************************************

section .text
	global ft_strdup		; make ft_strdup visible to the linker
	extern malloc			; External libc function malloc
	extern ft_strlen		; External function to compute string length
	extern ft_strcpy		; External function to copy strings

ft_strdup:
	push rdi				; save source string pointer on stack
	sub rsp, 8				; align stack to 16 bytes

	call ft_strlen			; compute length of source string (rax = len)	
	inc rax					; add 1 byte (len + 1) for null terminator
	mov rdi, rax			; first argument to malloc: size = len + 1
	call malloc				; allocate memory, return pointer in rax
	test rax, rax			; check if malloc returned NULL
	je .alloc_fail			; if allocation failed, jump to error handling

	mov rdi, rax			; set destination pointer (dst) for ft_strcpy
	pop rsi					; restore source pointer into rsi
	add rsp, 8				; restore stack alignment	
	call ft_strcpy			; copy source string to destination	
	ret						; return destination pointer (rax)

.alloc_fail:
	add rsp, 16				; clean stack (push rdi + sub rsp, 8) (8 bytes + 8 bytes)
	xor rax, rax			; return NULL (rax = 0)
	ret						; return to caller
