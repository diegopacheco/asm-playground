section .bss
    result_str resb 12        ; buffer for up to 10-digit number + null

section .text
    global _start

_start:
    mov eax, 5
    call factorial            ; EAX = factorial(5)

    ; === Convert EAX to ASCII ===
    mov ecx, eax              ; copy result to ECX for conversion
    mov edi, result_str + 11
    mov byte [edi], 0         ; null terminator

.convert:
    xor edx, edx
    mov eax, ecx
    mov ebx, 10
    div ebx                   ; EAX = ECX / 10, EDX = ECX % 10
    add dl, '0'
    dec edi
    mov [edi], dl
    mov ecx, eax              ; continue with quotient
    test eax, eax
    jnz .convert

    ; === Print the result ===
    mov eax, 4                ; syscall: write
    mov ebx, 1                ; stdout
    mov ecx, edi              ; pointer to ASCII result
    mov edx, result_str + 11
    sub edx, ecx              ; calculate length
    int 0x80

    ; newline
    mov eax, 4
    mov ebx, 1
    mov ecx, nl
    mov edx, 1
    int 0x80

    ; exit
    mov eax, 1
    xor ebx, ebx
    int 0x80

; === factorial(n: eax) => result in eax ===
factorial:
    cmp eax, 1
    jbe .done
    mov ecx, eax
    dec ecx
.loop:
    mul ecx
    dec ecx
    cmp ecx, 1
    jge .loop
.done:
    ret

section .data
    nl db 0xA