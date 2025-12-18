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
