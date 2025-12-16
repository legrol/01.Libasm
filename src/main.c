/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rdel-olm <rdel-olm@student.42malaga.com    +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/14 20:20:39 by rdel-olm          #+#    #+#             */
/*   Updated: 2025/12/14 20:20:39 by rdel-olm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "libasm.h"

void	ft_strlen_test()
{
	printf("========================\n");
	printf("ft_strlen test\n");
	printf("========================\n");
	printf("Count the characters in the string 42Malaga\n");
	printf("MyFunction = %lu\n", (unsigned long)ft_strlen("42Malaga"));
	printf("RealFunction = %lu\n", (unsigned long)strlen("42Malaga"));

	printf("Count the characters in the string We love code in 42 Malaga!\n");
	printf("MyFunction = %lu\n", (unsigned long)ft_strlen("We love code in 42 Malaga!"));
	printf("RealFunction = %lu\n", (unsigned long)strlen("We love code in 42 Malaga!"));
}

void	ft_strcpy_test()
{
	char dst[64];

	printf("========================\n");
	printf("ft_strcpy test\n");
	printf("========================\n");
	printf("Copy " RED "Hades " RESET "in " CYAN "dst\n");
	printf("MyFunction = %s\n", ft_strcpy(dst, "Hades"));
	printf("RealFunction = %s\n", strcpy(dst, "Hades"));

	printf("Copy " RED "Up2You " RESET "in " CYAN "dst\n");
	printf("MyFunction = %s\n", ft_strcpy(dst, "Up2You"));
	printf("RealFunction = %s\n", strcpy(dst, "Up2You"));

	printf("Copy " RED "empty string " RESET "in " CYAN "dst\n");
	printf("MyFunction = %s\n", ft_strcpy(dst, ""));
	printf("RealFunction = %s\n", strcpy(dst, ""));
}

int ft_strcmp_test()
{
	printf("========================\n");
	printf("ft_strcmp test\n");
	printf("========================\n");
	printf("Compare " RED "abcde " RESET "vs " CYAN "abcde\n");
	printf("MyFunction = %d\n", ft_strcmp("abcde", "abcde"));
	printf("RealFunction = %d\n", strcmp("abcde", "abcde"));

	printf("Compare " RED "abcde " RESET "vs " CYAN "abdde\n");
	printf("MyFunction = %d\n", ft_strcmp("abcde", "abdde"));
	printf("RealFunction = %d\n", strcmp("abcde", "abdde"));

	printf("Compare " RED "abcde " RESET "vs " CYAN "abbde\n");
	printf("MyFunction = %d\n", ft_strcmp("abcde", "abbde"));
	printf("RealFunction = %d\n", strcmp("abcde", "abbde"));
	
	printf("Compare " RED "abcde " RESET "vs " CYAN "abcde with null bytes\n" RESET);
	printf("MyFunction = %d\n", ft_strcmp("abcde", "abcde"));
	printf("RealFunction = %d\n", strcmp("abcde", "abcde"));
	
	printf("Compare " RED "abcde " RESET "vs " CYAN "g\n");
	printf("MyFunction = %d\n", ft_strcmp("abcde", "g"));
	printf("RealFunction = %d\n", strcmp("abcde", "g"));

	printf("Compare " RED "abcde " RESET "vs " CYAN "0\n" RESET);
	printf("MyFunction = %d\n", ft_strcmp("abcde", "0"));
	printf("RealFunction = %d\n", strcmp("abcde", "0"));
	return (0);
}

int	main(void)
{
	ft_strlen_test();
	ft_strcpy_test();
	ft_strcmp_test();


	return (0);
}
