section .data
    SYS_WRITE equ 1
    SYS_EXIT equ 60
    STD_OUT equ 1
    EXIT_CODE equ 0
    NEW_LINE_LEN equ 1

    NEW_LINE db 0xa
    INPUT db "hello world reverse please"

section .bss
    OUTPUT resb 1

section .text
    global _start

_start:
    xor rcx, rcx
    mov rsi, INPUT
    mov rdi, OUTPUT
    cld
    call reverseStringAndPrint

reverseStringAndPrint:
    cmp byte [rsi], 0
    je reverseString
    inc rcx
    xor rax, rax
    lodsb
    push rax
    jmp reverseStringAndPrint

reverseString:
    pop rax
    mov [rdi], rax
    cmp rax, 0
    je printString
    inc rdi
    jmp reverseString

printString:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, OUTPUT
    mov rdx, rcx
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
