# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_write.s                                         :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/13 16:03:28 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/19 14:43:59 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

; ****************************************************************************
;                                                                             
; ssize_t ft_write(int fd, const void *buf, size_t count);                    
;                                                                             
;   Writes up to count bytes from the buffer pointed to by buf                
;   to the file descriptor fd.                                                
;                                                                             
;   - Invokes the write system call (sys_write).                              
;   - On success, returns the number of bytes written.                        
;   - On error, sets errno and returns -1.                                    
;                                                                             
;   Error handling:                                                           
;   - If syscall returns a negative value, it represents -errno.              
;   - The error code is negated and stored in errno via                       
;     __errno_location().                                                     
;                                                                             
;   Return value:                                                             
;     >= 0  -> number of bytes written                                        
;     -1    -> error occurred and errno is set                                
;                                                                             
;   C equivalent:                                                              
;                                                                             
;   ssize_t ft_write(int fd, const void *buf, size_t count)                  
;   {                                                                         
;       ssize_t ret;                                                          
;                                                                             
;       ret = write(fd, buf, count);                                          
;       if (ret < 0)                                                          
;           return -1;                                                        
;       return ret;                                                           
;   }                                                                         
;                                                                             
; ****************************************************************************

;***************************************************************
;    ssize_t ft_write(int fd, const void *buf, size_t count);
;
;                type    size    name    register
;  argument     int     4(int)  fd      rdi    ; file descriptor (in rdi)
;  argument     void*   8(ptr)  buf     rsi    ; buffer pointer (in rsi)
;  argument     size_t  8(long) count   rdx    ; number of bytes (in rdx)
;  syscall      write   number  1       rax    ; syscall number in rax
;  return       ssize_t 8(long) ret     rax    ; bytes written or -1 on error
;***************************************************************

;**************************************************************************
; Uses helper: `utils/errno_helper.S` (assembly helper to set errno)
;**************************************************************************

section .text
	global ft_write							; make ft_write visible to the linker
	
	;************************************************************************
	; For PIE builds we provide a tiny assembly helper that sets errno and
	; returns -1. The helper is implemented in `utils/errno_helper.S` and is
	; assembled and linked only into the `test` binary (not into `libasm.a`).
	;************************************************************************
	extern set_errno_and_return_minus_one	; Helper ASM: sets errno and returns -1

ft_write:
	mov rax, 1								; syscall number for write (SYS_write)
	syscall									; Enter kernel mode and execute write
	
	cmp rax, 0								; check syscall return value
	jl .error								; jump if rax < 0 (syscall error, rax = -errno)
	ret										; return number of bytes written (rax >= 0)

.error:
	neg rax									; convert -errno to positive errno value
	mov edi, eax           					; move errno value into edi (32-bit)
	sub rsp, 8					; align stack to 16 before calling C-compiled helper
	call set_errno_and_return_minus_one			; set errno and return -1
	add rsp, 8					; restore stack pointer

	;**********************
	; returns -1 in eax
	;**********************
	ret                  					; return to caller

; ****************************************************************************
; Stack execution protection
; ****************************************************************************
; This section is required by the linker (ld) to mark the stack as
; non-executable. It prevents security warnings about missing
; .note.GNU-stack sections. This is a compilation/linking requirement,
; not part of the project's algorithmic logic.
; ****************************************************************************
section .note.GNU-stack noalloc noexec nowrite progbits
