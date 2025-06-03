section .data
    x_bigger_msg db "x is bigger", 0xA, 0
    y_bigger_msg db "y is bigger", 0xA, 0

section .text
    global _start

_start:
    ; Define x = 10, y = 20
    mov eax, 10     ; x
    mov ebx, 20     ; y

    ; Compare x and y (eax vs ebx)
    cmp eax, ebx
    jg print_x      ; if x > y, jump to print_x

print_y:
    ; print "y is bigger"
    mov eax, 4
    mov ebx, 1
    mov ecx, y_bigger_msg
    mov edx, 12
    int 0x80
    jmp exit

print_x:
    ; print "x is bigger"
    mov eax, 4
    mov ebx, 1
    mov ecx, x_bigger_msg
    mov edx, 12
    int 0x80

exit:
    mov eax, 1
    xor ebx, ebx
    int 0x80