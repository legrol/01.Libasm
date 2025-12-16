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
	printf("My Function returned = %lu\n", (unsigned long)ft_strlen("42Malaga"));
	printf("Real Function returned = %lu\n", (unsigned long)strlen("42Malaga"));

	printf("Count the characters in the string We love code in 42 Malaga!\n");
	printf("My Function returned = %lu\n", (unsigned long)ft_strlen("We love code in 42 Malaga!"));
	printf("Real Function returned = %lu\n", (unsigned long)strlen("We love code in 42 Malaga!"));
}

void	ft_strcpy_test()
{
	char dst[64];

	printf("========================\n");
	printf("ft_strcpy test\n");
	printf("========================\n");
	printf("Copy " RED "Hades " RESET "in " CYAN "dst\n");
	printf("My Function returned = %s\n", ft_strcpy(dst, "Hades"));
	printf("Real Function returned = %s\n", strcpy(dst, "Hades"));

	printf("Copy " RED "Up2You " RESET "in " CYAN "dst\n");
	printf("My Function returned = %s\n", ft_strcpy(dst, "Up2You"));
	printf("Real Function returned = %s\n", strcpy(dst, "Up2You"));

	printf("Copy " RED "empty string " RESET "in " CYAN "dst\n");
	printf("My Function returned = %s\n", ft_strcpy(dst, ""));
	printf("Real Function returned = %s\n", strcpy(dst, ""));
}

int ft_strcmp_test()
{
	printf("========================\n");
	printf("ft_strcmp test\n");
	printf("========================\n");
	printf("Compare " RED "abcde " RESET "vs " CYAN "abcde\n");
	printf("My Function returned = %d\n", ft_strcmp("abcde", "abcde"));
	printf("Real Function returned= %d\n", strcmp("abcde", "abcde"));

	printf("Compare " RED "abcde " RESET "vs " CYAN "abdde\n");
	printf("My Function returned = %d\n", ft_strcmp("abcde", "abdde"));
	printf("Real Function returned = %d\n", strcmp("abcde", "abdde"));
	printf("Compare " RED "abcde " RESET "vs " CYAN "abbde\n");
	printf("My Function returned = %d\n", ft_strcmp("abcde", "abbde"));
	printf("Real Function returned = %d\n", strcmp("abcde", "abbde"));
	
	printf("Compare " RED "abcde " RESET "vs " CYAN "abcde with null bytes\n" RESET);
	printf("My Function returned = %d\n", ft_strcmp("abcde", "abcde"));
	printf("Real Function returned = %d\n", strcmp("abcde", "abcde"));
	
	printf("Compare " RED "abcde " RESET "vs " CYAN "g\n");
	printf("My Function returned = %d\n", ft_strcmp("abcde", "g"));
	printf("Real Function returned = %d\n", strcmp("abcde", "g"));
	printf("Compare " RED "abcde " RESET "vs " CYAN "0\n" RESET);
	printf("My Function returned = %d\n", ft_strcmp("abcde", "0"));
	printf("Real Function returned = %d\n", strcmp("abcde", "0"));
	return (0);
}

void	ft_write_test()
{
	ssize_t ret1, ret2;

	printf("========================\n");
	printf("ft_write test\n");
	printf("========================\n");
	
	printf("Writing " CYAN "'Hello from 42Malaga!\\n'" RESET " to stdout:\n");
	ret1 = ft_write(1, "Hello from 42Malaga!\n", 22);
	printf("My Function returned: %ld\n", (long)ret1);
	
	printf("Writing " CYAN "'Hello from 42!\\n'" RESET " to stdout:\n");
	ret2 = write(1, "Hello from 42!\n", 18);
	printf("Real Function returned: %ld\n", (long)ret2);
	
	printf("\nTesting invalid fd (-1):\n");

	errno = 0;
	ret1 = ft_write(-1, "test", 4);
	printf("My Function returned: %ld\n", (long)ret1);
	printf("My errno: %d (%s)\n", errno, strerror(errno));

	errno = 0;
	ret2 = write(-1, "test", 4);
	printf("Real Function returned: %ld\n", (long)ret2);
	printf("Real errno: %d (%s)\n", errno, strerror(errno));
}

void	ft_read_test()
{
	char buf1[32];
	char buf2[32];
	ssize_t r1;
	ssize_t r2;

	printf("========================\n");
	printf("ft_read test\n");
	printf("========================\n");
	printf("Reading 5 bytes from stdin (type something):\n");
	r1 = ft_read(0, buf1, 5);
	buf1[(r1 > 0 && r1 < 32) ? r1 : 0] = '\0';
	printf("My Function read %ld bytes: '%s'\n", (long)r1, buf1);

	printf("Reading 5 bytes from stdin with real read (type something):\n");
	r2 = read(0, buf2, 5);
	buf2[(r2 > 0 && r2 < 32) ? r2 : 0] = '\0';
	printf("Real Function read %ld bytes: '%s'\n", (long)r2, buf2);
	printf("\nTesting invalid fd (-1):\n");

	printf("\n[Error Test] Invalid fd (-1):\n");
	errno = 0;
	r1 = ft_read(-1, buf1, 5);
	printf("My Function returned: %ld\n", (long)r1);
	printf("My errno: %d (%s)\n", errno, strerror(errno));

	errno = 0;
	r2 = read(-1, buf2, 5);
	printf("Real Function returned: %ld\n", (long)r2);
	printf("Real errno: %d (%s)\n", errno, strerror(errno));
}

void	ft_strdup_test()
{
	char *dup1, *dup2;
	char *dup3, *dup4;
	char *dup5, *dup6;

	printf("========================\n");
	printf("ft_strdup test\n");
	printf("========================\n");

	printf("Duplicating " CYAN "\"Hello 42!\"" RESET ":\n");
	dup1 = ft_strdup("Hello 42!");
	dup2 = strdup("Hello 42!");
	if (!dup1 || !dup2)
	{
		printf("Allocation failed\n");
		return;
	}
	printf("My Function: \"%s\"\n", dup1);
	printf("Real Function: \"%s\"\n", dup2);
	printf("Pointers equal? %s\n", (dup1 == dup2) ? "YES (WRONG)" : "NO (OK)");
	dup1[0] = 'X';
	printf("After modification, My Function: \"%s\"\n", dup1);
	free(dup1);
	free(dup2);

	printf("\nDuplicating " CYAN "\"Libasm Project\"" RESET ":\n");
	dup3 = ft_strdup("Libasm Project");
	dup4 = strdup("Libasm Project");
	if (!dup3 || !dup4)
	{
		printf("Allocation failed\n");
		return;
	}
	printf("My Function: \"%s\"\n", dup3);
	printf("Real Function: \"%s\"\n", dup4);
	dup3[0] = 'X';
	printf("After modification, My Function: \"%s\"\n", dup3);
	free(dup3);
	free(dup4);

	printf("\nDuplicating " CYAN "empty string \"\"" RESET ":\n");
	dup5 = ft_strdup("");
	dup6 = strdup("");
	if (!dup5 || !dup6)
	{
		printf("Allocation failed\n");
		return;
	}
	printf("My Function: \"%s\" (len=%lu)\n", dup5, strlen(dup5));
	printf("Real Function: \"%s\" (len=%lu)\n", dup6, strlen(dup6));
	dup5[0] = 'X';
	printf("After modification, My Function: \"%s\"\n", dup5);
	free(dup5);
	free(dup6);
}


int	main(void)
{
	ft_strlen_test();
	ft_strcpy_test();
	ft_strcmp_test();
	ft_write_test();
	ft_read_test();
	ft_strdup_test();

	return (0);
}
