section .data
    filename db "data.txt", 0
    prompt db "Type something: ", 0xA
    promptLen equ $ - prompt
    buffer times 1024 db 0

section .bss
    inputLen resd 1

section .text
    global _start

_start:

    ; write(1, prompt, promptLen)
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, promptLen
    int 0x80

    ; read(0, buffer, 1024)
    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 1024
    int 0x80
    mov [inputLen], eax

    ; open("data.txt", O_WRONLY | O_CREAT | O_TRUNC, 0644)
    mov eax, 5
    mov ebx, filename
    mov ecx, 0x241         ; flags: O_WRONLY | O_CREAT | O_TRUNC
    mov edx, 0644o         ; permissions: rw-r--r--
    int 0x80
    mov esi, eax           ; store file descriptor

    ; write(fd, buffer, inputLen)
    mov eax, 4
    mov ebx, esi
    mov ecx, buffer
    mov edx, [inputLen]
    int 0x80

    ; close(fd)
    mov eax, 6
    mov ebx, esi
    int 0x80

    ; exit(0)
    mov eax, 1
    xor ebx, ebx
    int 0x80