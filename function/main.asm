section .text
    global _start

_start:
    ; Call double_it(3)
    mov eax, 3        ; argument in eax
    call double_it    ; call the function
    ; result now in eax (3 * 2 = 6)

    ; Print result as ASCII character
    add eax, '0'      ; convert to ASCII (6 + 48 = 54, which is '6')
    mov [esp-1], al   ; store character on stack
    mov edx, 1        ; length
    lea ecx, [esp-1]  ; address of character
    mov ebx, 1        ; stdout
    mov eax, 4        ; write syscall
    int 0x80

    ; Exit
    mov eax, 1        ; exit syscall
    int 0x80

; === Function ===
double_it:
    add eax, eax      ; eax = eax * 2
    ret