section .data
    SYS_WRITE equ 1
    SYS_EXIT equ 60
    STD_OUT equ 1
    EXIT_CODE equ 0
    NEW_LINE db 0xa
    WRONG_ARGC_MSG db "ERROR: expected two command-line arguments", 0xa
    WRONG_ARGC_MSG_LEN equ $ - WRONG_ARGC_MSG
    OVERFLOW_INPUT_MSG db "ERROR: overflow in input! Choose smaller numbers", 0xa
    OVERFLOW_INPUT_MSG_LEN equ $ - OVERFLOW_INPUT_MSG
    OVERFLOW_ADDITION_MSG db "ERROR: overflow after addition!", 0xa
    OVERFLOW_ADDITION_MSG_LEN equ $ - OVERFLOW_ADDITION_MSG
    WRONG_INPUT_MSG db "ERROR: wrong input!", 0xa
    WRONG_INPUT_MSG_LEN equ $ - WRONG_INPUT_MSG
    ASCII_INT_BASE equ 48
    ASCII_UPPER_LIMIT equ 57
    EXPECTED_ARGUMENT_CNT equ 3

section .text
    global _start

_start:
    pop rcx
    cmp rcx, EXPECTED_ARGUMENT_CNT
    jne argcError

    add rsp, 8
    pop rsi
    call str_to_int
    mov r10, rax
    mov r9, rax
    pop rsi
    call str_to_int
    mov r11, rax

    add r10, r11
    cmp r9, r10
    jg overflow_addition
    cmp r11, r10
    jg overflow_addition

    mov rax, r10
    xor rcx, rcx
    jmp int_to_str

overflow_addition:
    ; max value:
    ; 9223372036854775807
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, OVERFLOW_ADDITION_MSG
    mov rdx, OVERFLOW_ADDITION_MSG_LEN
    syscall
    jmp exit

argcError:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, WRONG_ARGC_MSG
    mov rdx, WRONG_ARGC_MSG_LEN
    syscall
    jmp exit

str_to_int:
    xor rax, rax
    mov rcx, 10
__repeat:
    mov r11, rax
    cmp [rsi], byte 0
    je __return
    mov bl, [rsi]
    cmp bl, ASCII_INT_BASE
    jl wrong_input
    cmp bl, ASCII_UPPER_LIMIT
    jg wrong_input
    sub bl, ASCII_INT_BASE
    mul rcx
    add rax, rbx
    cmp r11, rax
    jg overflow_input
    inc rsi
    jmp __repeat
__return:
    ret

overflow_input:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, OVERFLOW_INPUT_MSG
    mov rdx, OVERFLOW_INPUT_MSG_LEN
    syscall
    jmp exit

wrong_input:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, WRONG_INPUT_MSG
    mov rdx, WRONG_INPUT_MSG_LEN
    syscall
    jmp exit

int_to_str: ; result expected in rax
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
