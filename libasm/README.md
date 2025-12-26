# libasm (Mandatory)

This folder contains the mandatory implementations for the Libasm project.

Overview
--------
- Implementations are written in 64-bit NASM (Intel syntax) and produce
  object files assembled into `libasm.a`.
- Mandatory functions included here:
  - `ft_strlen`, `ft_strcpy`, `ft_strcmp`, `ft_write`, `ft_read`, `ft_strdup`.

Notes
-----
- All functions follow the System V AMD64 calling convention: arguments
  in `rdi, rsi, rdx, rcx, r8, r9`, return value in `rax` and proper
  preservation of callee-saved registers (`rbx`, `rbp`, `r12..r15`).
- This directory contains only NASM sources; no GCC-assembled helpers are
  stored here. Helper wrappers (PIE/PLT friendly) live in the repository
  `utils/` and are linked only into the test executable, not archived in
  `libasm.a`.

Building
--------
Use the top-level `Makefile` to build the library and tests. From the
project root:

```bash
make        # builds libasm.a (mandatory)
make test   # links test executable that uses libasm.a
```

Testing
-------
Run `./test` to execute the test harness. For memory checks, use Valgrind
on the `test` binary (not on `libasm.a` because it is not executable):

```bash
valgrind --leak-check=full ./test
```

For more details see the project root `README.md`.
