section .data
    result db 0, 10     ; space for digit + newline

section .text
    global _start

_start:
    mov eax, 10     ; eax = 10
    mov ebx, 2      ; ebx = 2
    xor edx, edx    ; clear edx (high part of dividend)
    div ebx         ; eax = eax / ebx = 10 / 2 = 5

    ; Convert number to ASCII and store in memory
    add eax, '0'    ; convert to ASCII (5 + 48 = 53 = '5')
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