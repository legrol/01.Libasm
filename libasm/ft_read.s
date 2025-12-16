; **************************************************************************** #
;                                                                              #
;                                                         :::      ::::::::    #
;    ft_read.s                                          :+:      :+:    :+:    #
;                                                     +:+ +:+         +:+      #
;    By: rdel-olm <rdel-olm@student.42malaga.com    +#+  +:+       +#+         #
;                                                 +#+#+#+#+#+   +#+            #
;    Created: 2025/12/16 21:51:23 by rdel-olm          #+#    #+#              #
;    Updated: 2025/12/16 21:51:23 by rdel-olm         ###   ########.fr        #
;                                                                              #
; **************************************************************************** #

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

;***************************************************************
;			type		size		name	register 
; argument	int			4(int)		fd		edi	
; argument	void*		8(ptr)		buf		rsi	
; argument	size_t		8(long)		count	rdx		
; syscall	read		number		0		rax
;***************************************************************

section .text
	global ft_read				; make ft_read visible to the linker
	extern __errno_location		; external libc function to access errno

ft_read:
	mov rax, 0					; syscall number for read (SYS_read)
	syscall						; Enter kernel mode and execute read

	cmp rax, 0					; check syscall return value
	jl .error					; jump if rax < 0 (syscall error, rax = -errno)
	ret							; return number of bytes read (rax >= 0)

.error:
	neg rax						; convert -errno to positive errno value
	mov rdi, rax				; store errno (rax) value in rdi
	call __errno_location		; get pointer to thread-local errno
	mov [rax], rdi				; set errno = error code
	mov rax, -1					; return -1 to signal error
	ret							; return to caller
