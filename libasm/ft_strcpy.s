# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_strcpy.s                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/13 16:03:31 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/13 16:03:31 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

;***************************************************
;	char	*ft_strcpy(char *dst, const char *src);
;				type	size	name	register 
;	argument	char *	8(ptr)	dst   	rdi 
;	argument	char *	8(ptr)	src   	rsi 
;	variable	size_t	8(long)	i   	rax	
;***************************************************

section .text
    global ft_strcpy

ft_strcpy:
    mov rax, 0
    jmp .loop

    .loop:
        mov al, BYTE [rsi + rax]
        mov BYTE [rdi + rax], al
        test al, al
        jne .increment
        
        mov rax, rdi
        ret

    .increment:
        inc rax
        jmp .loop
