section .data
    string_to_reverse db 'Hello, World!', 0
    string_to_reverse_len equ $ - string_to_reverse
    SYS_WRITE equ 1
    SYS_EXIT equ 60
    STD_OUT equ 1
    EXIT_CODE equ 0
    NEW_LINE db 0xa

section .text
global _start
_start:
    mov r9, string_to_reverse
    xor rcx, rcx
push_to_stack:
    xor ax, ax
    mov al, [r9]
    cmp al, 0
    je stack_prepared
    inc rcx
    push ax
    inc r9
    jmp push_to_stack

stack_prepared:
    mov r9, string_to_reverse
pop_from_stack:
    pop ax
    mov [r9], al
    dec rcx
    cmp rcx, 0
    je print_result
    inc r9
    jmp pop_from_stack

print_result:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, string_to_reverse
    mov rdx, string_to_reverse_len
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