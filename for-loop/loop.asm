section .data
    newline db 0xA, 0
    buffer db "00", 0  ; max two-digit number + null terminator

section .text
    global _start

_start:
    mov edi, 1          ; counter = 1 (using edi instead of ecx)

print_loop:
    cmp edi, 11         ; while (counter < 11)
    jge exit

    ; convert number to ASCII (supports 1–99)
    mov eax, edi        ; use edi instead of ecx
    mov ebx, 10
    xor edx, edx
    div ebx             ; eax = edi / 10, edx = edi % 10

    ; check if we have a tens digit
    cmp eax, 0
    je single_digit

    ; two-digit number
    add al, '0'         ; tens digit
    mov [buffer], al
    mov al, dl
    add al, '0'         ; units digit
    mov [buffer+1], al
    
    ; write syscall: write(1, buffer, 2)
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 2
    int 0x80
    jmp write_newline

single_digit:
    ; single-digit number
    mov al, dl
    add al, '0'         ; units digit
    mov [buffer], al
    
    ; write syscall: write(1, buffer, 1)
    mov eax, 4
    mov ebx, 1
    mov ecx, buffer
    mov edx, 1
    int 0x80

write_newline:
    ; write newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    inc edi             ; increment edi instead of ecx
    jmp print_loop

exit:
    mov eax, 1          ; sys_exit
    xor ebx, ebx
    int 0x80