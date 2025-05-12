section .data
    msg_yes db "Leap year!", 0xa
    msg_yes_len equ $ - msg_yes
    msg_no db "Regular year, no Leap year", 0xa
    msg_no_len equ $ - msg_no

section .text
global _start
_start:
    mov rdi, 2028
    mov r8, rdi
    mov rax, 0
    test r8, 3
    jnz regular_year
check_div_by_100:
    mov rax, rdi
    mov rcx, 100
    xor rdx, rdx
    div rcx
    cmp rdx, 0  ; rdx contains the remainder
    jne leap_year_found
    test rax, 3
    jz leap_year_found
    xor rax, rax
    jmp regular_year
leap_year_found:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_yes
    mov rdx, msg_yes_len
    syscall
    jmp exit
regular_year:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg_no
    mov rdx, msg_no_len
    syscall
    jmp exit
exit:
    mov rax, 60
    mov rdi, 0
    syscall

%ifidn __OUTPUT_FORMAT__,elf64
section .note.GNU-stack noalloc noexec nowrite progbits
%endif
