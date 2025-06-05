section .data
    result db 0, 10     ; space for digit + newline

section .text
    global _start

_start:
    mov eax, 10     ; eax = 10
    mov ebx, 3      ; ebx = 3
    sub eax, ebx    ; eax = 7

    ; Convert number to ASCII and store in memory
    add eax, '0'    ; convert to ASCII (7 + 48 = 55 = '7')
    mov [result], al ; store the ASCII character

    ; Print the result
    mov eax, 4      ; syscall number for sys_write
    mov ebx, 1      ; file descriptor 1 (stdout)
    mov ecx, result ; pointer to the string
    mov edx, 2      ; length (digit + newline)
    int 0x80        ; call kernel
    
    ; Exit
    mov eax, 1      ; syscall number for sys_exit
    xor ebx, ebx    ; exit code 0
    int 0x80        ; call kernel