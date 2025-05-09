section .data
    SYS_WRITE equ 1
    SYS_EXIT equ 60
    STD_OUT equ 1
    EXIT_CODE equ 0
    NEW_LINE db 0xa
    ASCII_INT_BASE equ 48

section .text
global _start
_start:
    mov edi, 63728127
    xor rcx, rcx
    movsx rdx, edi
    cmp rdx, 0
    jle invalid_input
    jmp iteration

iteration:
    cmp rdx, 1
    je int_to_str_pre
    inc rcx
    test rdx, 1
    jz even
    jmp odd
even:
    shr rdx, 1
    jmp iteration
odd:
    mov rax, rdx
    mov rdx, 0x3
    mul rdx
    inc rax
    mov rdx, rax
    jmp iteration

invalid_input:
    mov rcx, -1
    jmp exit

int_to_str_pre:
    mov rax, rcx
    xor rcx, rcx
int_to_str:
    mov rdx, 0
    mov rbx, 10
    div rbx
    add rdx, ASCII_INT_BASE
    push rdx
    inc rcx
    cmp rax, 0x0
    jne int_to_str
    jmp print_result

print_result:
    mov rax, rcx
    mov rcx, 8
    mul rcx
    mov rdx, rax
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, rsp
    syscall

    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, NEW_LINE
    mov rdx, 1
    syscall

exit:
    mov rax, SYS_EXIT
    mov rdi, EXIT_CODE
    syscall


%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
