section .data
    input_array dd 1, 7, 13, 42, 57, 69, 70, 81, 98, 110
    input_array_len equ 10
    SYS_WRITE equ 1
    SYS_EXIT equ 60
    STD_OUT equ 1
    EXIT_CODE equ 0
    NEW_LINE db 0xa
    ASCII_INT_BASE equ 48

section .text
global _start
_start:
    mov rdi, input_array
    test rdi, rdi
    jz not_found
    mov rsi, input_array_len
    mov rdx, 57     ; for testing purposes, change this to the number you want to search
    mov r8, rdx     ; number to search
    mov r13, 0      ; result register
iterate:
    mov r14, rdi
    shr rsi, 1
    test rsi, rsi
    jnz compare
    cmp [rdi], r8b
    je found
not_found:
    mov rax, -1
    jmp exit
compare:
    mov rax, rsi
    mov r12, 4
    mul r12
    add rdi, rax
    movzx rax, byte [rdi]
    cmp r8, rax
    je found
    jg right_branch
    jl left_branch
right_branch:
    add rdi, 4
    add r13, rsi
    inc r13
    jmp iterate
left_branch:
    mov rdi, r14
    jmp iterate
found:
    add r13, rsi
    mov rax, r13
    jmp int_to_str_pre

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

exit:
    mov rax, SYS_EXIT
    mov rdi, EXIT_CODE
    syscall


%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
