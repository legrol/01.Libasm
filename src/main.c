/* ************************************************************************** */
/*                                                                            */
/*                                                        :::      ::::::::   */
/*   main.c                                             :+:      :+:    :+:   */
/*                                                    +:+ +:+         +:+     */
/*   By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+        */
/*                                                +#+#+#+#+#+   +#+           */
/*   Created: 2025/12/14 20:20:39 by rdel-olm          #+#    #+#             */
/*   Updated: 2025/12/21 13:43:45 by rdel-olm         ###   ########.fr       */
/*                                                                            */
/* ************************************************************************** */

#include "./libasm.h"

/* ************************************************************************************************************************** */
void	ft_strlen_test()
{
	printf("\n" BLUE "========================\n");
	printf("ft_strlen test\n");
	printf("========================\n" RESET "\n");

	printf("Count the characters in the string " RED "42Malaga" RESET "\n");
	printf(CYAN "My Function returned = %lu\n" RESET, (unsigned long)ft_strlen("42Malaga"));
	printf(GREEN "Real Function returned = %lu\n" RESET, (unsigned long)strlen("42Malaga"));

	printf("\nCount the characters in the string " RED "We love code in 42 Malaga!" RESET "\n");
	printf(CYAN "My Function returned = %lu\n" RESET, (unsigned long)ft_strlen("We love code in 42 Malaga!"));
	printf(GREEN "Real Function returned = %lu\n" RESET, (unsigned long)strlen("We love code in 42 Malaga!"));
}

/* ************************************************************************************************************************** */

void	ft_strcpy_test()
{
	char dst[64];

	printf("\n" BLUE "========================\n");
	printf("ft_strcpy test\n");
	printf("========================\n" RESET "\n");

	printf("Copy " RED "Hades " RESET "in " YELLOW "dst\n" RESET);
	printf(CYAN "My Function returned = %s\n" RESET, ft_strcpy(dst, "Hades"));
	printf(GREEN "Real Function returned = %s\n" RESET "\n", strcpy(dst, "Hades"));

	printf("Copy " RED "Up2You " RESET "in " YELLOW "dst\n" RESET);
	printf(CYAN "My Function returned = %s\n" RESET, ft_strcpy(dst, "Up2You"));
	printf(GREEN "Real Function returned = %s\n" RESET "\n", strcpy(dst, "Up2You"));
	
	printf("Copy " RED "empty string " RESET "in " YELLOW "dst\n" RESET);
	printf(CYAN "My Function returned = %s\n" RESET, ft_strcpy(dst, ""));
	printf(GREEN "Real Function returned = %s\n" RESET, strcpy(dst, ""));
}

/* ************************************************************************************************************************** */

void	check_strcmp(char *s1, char *s2)
{
	int ret1 = ft_strcmp(s1, s2);
	int ret2 = strcmp(s1, s2);

	printf("Compare " RED "\"%s\" " RESET "vs " YELLOW "\"%s\"\n" RESET, s1, s2);
	printf(CYAN "My Function returned = %d\n" RESET, ret1);
	printf(GREEN "Real Function returned = %d\n\n" RESET, ret2);

}

/* ************************************************************************************************************************** */

void	ft_strcmp_test(void)
{
	printf("\n" BLUE "========================\n");
	printf("ft_strcmp test\n");
	printf("========================\n" RESET" \n");
	
	check_strcmp("abcde", "abcde");
	check_strcmp("abcde", "abdde");
	check_strcmp("abcde", "abbde");
	check_strcmp("abcde", "abcd ");
	check_strcmp("abcd", "abcde");
	check_strcmp("abcde", "g");
	check_strcmp("abcde", "0");
}

/* ************************************************************************************************************************** */

void	ft_write_test()
{
	ssize_t ret1, ret2;

	printf(BLUE "========================\n");
	printf("ft_write test\n");
	printf("========================\n"	RESET "\n");

	printf("Writing " RED "'Hello from 42Malaga!'" RESET " to stdout:\n");
	printf(MAGENTA);
	fflush(stdout);
	ret1 = ft_write(1, "Hello from 42Malaga!\n", 22);
	{
		int dn = open("/dev/null", O_WRONLY);
		if (dn >= 0) {
			ret2 = write(dn, "Hello from 42Malaga!\n", 22);
			close(dn);
		} else {
			/* fallback: write to stdout if /dev/null not available */
			ret2 = write(1, "Hello from 42Malaga!\n", 22);
		}
	}
	printf(RESET CYAN "My Function returned: %ld\n" RESET, (long)ret1);
	printf(GREEN "Real Function returned: %ld\n\n" RESET, (long)ret2);

	printf("Writing " RED "'Hello from 42!'" RESET " to stdout:\n");
	printf(MAGENTA);
	fflush(stdout);
	ret1 = ft_write(1, "Hello from 42!\n", 16);
	{
		int dn = open("/dev/null", O_WRONLY);
		if (dn >= 0) {
			ret2 = write(dn, "Hello from 42!\n", 16);
			close(dn);
		} else {
			ret2 = write(1, "Hello from 42!\n", 16);
		}
	}
	printf(RESET CYAN "My Function returned: %ld\n" RESET, (long)ret1);
	printf(RESET GREEN "Real Function returned: %ld\n" RESET, (long)ret2);

	printf("\nTesting invalid fd " RED "(-42):\n" RESET);

	errno = 0;
	ret1 = ft_write(-42, "test", 4);
	printf(RESET CYAN "My Function returned: %ld\n" RESET, (long)ret1);
	printf(MAGENTA "My errno: %d (%s)\n" RESET, errno, strerror(errno));

	errno = 0;
	ret2 = write(-42, "test", 4);
	printf(RESET GREEN "Real Function returned: %ld\n" RESET, (long)ret2);
	printf(MAGENTA "Real errno: %d (%s)\n" RESET, errno, strerror(errno));
}

/* ************************************************************************************************************************** */

void	ft_read_test()
{
	char buf1[32];
	char buf2[32];
	ssize_t r1;
	ssize_t r2;

	printf("\n" BLUE "========================\n");
	printf("ft_read test\n");
	printf("========================\n" RESET "\n");
	printf("Reading " RED "5 bytes" RESET " from stdin with function read " RED "(type something)" RESET ":\n");
	printf(MAGENTA);
	fflush(stdout);
	r1 = ft_read(0, buf1, 5);
	if (r1 == 5 && buf1[4] != '\n')
	{
		char c;
		while (read(0, &c, 1) > 0 && c != '\n');
	}
	printf(RESET);
	buf1[(r1 > 0 && r1 < 32) ? r1 : 0] = '\0';
	if (r1 > 0 && buf1[r1 - 1] == '\n')
		buf1[r1 - 1] = '\0';
	printf(CYAN "My Function read %ld bytes: '" MAGENTA "%s" CYAN "'\n" RESET, (long)r1, buf1);

	printf("Reading " RED "5 bytes" RESET " from stdin with real read " RED "(type something)" RESET ":\n");
	printf(MAGENTA);
	fflush(stdout);
	r2 = read(0, buf2, 5);
	if (r2 == 5 && buf2[4] != '\n')
	{
		char c;
		while (read(0, &c, 1) > 0 && c != '\n');
	}
	printf(RESET);
	buf2[(r2 > 0 && r2 < 32) ? r2 : 0] = '\0';
	if (r2 > 0 && buf2[r2 - 1] == '\n')
		buf2[r2 - 1] = '\0';
	printf(GREEN "Real Function read %ld bytes: '" MAGENTA "%s" GREEN "'\n" RESET, (long)r2, buf2);

	printf("\nTesting invalid fd " RED "(-42):\n" RESET); 	
	errno = 0;
	r1 = ft_read(-42, buf1, 5);
	printf(CYAN "My Function returned: %ld\n" RESET, (long)r1);
	printf(MAGENTA "My errno: %d (%s)\n" RESET, errno, strerror(errno));

	errno = 0;
	r2 = read(-42, buf2, 5);
	printf(GREEN "Real Function returned: %ld\n" RESET, (long)r2);
	printf(MAGENTA "Real errno: %d (%s)\n" RESET, errno, strerror(errno));
}

/* ************************************************************************************************************************** */

void	ft_strdup_test()
{
	char *dup1, *dup2;
	char *dup3, *dup4;
	char *dup5, *dup6;

	printf("\n" BLUE "========================\n");
	printf("ft_strdup test\n");
	printf("========================\n" RESET "\n");

	printf("Duplicating " RED "\"Hello 42!\"" RESET ":\n");
	dup1 = ft_strdup("Hello 42!");
	dup2 = strdup("Hello 42!");
	if (!dup1 || !dup2)
	{
		printf(RED "Allocation failed\n" RESET);
		return;
	}
	printf(CYAN "My Function: \"%s\"\n" RESET, dup1);
	printf(GREEN "Real Function: \"%s\"\n" RESET, dup2);
	printf("Different pointers (new memory)? %s\n", (dup1 != dup2) ? GREEN "YES (OK)" RESET : RED "NO (WRONG)" RESET);
	dup1[0] = 'X';
	printf(MAGENTA "Modifying copy (first char to 'X'): \"%s\"\n" RESET, dup1);
	printf(MAGENTA "Printing original: \"%s\"\n" RESET, dup2);
	free(dup1);
	free(dup2);

	printf("\nDuplicating " RED "\"Libasm Project\"" RESET ":\n");
	dup3 = ft_strdup("Libasm Project");
	dup4 = strdup("Libasm Project");
	if (!dup3 || !dup4)
	{
		printf(RED "Allocation failed\n" RESET);
		return;
	}
	printf(CYAN "My Function: \"%s\"\n" RESET, dup3);
	printf(GREEN "Real Function: \"%s\"\n" RESET, dup4);
	dup3[0] = 'X';
	printf("Different pointers (new memory)? %s\n", (dup3 != dup4) ? GREEN "YES (OK)" RESET : RED "NO (WRONG)" RESET);
	dup3[0] = 'X';
	printf(MAGENTA "Modifying copy (first char to 'X'): \"%s\"\n" RESET, dup3);
	printf(MAGENTA "Printing original: \"%s\"\n" RESET, dup4);
	free(dup3);
	free(dup4);

	printf("\nDuplicating " RED "empty string \"\"" RESET ":\n");
	dup5 = ft_strdup("");
	dup6 = strdup("");
	if (!dup5 || !dup6)
	{
		printf(RED "Allocation failed\n" RESET);
		return;
	}
	printf(CYAN "My Function: \"%s\" (len=%lu)\n" RESET, dup5, strlen(dup5));
	printf(GREEN "Real Function: \"%s\" (len=%lu)\n\n" RESET, dup6, strlen(dup6));
	free(dup5);
	free(dup6);
}

/* ************************************************************************************************************************** */

/* Bonus tests and helpers: compiled only when INCLUDE_BONUS is defined */
#ifdef INCLUDE_BONUS

void	ft_atoi_base_test(void)
{
	int	res1, res2;

	printf(BLUE "========================\n");
	printf("ft_atoi_base test\n");
	printf("========================\n" RESET "\n");

	printf(CYAN "Test 1: " RESET RED "Decimal Base (\"0123456789\")" RESET "\n");
	res1 = ft_atoi_base("42", "0123456789");
	res2 = atoi("42");
	printf("  Input: " MAGENTA "\"42\" " RESET "-> My Result: " YELLOW "%d" RESET ", Expected: " GREEN "%d " RESET "%s\n", res1, res2, (res1 == res2) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("-123", "0123456789");
	res2 = atoi("-123");
	printf("  Input: " MAGENTA "\"-123\" " RESET "-> My Result: " YELLOW "%d" RESET ", Expected: " GREEN "%d " RESET "%s\n\n", res1, res2, (res1 == res2) ? GREEN "✓" RESET : RED "✗" RESET);

	printf(CYAN "Test 2: " RESET RED "Binary Base (\"01\")" RESET "\n");
	res1 = ft_atoi_base("1010", "01");
	printf("  Input: " MAGENTA "\"1010\" " RESET "(binary) -> My Result: " YELLOW "%d" RESET " (expected 10) %s\n", res1, (res1 == 10) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("-1111", "01");
	printf("  Input: " MAGENTA "\"-1111\" " RESET "(binary) -> My Result: " YELLOW "%d" RESET " (expected -15) %s\n\n", res1, (res1 == -15) ? GREEN "✓" RESET : RED "✗" RESET);

	printf(CYAN "Test 3: " RESET RED "Hexadecimal Base (\"0123456789ABCDEF\")" RESET "\n");
	res1 = ft_atoi_base("FF", "0123456789ABCDEF");
	printf("  Input: " MAGENTA "\"FF\" " RESET "(hex) -> My Result: " YELLOW "%d" RESET " (expected 255) %s\n", res1, (res1 == 255) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("ABCD", "0123456789ABCDEF");
	printf("  Input: " MAGENTA "\"ABCD\" " RESET "(hex) -> My Result: " YELLOW "%d" RESET " (expected 43981) %s\n", res1, (res1 == 43981) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base(" -1A", "0123456789ABCDEF");
	printf("  Input: " MAGENTA "\" -1A\" " RESET "(hex) -> My Result: " YELLOW "%d" RESET " (expected -26) %s\n\n", res1, (res1 == -26) ? GREEN "✓" RESET : RED "✗" RESET);

	printf(CYAN "Test 4: " RESET RED "Whitespace Handling" RESET "\n");
	res1 = ft_atoi_base("  +42", "0123456789");
	printf("  Input: " MAGENTA "\"  +42\" " RESET "-> My Result: " YELLOW "%d" RESET " (expected 42) %s\n", res1, (res1 == 42) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("\t-99", "0123456789");
	printf("  Input: " MAGENTA "\"\\t-99\" " RESET "-> My Result: " YELLOW "%d" RESET " (expected -99) %s\n\n", res1, (res1 == -99) ? GREEN "✓" RESET : RED "✗" RESET);

	printf(CYAN "Test 5: " RESET RED "Invalid Bases (should return 0)" RESET "\n");
	res1 = ft_atoi_base("42", "01+0");
	printf("  Base with " MAGENTA "'+' -> '01+0'" RESET ": My Result: " YELLOW "%d " RESET "(expected 0) %s\n", res1, (res1 == 0) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("42", "0");
	printf("  Base with " MAGENTA "1 char -> '0'" RESET ": My Result: " YELLOW "%d " RESET "(expected 0) %s\n", res1, (res1 == 0) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("42", "01 1");
	printf("  Base with " MAGENTA "space -> '01 1'" RESET ": My Result: " YELLOW "%d " RESET "(expected 0) %s\n", res1, (res1 == 0) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("42", "0101");
	printf("  Base with " MAGENTA "duplicates -> '0101'" RESET ": My Result: " YELLOW "%d " RESET "(expected 0) %s\n\n", res1, (res1 == 0) ? GREEN "✓" RESET : RED "✗" RESET);

	printf(CYAN "Test 6: " RESET RED "Invalid Input (chars not in base)" RESET "\n");
	res1 = ft_atoi_base("42F", "0123456789");
	printf("  Input: " MAGENTA "\"42F\" " RESET "in decimal -> My Result: " YELLOW "%d" RESET " (expected 42) %s\n", res1, (res1 == 42) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("529", "01234567");
	printf("  Input: " MAGENTA "\"529\" " RESET "in octal -> My Result: " YELLOW "%d" RESET " (expected 42) %s\n", res1, (res1 == 42) ? GREEN "✓" RESET : RED "✗" RESET);
	res1 = ft_atoi_base("", "0123456789");
	printf("  Input: " MAGENTA "empty string " RESET "-> My Result: " YELLOW "%d" RESET " (expected 0) %s\n\n", res1, (res1 == 0) ? GREEN "✓" RESET : RED "✗" RESET);
}

/* ************************************************************************************************************************** */

void	free_list(t_list *list)
{
	t_list	*tmp;

	while (list)
	{
		tmp = list;
		list = list->next;
		free(tmp);
	}
}

void	ft_list_push_front_test(void)
{
	t_list	*list;
	int		data1 = 42;
	int		data2 = 100;
	int		data3 = 200;

	printf(BLUE "========================\n");
	printf("ft_list_push_front test\n");
	printf("========================\n\n" RESET);

	list = NULL;
	printf("Initial list: " CYAN "NULL\n" RESET);

	ft_list_push_front(&list, &data1);
	printf("After push(" RED "42" RESET "): list points to node with data " GREEN "✓\n" RESET);
	printf("  node->data = " YELLOW "%d " RESET "(expected 42) %s\n", *(int *)list->data, (*(int *)list->data == 42) ? GREEN "✓" RESET : RED "✗" RESET);
	printf("  node->next = " CYAN "NULL" RESET " (expected NULL) %s\n\n", (list->next == NULL) ? GREEN "✓" RESET : RED "✗" RESET);

	ft_list_push_front(&list, &data2);
	printf("After push(" RED "100" RESET "): new node at head\n");
	printf("  head->data = " YELLOW "%d " RESET "(expected 100) %s\n", *(int *)list->data, (*(int *)list->data == 100) ? GREEN "✓" RESET : RED "✗" RESET);
	printf("  head->next->data = " YELLOW "%d " RESET "(expected 42) %s\n", *(int *)list->next->data, (*(int *)list->next->data == 42) ? GREEN "✓" RESET : RED "✗" RESET);
	printf("  head->next->next = " CYAN "NULL" RESET " %s\n\n", (list->next->next == NULL) ? GREEN "✓" RESET : RED "✗" RESET);

	ft_list_push_front(&list, &data3);
	printf("After push(" RED "200" RESET "): new node at head\n");
	printf("  head->data = " YELLOW "%d " RESET "(expected 200) %s\n", *(int *)list->data, (*(int *)list->data == 200) ? GREEN "✓" RESET : RED "✗" RESET);
	printf("  head->next->data = " YELLOW "%d " RESET "(expected 100) %s\n", *(int *)list->next->data, (*(int *)list->next->data == 100) ? GREEN "✓" RESET : RED "✗" RESET);
	printf("  head->next->next->data = " YELLOW "%d " RESET "(expected 42) %s\n", *(int *)list->next->next->data, (*(int *)list->next->next->data == 42) ? GREEN "✓" RESET : RED "✗" RESET);
	printf("  head->next->next->next = " CYAN "NULL" RESET " (expected NULL) %s\n\n", (list->next->next->next == NULL) ? GREEN "✓" RESET : RED "✗" RESET);

	free_list(list);
}

/* ************************************************************************************************************************** */

void	ft_list_size_test(void)
{
	t_list	*list;
	int		data1 = 1;
	int		data2 = 2;
	int		data3 = 3;
	int		size;

	printf(BLUE "========================\n");
	printf("ft_list_size test\n");
	printf("========================\n\n" RESET);

	list = NULL;
	size = ft_list_size(list);
	printf("Empty list size: " RED "%d " RESET "(expected 0) %s\n\n", size, (size == 0) ? GREEN "✓" RESET : RED "✗" RESET);

	ft_list_push_front(&list, &data1);
	size = ft_list_size(list);
	printf("After adding " CYAN "1 " RESET "node: size = " GREEN "%d " RESET "(expected 1) %s\n", size, (size == 1) ? GREEN "✓" RESET : RED "✗" RESET);

	ft_list_push_front(&list, &data2);
	size = ft_list_size(list);
	printf("After adding " CYAN "2 " RESET "nodes: size = " GREEN "%d " RESET "(expected 2) %s\n", size, (size == 2) ? GREEN "✓" RESET : RED "✗" RESET);
	ft_list_push_front(&list, &data3);
	size = ft_list_size(list);
	printf("After adding " CYAN "3 " RESET "nodes: size = " GREEN "%d " RESET "(expected 3) %s\n\n", size, (size == 3) ? GREEN "✓" RESET : RED "✗" RESET);

	free_list(list);
}

/* ************************************************************************************************************************** */

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

	printf(BLUE "========================\n");
	printf("ft_list_sort test\n");
	printf("========================\n\n" RESET);

	list = NULL;
	ft_list_push_front(&list, &data1);
	ft_list_push_front(&list, &data2);
	ft_list_push_front(&list, &data3);
	ft_list_push_front(&list, &data4);

	printf("Original list (as inserted): " RED "5 -> 99 -> 10 -> 42\n" RESET);
	printf("  Values: " CYAN "%d, %d, %d, %d\n\n" RESET, *(int *)list->data, *(int *)list->next->data, *(int *)list->next->next->data, *(int *)list->next->next->next->data);

	ft_list_sort(&list, &ft_compare_ints);

	printf("After sorting (ascending): " RED "5 -> 10 -> 42 -> 99\n" RESET);
	printf("  Values: " CYAN "%d, %d, %d, %d\n" RESET, *(int *)list->data, *(int *)list->next->data, *(int *)list->next->next->data, *(int *)list->next->next->next->data);
	int sorted = (*(int *)list->data == 5 && *(int *)list->next->data == 10 && 
				  *(int *)list->next->next->data == 42 && *(int *)list->next->next->next->data == 99);
	printf("  Result: %s\n\n", sorted ? GREEN "✓ Correctly sorted" RESET : RED "✗ Not sorted" RESET);

	free_list(list);
}

/* ************************************************************************************************************************** */

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
	int		data4 = 42;
	int		remove_val = 42;

	printf(BLUE "========================\n");
	printf("ft_list_remove_if test\n");
	printf("========================\n\n" RESET);

	list = NULL;
	ft_list_push_front(&list, &data1);
	ft_list_push_front(&list, &data2);
	ft_list_push_front(&list, &data3);
	ft_list_push_front(&list, &data4);

	printf("Original list: " RED "42 -> 42 -> 10 -> 42\n" RESET);
	printf("  Values: " CYAN "%d, %d, %d, %d " RESET "(size: " GREEN "%d" RESET ")\n", *(int *)list->data, *(int *)list->next->data, 
			*(int *)list->next->next->data, *(int *)list->next->next->next->data, ft_list_size(list));
	printf("  Removing all nodes with value " YELLOW "42" RESET "\n\n");

	ft_list_remove_if(&list, &remove_val, &ft_compare_remove, &ft_free_int);

	printf("After removing value " YELLOW "42" RESET ": " RED "10 -> NULL\n" RESET);
	if (list != NULL)
	{
		printf("  First node value: " CYAN "%d " RESET "(expected 10) %s\n", *(int *)list->data, (*(int *)list->data == 10) ? GREEN "✓" RESET : RED "✗" RESET);
		printf("  Next node: " CYAN "%s" RESET " %s\n", (list->next == NULL) ? "NULL" : "NOT NULL", (list->next == NULL) ? GREEN "✓" RESET : RED "✗" RESET);
		printf("  List size: " CYAN "%d " RESET "(expected 1) %s\n\n", ft_list_size(list), (ft_list_size(list) == 1) ? GREEN "✓" RESET : RED "✗" RESET);
	}

	free_list(list);
}

/* ************************************************************************************************************************** */


#endif /* INCLUDE_BONUS */

int	main(void)
{
	#ifndef INCLUDE_BONUS
		/* mandatory functions */
		ft_strlen_test();
		ft_strcpy_test();
		ft_strcmp_test();
		ft_write_test();
		ft_read_test();
		ft_strdup_test();
	#else
		/* only bonus functions when built with -DINCLUDE_BONUS */
		ft_atoi_base_test();
		ft_list_push_front_test();
		ft_list_size_test();
		ft_list_sort_test();
		ft_list_remove_if_test();
	#endif

	return (0);
}
