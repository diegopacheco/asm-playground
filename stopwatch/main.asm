%define SYS_read   3
%define SYS_write  4
%define SYS_time   13
%define SYS_exit   1

section .data
    msg_start  db "Press ENTER to start stopwatch", 10
    len_start  equ $ - msg_start

    msg_stop   db "Press ENTER to stop stopwatch", 10
    len_stop   equ $ - msg_stop

    msg_result db "Elapsed time: "
    len_result equ $ - msg_result

    newline    db 10

section .bss
    input      resb 4
    start_time resd 1
    end_time   resd 1
    result     resb 16

section .text
    global _start

_start:
    ; print prompt
    mov eax, SYS_write
    mov ebx, 1
    mov ecx, msg_start
    mov edx, len_start
    int 0x80

    ; wait ENTER
    mov eax, SYS_read
    mov ebx, 0
    mov ecx, input
    mov edx, 4
    int 0x80

    ; time()
    xor ebx, ebx
    mov eax, SYS_time
    int 0x80
    mov [start_time], eax

    ; print prompt
    mov eax, SYS_write
    mov ebx, 1
    mov ecx, msg_stop
    mov edx, len_stop
    int 0x80

    ; wait ENTER
    mov eax, SYS_read
    mov ebx, 0
    mov ecx, input
    mov edx, 4
    int 0x80

    ; time()
    xor ebx, ebx
    mov eax, SYS_time
    int 0x80
    mov [end_time], eax

    ; delta = end - start
    mov eax, [end_time]
    sub eax, [start_time]

    ; convert to string
    mov ecx, result + 15
    mov byte [ecx], 0
.convert:
    xor edx, edx
    mov ebx, 10
    div ebx
    add dl, '0'
    dec ecx
    mov [ecx], dl
    test eax, eax
    jnz .convert

    ; save string pointer
    push ecx

    ; print "Elapsed time: "
    mov eax, SYS_write
    mov ebx, 1
    mov edx, len_result
    mov ecx, msg_result
    int 0x80

    ; restore string pointer
    pop ecx

    ; print number
    mov eax, SYS_write
    mov ebx, 1
    mov edx, result + 15
    sub edx, ecx       ; calculate length
    int 0x80

    ; newline
    mov eax, SYS_write
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; exit
    mov eax, SYS_exit
    xor ebx, ebx
    int 0x80