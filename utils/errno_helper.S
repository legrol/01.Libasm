# **************************************************************************** #
#                                                                              #
#                                                         :::      ::::::::    #
#    errno_helper.S                                     :+:      :+:    :+:    #
#                                                     +:+ +:+         +:+      #
#    By: rdel-olm <rdel-olm@student.42malaga.com>   +#+  +:+       +#+         #
#                                                 +#+#+#+#+#+   +#+            #
#    Created: 2025/12/19 12:29:41 by rdel-olm          #+#    #+#              #
#    Updated: 2025/12/20 00:51:37 by rdel-olm         ###   ########.fr        #
#                                                                              #
# **************************************************************************** #

.intel_syntax noprefix  							# Use Intel syntax without '%' prefixes for registers
# ****************************************************************************
# errno_helper.S  # File: tiny helper to set errno and return -1
#
# Tiny Intel-syntax GAS helper that stores errno and returns -1.
# Purpose: called from assembly implementations on syscall failure.
# It calls __errno_location@PLT, stores the 32-bit errno value passed in
# edi into the returned location, and returns -1 in eax.
# This helper is assembled/linked only into the test binary.
#                                                                             
# C equivalent:                                                              
#       
# int set_errno_and_return_minus_one(int err)
# {
#     *(__errno_location()) = err;
#     return -1;
# }          
# ****************************************************************************

.text  												# Start of the text (code) section
.globl set_errno_and_return_minus_one 				# Export symbol for linker
.type set_errno_and_return_minus_one, @function  	# Mark symbol as function

#*****************************************************************************
# Entry ABI for helper `set_errno_and_return_minus_one`
#
# When called from `ft_write` / `ft_read` on syscall error the caller does:
#   neg rax                ; convert -errno into positive errno
#   mov edi, eax           ; place errno (32-bit) into edi
#   sub rsp, 8             ; ensure 16-byte alignment before `call`
#   call set_errno_and_return_minus_one
#   add rsp, 8             ; restore rsp after call
#
# On entry to the helper:
#    Register    Content / note
#    edi         errno (int, positive)      ; 32-bit errno passed in edi
#    rsp         aligned to 16 bytes        ; caller ensured alignment
#    rax         undefined / not relied on  ; caller-saved volatile
#    rdi,rsi,rdx,rcx,r8,r9,rax,r10,r11 may be clobbered by callee
#    rbx,rbp,r12-r15 preserved by callee (callee-saved)
#
# Variables / actions performed by helper:
#  - err (int)        -> `edi` : errno value to store
#  - errno_ptr (void*)-> returned in `rax` from `__errno_location@PLT`
#  - *errno_ptr = err  -> store dword [rax] = edi
#  - return value     -> `rax` set to -1 (64-bit -1)
#  - helper calls     -> `__errno_location@PLT` (via PLT; needs linking with libc)
#
# Note: The helper expects the caller to align the stack (sub rsp,8) so that
#       the stack is 16-byte aligned at the point of the `call`. The helper
#       itself preserves callee-saved registers and performs a simple
#       store + return sequence.
#*****************************************************************************

set_errno_and_return_minus_one:  					# Function label: set_errno_and_return_minus_one
	push rbp  										# Save base pointer (function prologue)
	mov rbp, rsp  									# Set base pointer to current stack pointer
	call __errno_location@PLT  						# Call libc to get address of errno (via PLT). A pointer to errno (rax = &errno)
		mov dword ptr [rax], edi  					# Store 32-bit errno value (edi) into *rax
		mov rax, -1  								# Set return value to -1 in rax (64-bit -1)
	pop rbp  										# Restore base pointer (function epilogue)
	ret  											# Return to caller

# ****************************************************************************
# Stack execution protection
# ****************************************************************************
# Mark stack as non-executable to silence linker warnings about
# missing .note.GNU-stack section.
# ****************************************************************************
.section .note.GNU-stack,"",@progbits  				# Mark stack as non-executable for linker
