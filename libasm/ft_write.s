; **************************************************************************** #
;                                                                              #
;                                                         :::      ::::::::    #
;    ft_write.s                                         :+:      :+:    :+:    #
;                                                     +:+ +:+         +:+      #
;    By: rdel-olm <rdel-olm@student.42malaga.com    +#+  +:+       +#+         #
;                                                 +#+#+#+#+#+   +#+            #
;    Created: 2025/12/13 16:03:28 by rdel-olm          #+#    #+#              #
;    Updated: 2025/12/13 16:03:28 by rdel-olm         ###   ########.fr        #
;                                                                              #
; **************************************************************************** #

; ****************************************************************************
;                                                                             
; ssizeof ft_write(int fd, const void *buf, size_t count);                    
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

;***************************************************
;			type		size		name	register 
; argument	int			4(int)		fd		edi	
; argument	void*		8(ptr)		buf		rsi	
; argument	size_t		8(long)		count	rdx	
; syscall	write		number		1		rax	
;***************************************************

section .text
	global ft_write

ft_write:
	

