section .data
    char db '*'

section .text
    global _start

_start:
    mov ecx, 5

.loop:
    mov eax, 4
    mov ebx, 1
    mov edx, 1
    push ecx          ; Save loop counter
    mov ecx, char     ; Set up for system call
    int 0x80
    pop ecx           ; Restore loop counter
    loop .loop

    mov eax, 1
    xor ebx, ebx
    int 0x80