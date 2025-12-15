# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    ft_strlen.s                                        :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com    +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/13 16:03:36 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/13 16:03:36 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

;***************************************************
;	size_t	ft_strlen(const char *s);
;
;				type	size	name	register   
;	argument	char *	8(ptr)	s   	rdi 
;	variable	size_t	8(long)	i   	rax 
;***************************************************

section .text
    global ft_strlen

ft_strlen:
    mov rax, 0
    jmp .loop

    .loop:
        cmp BYTE [rdi + rax], 0
        jne .increment
        jmp .endloop

    .increment:
        inc rax
        jmp .loop

    .endloop:
        ret
