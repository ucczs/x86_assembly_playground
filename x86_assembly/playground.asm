section .data
    SYS_WRITE equ 1
    SYS_EXIT equ 60
    STD_OUT equ 1
    EXIT_CODE equ 0
    NEW_LINE db 0xa
    ASCII_INT_BASE equ 48
    OUTPUT_1 db "Output 1", 0xa
    OUTPUT_1_LEN equ $ - OUTPUT_1
    OUTPUT_2 db "Output 2", 0xa
    OUTPUT_2_LEN equ $ - OUTPUT_2
    OUTPUT_3 db "Output 3", 0xa
    OUTPUT_3_LEN equ $ - OUTPUT_3
    OUTPUT_4 db "Output 4", 0xa
    OUTPUT_4_LEN equ $ - OUTPUT_4
    var dd 67305985        ; 4 bytes -> 0x04030201
    var1 db 0   ; 1 byte
    var2 dw 0   ; 2 bytes
    var3 dd 0   ; 4 bytes

section .text
    global _start


_start:
    mov rsi, var

    ; copy only one byte from var to var1 (use 1 byte register al)
    mov rdi, var1
    mov al, [rsi]
    mov [rdi], al

    ; copy two bytes from var to var2 (use 2 bytes register ax)
    mov rdi, var2
    mov ax, [rsi]
    mov [rdi], ax

    ; copy four bytes from var to var3 (use 4 bytes register eax)
    mov rdi, var3
    mov eax, [rsi]
    mov [rdi], eax


compare_1:
    cmp byte [var1], 1          ; 0x01
    je ouput_1
compare_2:
    cmp word [var2], 513        ; 0x0201
    je ouput_2
compare_3:
    cmp long [var3], 67305985   ; 0x04030201
    je ouput_3
    ; mov rax, [var3]
    ; xor rcx, rcx
    ; jmp int_to_str
    jmp exit
compare_4:
    jmp exit

ouput_1:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, OUTPUT_1
    mov rdx, OUTPUT_1_LEN
    syscall
    jmp compare_2

ouput_2:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, OUTPUT_2
    mov rdx, OUTPUT_2_LEN
    syscall
    jmp compare_3

ouput_3:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, OUTPUT_3
    mov rdx, OUTPUT_3_LEN
    syscall
    jmp compare_4

ouput_4:
    mov rax, SYS_WRITE
    mov rdi, STD_OUT
    mov rsi, OUTPUT_4
    mov rdx, OUTPUT_4_LEN
    syscall
    jmp exit

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