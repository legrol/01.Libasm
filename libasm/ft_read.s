# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_read.s                                          :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/16 21:51:23 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/19 18:09:28 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

; ****************************************************************************
;                                                                             
;   ssize_t ft_read(int fd, void *buf, size_t count);                         
;                                                                             
;   Reads up to count bytes from the file descriptor fd                       
;   into the buffer pointed to by buf.                                        
;                                                                             
;   - Invokes the read system call (SYS_read).                                
;   - On success, returns the number of bytes read.                           
;   - On error, sets errno and returns -1.                                    
;                                                                             
;   Notes:                                                                    
;   - A return value of 0 indicates end-of-file (EOF).                        
;   - The kernel returns -errno on failure.                                   
;   - errno must be set manually in user space.                               
;                                                                             
;   Return value:                                                             
;     > 0  -> number of bytes read                                            
;     = 0  -> end of file                                                     
;     -1   -> error occurred and errno is set                                 
;                                                                             
;   C equivalent:                                                             
;                                                                             
;   ssize_t ft_read(int fd, void *buf, size_t count)                          
;   {                                                                         
;       ssize_t ret;                                                          
;                                                                             
;       ret = read(fd, buf, count);                                           
;       if (ret < 0)                                                          
;           return -1;                                                        
;       return ret;                                                           
;   }                                                                         
;                                                                             
; ****************************************************************************

;*****************************************************************************
;    ssize_t ft_read(int fd, void *buf, size_t count);
;
;             	type    size    name        register
;  argument     int     4(int)  fd          rdi    		; file descriptor (passed in rdi)
;  argument     void*   8(ptr)  buf         rsi    		; buffer pointer (passed in rsi)
;  argument     size_t  8(long) count       rdx    		; number of bytes to read (passed in rdx)
;  syscall      read    number  -         	rax    		; syscall number placed in rax before `syscall`
;  temp         ssize_t 8(long) ret         rax    		; syscall result returned in rax (>=0 bytes read, <0 error as -errno)
;  usage        int     4(int)  errno_in    edi    		; when error: convert -rax to errno and pass in edi to helper
;
;  helpers     	set_errno_and_return_minus_one  extern  ; called to set errno and return -1 (assembled in utils/)
;  clobbers     caller-saved regs: rax, rcx, rdx, rsi, rdi
;
;  returns      ssize_t      8(long)         rax    	; on success: bytes read; on error: -1 (helper sets errno)
;*****************************************************************************

;**************************************************************************
; Uses helper: `utils/errno_helper.S` (assembly helper to set errno)
;**************************************************************************

section .text
	global ft_read							; make ft_read visible to the linker

	;************************************************************************
	; For PIE builds we provide a tiny assembly helper that sets errno and
	; returns -1. The helper is implemented in `utils/errno_helper.S` and is
	; assembled and linked only into the `test` binary (not into `libasm.a`).
	;************************************************************************
	extern set_errno_and_return_minus_one	; Helper ASM: sets errno and returns -1

ft_read:
	mov rax, 0								; syscall number for read (SYS_read)
	syscall									; Enter kernel mode and execute read

	cmp rax, 0								; check syscall return value
	jl .error								; jump if rax < 0 (syscall error, rax = -errno)
	ret										; return number of bytes read (rax >= 0)

.error:
	neg rax									; convert -errno to positive errno value
	mov edi, eax							; move errno into edi (32-bit)
	call set_errno_and_return_minus_one		; set errno and return -1

	;**********************
	; returns -1 in eax
	;**********************
	ret										; return to caller

; ****************************************************************************
; Stack execution protection
; ****************************************************************************
; This section is required by the linker (ld) to mark the stack as
; non-executable. It prevents security warnings about missing
; .note.GNU-stack sections. This is a compilation/linking requirement,
; not part of the project's algorithmic logic.
; ****************************************************************************
section .note.GNU-stack noalloc noexec nowrite progbits
