# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    malloc_wrapper.S                                   :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/19 12:29:55 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/20 00:51:59 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

.intel_syntax noprefix  							# Use Intel syntax without '%' register prefixes
# ****************************************************************************
# malloc_wrapper.S  # File: minimal wrappers for malloc and free
#
# Minimal Intel-syntax GAS wrapper that forwards to libc's malloc/free via
# the PLT. Implemented in assembly so no C is introduced in the repository.
# This file is assembled/linked into the `test` binary only (not into
# libasm.a).
#
# Signature:
#   void *malloc_wrapper(size_t size)#
#   void  free_wrapper(void *ptr)#
# ****************************************************************************

.text  												# Start of the code section
.globl malloc_wrapper  								# Export malloc_wrapper symbol to linker
.type malloc_wrapper, @function  					# Mark symbol as a function

#**************************************************************************
# Entry ABI for malloc/free wrappers
#
# malloc_wrapper(size):
#   - Caller passes `size` in `rdi` (size_t, 8 bytes).
#   - Caller must ensure `rsp` is 16-byte aligned before `call` (standard ABI).
#   - On return, pointer is in `rax` (NULL on allocation failure).
#   - Caller-saved registers may be clobbered: `rax, rcx, rdx, rsi, rdi, r8-r11`.
#   - Callee does not preserve those registers; `rbx, rbp, r12-r15` are preserved.
#
# free_wrapper(ptr):
#   - Caller passes `ptr` in `rdi` (void*).
#   - Wrapper forwards to `free@PLT` and returns to caller (no return value).
#
# Notes:
#  - These are minimal wrappers that forward to the libc PLT entries. They are
#    assembled and linked into the `test` binary only (not into `libasm.a`).
#  - Callers implemented in NASM should align the stack (e.g., `sub rsp,8`)
#    before calling these helpers if necessary, to keep 16-byte alignment at
#    the point of the `call` instruction.
#**************************************************************************

malloc_wrapper:  									# Label: malloc_wrapper
	call malloc@PLT  								# Tail-call to libc malloc via the PLT (returns pointer in rax)
	ret 											# Return to caller with pointer in rax

.globl free_wrapper 								# Export free_wrapper symbol to linker
.type free_wrapper, @function  						# Mark symbol as a function

free_wrapper:  										# Label: free_wrapper
	call free@PLT  									# Call libc free via the PLT (argument passed in rdi)
	ret  											# Return to caller

# ****************************************************************************
# Stack execution protection
# ****************************************************************************
# Mark stack as non-executable to silence linker warnings about
# missing .note.GNU-stack section.
# ****************************************************************************
.section .note.GNU-stack,"",@progbits 				# Section to mark stack as non-executable
