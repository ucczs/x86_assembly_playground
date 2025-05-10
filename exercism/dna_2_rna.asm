section .data
    input_string db 'ACGTGGTCTTAA', 0
    input_string_len equ $ - input_string
    output_buffer db input_string_len dup(0) ; expected result: UGCACCAGAAUU 
    SYS_WRITE equ 1
    SYS_EXIT equ 60
    STD_OUT equ 1
    EXIT_CODE equ 0
    NEW_LINE db 0xa

section .text
global _start
_start:
    mov r9, input_string
    mov r10, output_buffer
iterate_over_input:
    cmp byte [r9], 0
    je conversion_done
    mov al, [r9]
    cmp al, 'A'
    je dna_a
    cmp al, 'C'
    je dna_c
    cmp al, 'G'
    je dna_g
    cmp al, 'T'
    je dna_t
    jmp error_input

dna_a:
    mov byte [r10], 'U'
    jmp next_iteration
dna_c:
    mov byte [r10], 'G'
    jmp next_iteration
dna_g:
    mov byte [r10], 'C'
    jmp next_iteration
dna_t:
    mov byte [r10], 'A'
    jmp next_iteration

next_iteration:
    inc r9
    inc r10
    jmp iterate_over_input

error_input:
conversion_done:
    mov byte [r10], 0

print_result:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, input_string
    mov rdx, input_string_len
    syscall

    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, NEW_LINE
    mov rdx, 1
    syscall

    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, output_buffer
    mov rdx, input_string_len
    syscall

    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, NEW_LINE
    mov rdx, 1
    syscall
    jmp exit

exit:
    mov rax, SYS_EXIT
    mov rdi, EXIT_CODE
    syscall

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
