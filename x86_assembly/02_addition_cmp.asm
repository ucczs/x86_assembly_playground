section .data
    num1 dq 0x64
    num2 dq 0x32
    msg db "The sum is correct!", 10

section .text
    global _start

_start:
    mov rax, [num1]
    add rax, [num2]
    cmp rax, 0x96
    jne .exit
    jmp .print_success

.print_success:
    mov rax, 1
    mov rdi, 1
    mov rsi, msg
    mov rdx, 20
    syscall
    jmp .exit

.exit:
    mov rax, 60
    mov rdi, 0
    syscall