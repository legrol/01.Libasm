# Libasm — Assembly yourself!

This repository implements the Libasm assignment: re-implement a small set
of C library functions in x86_64 assembly (NASM, Intel syntax) and provide a
static library `libasm.a` plus a test harness that demonstrates the
functions' behavior.

See also:

- `libasm/README.md` — details about the mandatory functions implemented in
  NASM and how to build/test them.
- `libasm_bonus/README.md` — details about bonus functions and list utilities.

Overview
--------
- Mandatory part: implement the following functions in 64-bit NASM `.s` files:
  `ft_strlen`, `ft_strcpy`, `ft_strcmp`, `ft_write`, `ft_read`, `ft_strdup`.
- Bonus part (optional): list and string utilities implemented in `libasm_bonus`.
- The library must be buildable without `-no-pie` (PIE-friendly). Small
  helper wrappers in GAS (`.S`) are used only to produce correct PLT/GOT
  relocations for the test executable.

Why this repository exists
--------------------------
The goal is educational: learn 64-bit assembly programming and the calling
convention, syscalls, and linking behavior on Linux x86_64. The project also
practices packaging assembly code as a static library (`.a`) and producing a
test executable that links it.

Repository layout
-----------------
- `libasm/` 		    — mandatory NASM `.s` sources.
- `libasm_bonus/` 	— bonus NASM `.s` sources (named `*_bonus.s`).
- `utils/` 		      — small GAS assembly wrappers (`.S`) used to call libc
                      functions (malloc/free/errno) in a PIE-friendly way. These are compiled
                      with `gcc` and linked only into the `test` executable — they are not
                      archived into `libasm.a`.
- `src/` 		        — test harness (`main.c`) and any other test-specific sources.
- `includes/` 		  — header files used by tests.
- `obj/` 		        — object files generated during the build.
- `Makefile` 		    — build rules: `all`, `bonus`, `test`, `test_bonus`, `run_mandatory`,
                      `run_bonus`, `clean`, `fclean`, `re`.

Build requirements
------------------
- `nasm` (for `.s` files)
- `gcc` (to assemble `.S` wrappers and link the test executable)
- `make`

Build and test
--------------
Recommended quick commands:

```bash
make            	  # build libasm.a with mandatory functions
make bonus      	  # assemble bonus objects and add them to libasm.a
make test         	# build and link the test executable (mandatory tests)
make test_bonus   	# build and link the test executable with -DINCLUDE_BONUS
make run_mandatory 	# build + run mandatory tests
make run_bonus      # build + run bonus tests
make fclean       	# remove built files and library
```

If you run `make test` or `make test_bonus` the `test` binary will be created
and can be executed (`./test`). `test_bonus` first runs the `bonus` rule so
the bonus objects are included in `libasm.a` before linking.

Wrappers and PIE compatibility (detailed)
-----------------------------------------
Problem:

- Direct calls to libc functions (e.g. `malloc`, `free`, `__errno_location`)
  from NASM `.s` may generate relocations like `R_X86_64_PC32` that are not
  allowed in PIE objects. That causes link-time failures when building PIE
  executables.

Solution used here:

- Minimal helper wrappers are implemented in GAS (`utils/malloc_wrapper.S`,
  `utils/errno_helper.S`) and compiled with `gcc -c`. These wrappers perform a
	direct `call` to `malloc@PLT`/`free@PLT` or `__errno_location@PLT`, producing
	PLT/GOT-friendly relocations that work with PIE.
- The wrappers are tiny and contain no library logic — they only adapt
  	relocation/ABI semantics for safe linking.
- IMPORTANT: wrappers are compiled and linked only into the `test` executable
	(see `Makefile` rules). They are not included inside `libasm.a`. This
	preserves `libasm.a` as a collection of NASM-compiled objects containing
	the implementations required by the subject.

Files implementing wrappers (examples):
- `utils/malloc_wrapper.S` — provides `malloc_wrapper(size_t)` and
  `free_wrapper(void *)` and forwards to `malloc@PLT` / `free@PLT`.
- `utils/errno_helper.S` — provides `set_errno_and_return_minus_one(int)` and
  writes to `__errno_location@PLT`.

This approach is acceptable for the assignment because the required
implementations (ft_* functions) are written in assembly `.s`. The wrappers
are documented and used only to produce a PIE-friendly test executable.

Audit of bonus sources (current repository state)
-------------------------------------------------
I ran a quick audit of the assembled objects. Summary:

- `ft_atoi_base_bonus.s` 		    — pure NASM, no external wrapper dependencies.
- `ft_list_size_bonus.s` 		    — pure NASM.
- `ft_list_sort_bonus.s` 		    — pure NASM (calls comparison function pointer).
- `ft_list_push_front_bonus.s` 	— NASM implementation; calls `malloc_wrapper`.
- `ft_list_remove_if_bonus.s` 	— NASM implementation; calls `free_wrapper`.

Notes:
- The `malloc_wrapper` and `free_wrapper` used by some bonus sources are
  implemented in `utils/malloc_wrapper.S` (assembly), not in C. Therefore there
  is no dependency on C source files in order to build the test executable.
- If you need a stricter requirement that the final binary does not call
  libc at all, you would need either to change the API (callers allocate
  memory) or implement an allocator/free in assembly.

How to prove compliance (for defense or review)
----------------------------------------------
Useful commands to show the structure and symbols during a review:

```bash
ar -t libasm.a								              # show objects inside the static library
nm -u obj/*.o | sort -u						          # list undefined symbols in object files 
											                      #   (look for wrappers or libc calls)
readelf -r obj/ft_list_push_front_bonus.o 	# show relocations (if asked about PIE issues)
readelf -d test | sed -n '1,120p'			      # show dynamic PLT/NEEDED entries in the final executable
nm -C libasm.a | sed -n '1,200p'			      # inspect exported symbols from the library
```

What to show in the defense (short script)
-----------------------------------------
1. `make fclean all` 		  — show `libasm.a` created.
2. `make test` 				    — build test (explain wrappers are compiled with `gcc -c`).
3. `./test` 				      — run tests showing expected outputs.
4. `nm -A libasm.a`			  — list the archive members and their symbols; use this to verify
   							            that the mandatory functions (e.g. `ft_strlen`, `ft_read`) are 
							              defined inside `libasm.a` and that helper wrappers (`src/*.S`) 
							              were not accidentally archived into the static library.
5. `nm -u obj/*.o` 		    — demonstrate which objects have undefined symbols and
   							            show that wrappers are the only adapters to libc when needed.
6. If asked about PIC vs non-PIC in NASM, explain the relocation issue and
   show a small example or convert one function live to PIC-ASM if desired.

Notes and troubleshooting
-------------------------
- If you see linker errors complaining about `R_X86_64_PC32` relocations,
  ensure you are building the wrappers with `gcc -c` (the `Makefile` already
  does this for `src/*.S`). Do not add `-no-pie` — instead provide wrappers
  or rewrite the ASM to use RIP-relative/PLT references.
- If a test fails with a segfault, run it under `gdb` or `valgrind` to locate
  the faulty function; check calling convention and stack alignment.

License
-------
This repository is educational. 