section .bss
    input resb 10        ; space for user input (max 9 digits + newline)
    result resb 12       ; space to store result string

section .data
    prompt db "Enter a number: ", 0
    prompt_len equ $ - prompt
    newline db 0xA

section .text
    global _start

_start:
    ; write(1, prompt, prompt_len)
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; read(0, input, 10)
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 10
    int 0x80

    ; convert ASCII to integer
    xor ecx, ecx        ; ECX = number accumulator
    xor esi, esi        ; ESI = index

.next_digit:
    mov al, [input + esi]
    cmp al, 0xA         ; newline?
    je .convert_done
    sub al, '0'
    imul ecx, ecx, 10
    add ecx, eax
    inc esi
    jmp .next_digit

.convert_done:
    ; multiply the result by 7
    mov eax, ecx
    mov ebx, 7
    imul eax, ebx       ; EAX = result

    ; convert integer result in EAX to ASCII string (in reverse)
    mov esi, result + 11
    mov byte [esi], 0   ; null-terminate string

.print_loop:
    xor edx, edx
    mov ebx, 10
    div ebx             ; EAX /= 10, remainder -> EDX
    add dl, '0'
    dec esi
    mov [esi], dl
    test eax, eax
    jnz .print_loop

    ; write(1, esi, len)
    mov eax, 4
    mov ebx, 1
    mov ecx, esi
    mov edx, result + 11
    sub edx, esi
    int 0x80

    ; write newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80