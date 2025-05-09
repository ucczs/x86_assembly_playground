section .data
    SYS_WRITE equ 1
    SYS_EXIT equ 60
    STD_OUT equ 1
    EXIT_CODE equ 0
    NEW_LINE db 0xa
    ASCII_INT_BASE equ 48

section .text
global square_of_sum
square_of_sum:
    ; input in rdi
    xor rax, rax
    mov rcx, rdi
sum_iteration:
    add rax, rcx
    dec rcx
    cmp rcx, 0
    je sum_done
    jmp sum_iteration
sum_done:
    mul rax
    ret

global sum_of_squares
sum_of_squares:
    xor rax, rax
    xor r8, r8
    mov rcx, rdi
sum_square_iteration:
    mov rbx, rcx
    mov rax, rcx
    mul rbx
    add r8, rax
    dec rcx
    cmp rcx, 0
    je sum_square_done
    jmp sum_square_iteration
sum_square_done:
    mov rax, r8
    ret

global _start
_start: ; difference_of_squares
    mov rdi, 5
    xor rax, rax
    call sum_of_squares
    mov r8, rax
    call square_of_sum
    sub rax, r8
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