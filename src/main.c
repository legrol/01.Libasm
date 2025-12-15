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
    printf("MyFunction = %zu\n", ft_strlen("42Malaga"));
    printf("RealFunction = %zu\n", strlen("42Malaga"));
    printf("MyFunction = %zu\n", ft_strlen("We love code in 42 Malaga!"));
    printf("RealFunction = %zu\n", strlen("We love code in 42 Malaga!"));
}

void	ft_strcpy_test()
{
	char dst[64];

    printf("========================\n");
	printf("ft_strcpy test\n");
	printf("========================\n");
    printf("MyFunction = %s\n", ft_strcpy(dst, "Hades"));
	printf("RealFunction = %s\n", strcpy(dst, "Hades"));
	printf("MyFunction = %s\n", ft_strcpy(dst, "Up2You"));
	printf("RealFunction = %s\n", strcpy(dst, "Up2You"));
	printf("MyFunction = %s\n", ft_strcpy(dst, ""));
	printf("RealFunction = %s\n", strcpy(dst, ""));
}

int	main(int argc, char **argv)
{
    ft_strlen_test();
	ft_strcpy_test();


    return (0);
}
