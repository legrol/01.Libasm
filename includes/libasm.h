/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   libasm.h                                           :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/14 20:21:18 by rdel-olm          #+#    #+#             */
/*   Updated: 2025/12/21 19:14:56 by rdel-olm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#ifndef LIBASM_H
# define LIBASM_H

// ============================================================================
// Libraries
// ============================================================================
# include <stddef.h>
# include <stdio.h>
# include <string.h>
# include <stdlib.h>
# include <unistd.h>
# include <sys/types.h>
# include <errno.h>
# include <fcntl.h>

// ============================================================================
// Access to my libraries
// ============================================================================
# include "colors.h"

// ============================================================================
// Structure for linked list - Bonus functions
// ============================================================================
typedef struct s_list
{
	void	*data;				//offset 0 (8 bytes)
	struct 	s_list	*next;		//offset 8 (8 bytes)
}	t_list;

// ============================================================================
// Mandatory functions
// ============================================================================
size_t	ft_strlen(const char *s);
char	*ft_strcpy(char *dst, const char *src);
int		ft_strcmp(const char *s1, const char *s2);
ssize_t	ft_write(int fd, const void *buf, size_t count);
ssize_t	ft_read(int fd, void *buf, size_t count);
char	*ft_strdup(const char *s);

// ============================================================================
// Bonus functions
// ============================================================================
int		ft_atoi_base(char *str, char *base);
void	ft_list_push_front(t_list **begin_list, void *data);
int		ft_list_size(t_list *begin_list);
void	ft_list_sort(t_list **begin_list, int (*cmp)());
void	ft_list_remove_if(t_list **begin_list, void *data_ref, int (*cmp)(), void (*free_fct)(void *));


// ============================================================================
// Others functions
// Declare the assembly wrapper for free implemented in `utils/malloc_wrapper.S`
// ============================================================================
void	free_wrapper(void *ptr);

#endif