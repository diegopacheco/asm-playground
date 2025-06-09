%define SYS_socketcall 102
%define SYS_exit       1
%define SYS_read       3
%define SYS_write      4
%define SYS_close      6

section .data
    http_response db "HTTP/1.1 200 OK", 13, 10
                  db "Content-Type: text/plain", 13, 10
                  db "Content-Length: 15", 13, 10
                  db "Connection: close", 13, 10
                  db 13, 10
                  db "hello from asm", 10
    http_len equ $ - http_response

section .bss
    sockaddr   resb 16
    read_buf   resb 1024

section .text
    global _start

_start:
    ; socket(AF_INET=2, SOCK_STREAM=1, 0)
    push 0              ; protocol = 0
    push 1              ; type = SOCK_STREAM
    push 2              ; domain = AF_INET
    mov ecx, esp
    mov ebx, 1          ; SYS_SOCKET
    mov eax, SYS_socketcall
    int 0x80
    add esp, 12         ; cleanup
    cmp eax, -1
    je .error
    mov esi, eax        ; server_fd

    ; setsockopt(server_fd, SOL_SOCKET, SO_REUSEADDR, &optval=1, 4)
    push 1
    mov ecx, esp
    push 4
    push ecx
    push 2              ; SO_REUSEADDR
    push 1              ; SOL_SOCKET
    push esi            ; server_fd
    mov ecx, esp
    mov ebx, 14         ; SYS_SETSOCKOPT
    mov eax, SYS_socketcall
    int 0x80
    add esp, 28         ; cleanup
    cmp eax, -1
    je .error

    ; sockaddr_in: AF_INET, port 8080, 0.0.0.0
    mov word [sockaddr], 2            ; AF_INET
    mov word [sockaddr + 2], 0x901F   ; port 8080 (big-endian = 0x1F90)
    mov dword [sockaddr + 4], 0       ; 0.0.0.0
    mov dword [sockaddr + 8], 0
    mov dword [sockaddr + 12], 0

    ; bind(server_fd, sockaddr, 16)
    push 16
    push sockaddr
    push esi
    mov ecx, esp
    mov ebx, 2          ; SYS_BIND
    mov eax, SYS_socketcall
    int 0x80
    add esp, 12
    cmp eax, -1
    je .error

    ; listen(server_fd, 10)
    push 10
    push esi
    mov ecx, esp
    mov ebx, 4          ; SYS_LISTEN
    mov eax, SYS_socketcall
    int 0x80
    add esp, 8
    cmp eax, -1
    je .error

.accept_loop:
    ; accept(server_fd, NULL, NULL)
    push 0
    push 0
    push esi
    mov ecx, esp
    mov ebx, 5          ; SYS_ACCEPT
    mov eax, SYS_socketcall
    int 0x80
    add esp, 12
    cmp eax, -1
    je .accept_loop     ; skip bad accept
    mov edi, eax        ; client_fd

    ; read(client_fd, read_buf, 1024)
    mov eax, SYS_read
    mov ebx, edi
    mov ecx, read_buf
    mov edx, 1024
    int 0x80

    ; write(client_fd, http_response, http_len)
    mov eax, SYS_write
    mov ebx, edi
    mov ecx, http_response
    mov edx, http_len
    int 0x80

    ; close(client_fd)
    mov eax, SYS_close
    mov ebx, edi
    int 0x80

    jmp .accept_loop

.error:
    ; exit(1)
    mov eax, SYS_exit
    mov ebx, 1
    int 0x80