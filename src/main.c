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

void	ft_atoi_base_test(void)
{
	int	res1, res2;

	printf("========================\n");
	printf("ft_atoi_base test\n");
	printf("========================\n\n");

	printf("Test 1: " CYAN "Decimal Base (\"0123456789\")" RESET "\n");
	res1 = ft_atoi_base("42", "0123456789");
	res2 = atoi("42");
	printf("  Input: \"42\" -> My Result: %d, Expected: %d %s\n", res1, res2, (res1 == res2) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("-123", "0123456789");
	res2 = atoi("-123");
	printf("  Input: \"-123\" -> My Result: %d, Expected: %d %s\n\n", res1, res2, (res1 == res2) ? GREEN "✓" RESET : RED "✗" RESET);

	printf("Test 2: " CYAN "Binary Base (\"01\")" RESET "\n");
	res1 = ft_atoi_base("1010", "01");
	printf("  Input: \"1010\" (binary) -> My Result: %d (expected 10) %s\n", res1, (res1 == 10) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("-1111", "01");
	printf("  Input: \"-1111\" (binary) -> My Result: %d (expected -15) %s\n\n", res1, (res1 == -15) ? GREEN "✓" RESET : RED "✗" RESET);

	printf("Test 3: " CYAN "Hexadecimal Base (\"0123456789ABCDEF\")" RESET "\n");
	res1 = ft_atoi_base("FF", "0123456789ABCDEF");
	printf("  Input: \"FF\" (hex) -> My Result: %d (expected 255) %s\n", res1, (res1 == 255) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("ABCD", "0123456789ABCDEF");
	printf("  Input: \"ABCD\" (hex) -> My Result: %d (expected 43981) %s\n\n", res1, (res1 == 43981) ? GREEN "✓" RESET : RED "✗" RESET);

	printf("Test 4: " CYAN "Whitespace Handling" RESET "\n");
	res1 = ft_atoi_base("  +42", "0123456789");
	printf("  Input: \"  +42\" -> My Result: %d (expected 42) %s\n", res1, (res1 == 42) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("\t-99", "0123456789");
	printf("  Input: \"\\t-99\" -> My Result: %d (expected -99) %s\n\n", res1, (res1 == -99) ? GREEN "✓" RESET : RED "✗" RESET);

	printf("Test 5: " RED "Invalid Bases (should return 0)" RESET "\n");
	res1 = ft_atoi_base("42", "01+0");
	printf("  Base with '+': My Result: %d (expected 0) %s\n", res1, (res1 == 0) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("42", "0");
	printf("  Base with 1 char: My Result: %d (expected 0) %s\n", res1, (res1 == 0) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("42", "01 1");
	printf("  Base with space: My Result: %d (expected 0) %s\n", res1, (res1 == 0) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("42", "0101");
	printf("  Base with duplicates: My Result: %d (expected 0) %s\n\n", res1, (res1 == 0) ? GREEN "✓" RESET : RED "✗" RESET);

	printf("Test 6: " CYAN "Invalid Input (chars not in base)" RESET "\n");
	res1 = ft_atoi_base("42F", "0123456789");
	printf("  Input: \"42F\" in decimal -> My Result: %d (expected 42) %s\n", res1, (res1 == 42) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("", "0123456789");
	printf("  Input: empty string -> My Result: %d (expected 0) %s\n\n", res1, (res1 == 0) ? GREEN "✓" RESET : RED "✗" RESET);
}

void	ft_list_push_front_test(void)
{
	t_list	*list;
	int		data1 = 42;
	int		data2 = 100;
	int		data3 = 200;

	printf("========================\n");
	printf("ft_list_push_front test\n");
	printf("========================\n\n");

	list = NULL;
	printf("Initial list: " CYAN "NULL\n" RESET);

	ft_list_push_front(&list, &data1);
	printf("After push(42): list points to node with data " GREEN "✓\n" RESET);
	printf("  node->data = %d (expected 42) %s\n", *(int *)list->data, (*(int *)list->data == 42) ? GREEN "✓" RESET : RED "✗" RESET);
	printf("  node->next = " CYAN "NULL" RESET " (expected NULL) %s\n\n", (list->next == NULL) ? GREEN "✓" RESET : RED "✗" RESET);

	ft_list_push_front(&list, &data2);
	printf("After push(100): new node at head\n");
	printf("  head->data = %d (expected 100) %s\n", *(int *)list->data, (*(int *)list->data == 100) ? GREEN "✓" RESET : RED "✗" RESET);
	printf("  head->next->data = %d (expected 42) %s\n", *(int *)list->next->data, (*(int *)list->next->data == 42) ? GREEN "✓" RESET : RED "✗" RESET);
	printf("  head->next->next = " CYAN "NULL" RESET " %s\n\n", (list->next->next == NULL) ? GREEN "✓" RESET : RED "✗" RESET);

	ft_list_push_front(&list, &data3);
	printf("After push(200): new node at head\n");
	printf("  head->data = %d (expected 200) %s\n", *(int *)list->data, (*(int *)list->data == 200) ? GREEN "✓" RESET : RED "✗" RESET);
	printf("  head->next->data = %d (expected 100) %s\n", *(int *)list->next->data, (*(int *)list->next->data == 100) ? GREEN "✓" RESET : RED "✗" RESET);
	printf("  head->next->next->data = %d (expected 42) %s\n\n", *(int *)list->next->next->data, (*(int *)list->next->next->data == 42) ? GREEN "✓" RESET : RED "✗" RESET);
}

void	ft_list_size_test(void)
{
	t_list	*list;
	int		data1 = 1;
	int		data2 = 2;
	int		data3 = 3;
	int		size;

	printf("========================\n");
	printf("ft_list_size test\n");
	printf("========================\n\n");

	list = NULL;
	size = ft_list_size(list);
	printf("Empty list size: %d (expected 0) %s\n\n", size, (size == 0) ? GREEN "✓" RESET : RED "✗" RESET);

	ft_list_push_front(&list, &data1);
	size = ft_list_size(list);
	printf("After adding 1 node: size = %d (expected 1) %s\n", size, (size == 1) ? GREEN "✓" RESET : RED "✗" RESET);

	ft_list_push_front(&list, &data2);
	size = ft_list_size(list);
	printf("After adding 2 nodes: size = %d (expected 2) %s\n", size, (size == 2) ? GREEN "✓" RESET : RED "✗" RESET);

	ft_list_push_front(&list, &data3);
	size = ft_list_size(list);
	printf("After adding 3 nodes: size = %d (expected 3) %s\n\n", size, (size == 3) ? GREEN "✓" RESET : RED "✗" RESET);
}

int	ft_compare_ints(void *a, void *b)
{
	int	ia = *(int *)a;
	int	ib = *(int *)b;
	return (ia - ib);
}

void	ft_list_sort_test(void)
{
	t_list	*list;
	int		data1 = 42;
	int		data2 = 10;
	int		data3 = 99;
	int		data4 = 5;

	printf("========================\n");
	printf("ft_list_sort test\n");
	printf("========================\n\n");

	list = NULL;
	ft_list_push_front(&list, &data1);
	ft_list_push_front(&list, &data2);
	ft_list_push_front(&list, &data3);
	ft_list_push_front(&list, &data4);

	printf("Original list (as inserted): 5 -> 99 -> 10 -> 42\n");
	printf("  Values: %d, %d, %d, %d\n\n", *(int *)list->data, *(int *)list->next->data, *(int *)list->next->next->data, *(int *)list->next->next->next->data);

	ft_list_sort(&list, &ft_compare_ints);

	printf("After sorting (ascending): 5 -> 10 -> 42 -> 99\n");
	printf("  Values: %d, %d, %d, %d\n", *(int *)list->data, *(int *)list->next->data, *(int *)list->next->next->data, *(int *)list->next->next->next->data);
	int sorted = (*(int *)list->data == 5 && *(int *)list->next->data == 10 && 
				  *(int *)list->next->next->data == 42 && *(int *)list->next->next->next->data == 99);
	printf("  Result: %s\n\n", sorted ? GREEN "✓ Correctly sorted" RESET : RED "✗ Not sorted" RESET);
}

int	ft_compare_remove(void *a, void *b)
{
	int	ia = *(int *)a;
	int	ib = *(int *)b;
	return (ia == ib ? 0 : 1);
}

void	ft_free_int(void *ptr)
{
	(void)ptr;  /* No operation needed for stack integers */
}

void	ft_list_remove_if_test(void)
{
	t_list	*list;
	int		data1 = 42;
	int		data2 = 10;
	int		data3 = 42;
	int		data4 = 5;
	int		remove_val = 42;

	printf("========================\n");
	printf("ft_list_remove_if test\n");
	printf("========================\n\n");

	list = NULL;
	ft_list_push_front(&list, &data1);
	ft_list_push_front(&list, &data2);
	ft_list_push_front(&list, &data3);
	ft_list_push_front(&list, &data4);

	printf("Original list: 42 -> 42 -> 10 -> 42\n");
	printf("  Values: %d, %d, %d, %d (size: %d)\n", *(int *)list->data, *(int *)list->next->data, 
			*(int *)list->next->next->data, *(int *)list->next->next->next->data, ft_list_size(list));
	printf("  Removing all nodes with value 42\n\n");

	ft_list_remove_if(&list, &remove_val, &ft_compare_remove, &ft_free_int);

	printf("After removing value 42: 10 -> NULL\n");
	if (list != NULL)
	{
		printf("  First node value: %d (expected 10) %s\n", *(int *)list->data, (*(int *)list->data == 10) ? GREEN "✓" RESET : RED "✗" RESET);
		printf("  Next node: " CYAN "%s" RESET " %s\n", (list->next == NULL) ? "NULL" : "NOT NULL", (list->next == NULL) ? GREEN "✓" RESET : RED "✗" RESET);
		printf("  List size: %d (expected 1) %s\n\n", ft_list_size(list), (ft_list_size(list) == 1) ? GREEN "✓" RESET : RED "✗" RESET);
	}
}

int	main(void)
{
	/* mandatory functions */
	ft_strlen_test();
	ft_strcpy_test();
	ft_strcmp_test();
	ft_write_test();
	ft_read_test();
	ft_strdup_test();

	/* bonus functions */
	ft_atoi_base_test();
	ft_list_push_front_test();
	ft_list_size_test();
	ft_list_sort_test();
	ft_list_remove_if_test();

	return (0);
}
