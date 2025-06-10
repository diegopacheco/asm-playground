%define SYS_open     5
%define SYS_getdents 141
%define SYS_write    4
%define SYS_exit     1
%define SYS_close    6

%define BUF_SIZE     4096

section .data
    dir_path db ".", 0
    newline  db 10

section .bss
    buffer   resb BUF_SIZE

section .text
    global _start

_start:
    ; open(".", O_RDONLY | O_DIRECTORY)
    mov eax, SYS_open
    mov ebx, dir_path
    mov ecx, 0x020000    ; O_DIRECTORY
    int 0x80
    cmp eax, 0
    js .exit
    mov edi, eax         ; save fd

.read_dir:
    ; getdents(fd, buffer, BUF_SIZE)
    mov eax, SYS_getdents
    mov ebx, edi         ; fd
    mov ecx, buffer
    mov edx, BUF_SIZE
    int 0x80
    cmp eax, 0
    jle .close_fd
    mov esi, buffer      ; start of buffer
    mov ebp, eax         ; total bytes read

.parse_loop:
    cmp ebp, 0
    jle .read_dir

    ; each dirent:
    ; struct linux_dirent {
    ;     long  d_ino;
    ;     off_t d_off;
    ;     unsigned short d_reclen;
    ;     char  d_name[];
    ; }

    ; print d_name
    add esi, 10          ; skip ino (4), off (4), reclen (2)
    push esi
    call print_string
    pop esi

    ; move to next record
    sub esi, 10
    movzx eax, word [esi + 8] ; d_reclen is at offset 8
    add esi, eax
    sub ebp, eax
    jmp .parse_loop

.close_fd:
    mov eax, SYS_close
    mov ebx, edi
    int 0x80

.exit:
    mov eax, SYS_exit
    xor ebx, ebx
    int 0x80

; -------------------------------------------------------------
; print_string: prints null-terminated string followed by \n
; input: ESI = address of string
print_string:
    push eax
    push ebx
    push ecx
    push edx

    mov ecx, esi
    mov edx, 0
.next_char:
    cmp byte [ecx + edx], 0
    je .done
    inc edx
    jmp .next_char
.done:
    mov eax, SYS_write
    mov ebx, 1
    mov ecx, esi
    int 0x80

    ; print newline
    mov eax, SYS_write
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    pop edx
    pop ecx
    pop ebx
    pop eax
    ret