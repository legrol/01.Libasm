# libasm_bonus (Optional / Bonus)

This folder contains optional (bonus) NASM implementations extending the
core library with linked-list and additional utilities.

Overview
--------
- Bonus sources are written in NASM and compiled into object files that can
  be added to `libasm.a` using the `bonus` Makefile target.
- Typical bonus functions provided in this repository:
  - list utilities: `ft_list_push_front`, `ft_list_size`, `ft_list_sort`,
    `ft_list_remove_if`.
  - other utilities such as `ft_atoi_base`.

Notes
-----
- Some bonus routines call `malloc`/`free` indirectly via small wrappers
  (`utils/malloc_wrapper.S` and `utils/free_wrapper.S`) so they remain
  PIE-friendly when the final test executable is built.
- Data stored in list nodes are pointers (`void *`). The node structure is
  typically 16 bytes on x86_64 (two 8-byte pointers: `data` and `next`).

Building & Testing
------------------
From the project root:

```bash
make bonus       # assemble bonus objects and update libasm.a
make test_bonus  # build test executable with -DINCLUDE_BONUS and run
```

Run `./test` and inspect the bonus section output. Use Valgrind to check
for memory issues on the test binary:

```bash
valgrind --leak-check=full ./test
```

For implementation details read the comments at the top of each `.s` file.
