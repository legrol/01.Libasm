.intel_syntax noprefix  							# Use Intel syntax without '%' prefixes for registers
# ****************************************************************************
# errno_helper.S  # File: tiny helper to set errno and return -1
#
# Tiny Intel-syntax GAS helper that stores errno and returns -1.
# Purpose: called from assembly implementations on syscall failure.
# It calls __errno_location@PLT, stores the 32-bit errno value passed in
# edi into the returned location, and returns -1 in eax.
# This helper is assembled/linked only into the test binary.
# ****************************************************************************

.text  												# Start of the text (code) section
.globl set_errno_and_return_minus_one 				# Export symbol for linker
.type set_errno_and_return_minus_one, @function  	# Mark symbol as function

set_errno_and_return_minus_one:  					# Function label: set_errno_and_return_minus_one
    push rbp  										# Save base pointer (function prologue)
    mov rbp, rsp  									# Set base pointer to current stack pointer
    call __errno_location@PLT  						# Call libc to get address of errno (via PLT)
    mov dword ptr [rax], edi  						# Store 32-bit errno value (edi) into *rax
    mov eax, -1  									# Set return value to -1 in eax
    pop rbp  										# Restore base pointer (function epilogue)
    ret  											# Return to caller

# ****************************************************************************
# Stack execution protection
# ****************************************************************************
# Mark stack as non-executable to silence linker warnings about
# missing .note.GNU-stack section.
# ****************************************************************************
.section .note.GNU-stack,"",@progbits  				# Mark stack as non-executable for linker
