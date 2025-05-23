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
    mov rdi, 64
    cmp rdi, 0
    jle invalid_input
    mov rcx, rdi
    mov rax, 1
    mov r8, 2
iterate:
    cmp rcx, 1
    je int_to_str_pre
    dec rcx
    mul r8
    jmp iterate

int_to_str_pre:
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
    jmp exit

invalid_input:
    mov rax, 0
exit:
    mov rax, SYS_EXIT
    mov rdi, EXIT_CODE
    syscall


%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
