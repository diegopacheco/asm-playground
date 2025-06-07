section .bss
    input resb 128            ; input buffer
    length resb 1             ; to store actual input length

section .data
    prompt db "Enter a string: ", 0
    prompt_len equ $ - prompt
    newline db 0xA

section .text
    global _start

_start:
    ; --- print prompt ---
    mov eax, 4
    mov ebx, 1
    mov ecx, prompt
    mov edx, prompt_len
    int 0x80

    ; --- read input ---
    mov eax, 3
    mov ebx, 0
    mov ecx, input
    mov edx, 127
    int 0x80
    ; eax = number of bytes read (including newline)
    mov [length], al

    ; remove newline (replace with null)
    movzx ecx, byte [length]
    dec ecx
    mov byte [input + ecx], 0

    ; --- reverse in-place ---
    mov esi, input            ; start ptr
    mov edi, input
    add edi, ecx
    dec edi                   ; end ptr

.reverse_loop:
    cmp esi, edi
    jge .done_reverse
    mov al, [esi]
    mov bl, [edi]
    mov [esi], bl
    mov [edi], al
    inc esi
    dec edi
    jmp .reverse_loop

.done_reverse:
    ; --- print reversed string ---
    mov eax, 4
    mov ebx, 1
    mov ecx, input
    movzx edx, byte [length]
    dec edx                   ; do not print original newline
    int 0x80

    ; print newline
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; --- exit ---
    mov eax, 1
    xor ebx, ebx
    int 0x80