section .data
    buffer db 10 dup(0)  ; space for 10-digit number + null terminator

section .text
    global _start

_start:
    ; original value
    mov eax, 1234       

    ; copy to another register
    mov ebx, eax        

    ; convert number in EBX to ASCII string (stored in buffer)
    mov ecx, buffer + 9  ; point to end of buffer
    mov byte [ecx], 0xA  ; newline
    dec ecx

.convert:
    xor edx, edx
    mov eax, ebx
    mov edi, 10
    div edi             ; eax = ebx / 10, edx = ebx % 10
    add dl, '0'         ; convert digit to ASCII
    mov [ecx], dl
    mov ebx, eax
    dec ecx
    test eax, eax
    jnz .convert

    ; print result
    mov eax, 4          ; syscall: write
    mov ebx, 1          ; stdout
    lea ecx, [ecx+1]    ; point to start of digits
    mov edx, buffer + 10
    sub edx, ecx        ; length = end - start
    int 0x80

    ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80