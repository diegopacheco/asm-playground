section .data
    msg db "Hello, World!", 0xA ; message with newline
    len equ $ - msg             ; length of message

section .text
    global _start

_start:
    ; write(int fd, const void *buf, size_t count)
    mov eax, 4      ; syscall number for sys_write
    mov ebx, 1      ; file descriptor 1 = stdout
    mov ecx, msg    ; pointer to message
    mov edx, len    ; length of message
    int 0x80        ; call kernel

    ; exit(int status)
    mov eax, 1      ; syscall number for sys_exit
    xor ebx, ebx    ; return code 0
    int 0x80        ; call kernel