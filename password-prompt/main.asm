%define SYS_read   3
%define SYS_write  4
%define SYS_exit   1

section .data
    prompt      db "Enter password: ", 0
    prompt_len  equ $ - prompt

    correct     db "secret", 10      
    correct_len equ $ - correct

    granted     db "Access granted", 10
    granted_len equ $ - granted

    denied      db "Access denied", 10
    denied_len  equ $ - denied

section .bss
    input       resb 32              ; user input buffer

section .text
    global _start

_start:
    ; write(1, prompt, prompt_len)
    mov eax, SYS_write
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; read(0, input, 32)
    mov eax, SYS_read
    mov ebx, 0
    mov ecx, input
    mov edx, 32
    int 0x80
    mov esi, eax             ; store number of bytes read

    ; compare input to "secret\n"
    mov ecx, correct_len
    mov esi, input
    mov edi, correct
    repe cmpsb
    jne .denied

.granted:
    mov eax, SYS_write
    mov ebx, 1
    mov ecx, granted
    mov edx, granted_len
    int 0x80
    jmp .exit

.denied:
    mov eax, SYS_write
    mov ebx, 1
    mov ecx, denied
    mov edx, denied_len
    int 0x80

.exit:
    mov eax, SYS_exit
    xor ebx, ebx
    int 0x80