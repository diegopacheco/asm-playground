section .data
    filename db "data.txt", 0
    buffer   times 1024 db 0

section .bss
    bytesRead resd 1

section .text
    global _start

_start:
    mov eax, 5          ; syscall: sys_open
    mov ebx, filename   ; filename = data.txt
    mov ecx, 0          ; O_RDONLY
    int 0x80
    mov esi, eax        ; file descriptor

.read_loop:
    ; read(fd, buffer, 1024)
    mov eax, 3          ; syscall: sys_read
    mov ebx, esi        ; fd
    mov ecx, buffer     ; buffer
    mov edx, 1024       ; count
    int 0x80

    cmp eax, 0
    jle .close_file     ; if EOF or error, exit loop

    ; write(1, buffer, eax)
    mov [bytesRead], eax
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, [bytesRead]
    int 0x80

    jmp .read_loop

.close_file:
    ; close(fd)
    mov eax, 6
    mov ebx, esi
    int 0x80

    ; exit(0)
    mov eax, 1
    xor ebx, ebx
    int 0x80