section .data
    prefix db "2 x ", 0
    equals db " = ", 0
    newline db 10, 0

section .bss
    output resb 64
    num_buf resb 16
    result_buf resb 16

section .text
    global _start

_start:
    mov ebx, 1               ; Use EBX as counter instead

.loop:
    cmp ebx, 11
    jge .done

    ; Clear output buffer
    push ebx
    mov edi, output
    xor eax, eax
    mov ecx, 64
    rep stosb
    pop ebx

    ; Copy "2 x "
    mov edi, output
    mov esi, prefix
    call strcpy

    ; Convert and append counter
    mov eax, ebx
    call int_to_ascii
    mov edi, output          ; Reset EDI to start of output
    mov esi, num_buf
    call strcat

    ; Append " = "
    mov edi, output          ; Reset EDI to start of output
    mov esi, equals
    call strcat

    ; Calculate 2 * counter and convert to string
    mov eax, ebx
    mov edx, 2
    imul eax, edx
    call int_to_ascii_result  ; Use different function for result
    mov edi, output          ; Reset EDI to start of output
    mov esi, result_buf
    call strcat

    ; Append newline
    mov edi, output          ; Reset EDI to start of output
    mov esi, newline
    call strcat

    ; Print the line
    mov eax, 4               ; sys_write
    push ebx                 ; Save loop counter
    mov ebx, 1               ; stdout
    mov ecx, output
    call strlen
    mov edx, eax
    mov eax, 4
    int 0x80
    pop ebx                  ; Restore loop counter

    inc ebx
    jmp .loop

.done:
    mov eax, 1
    xor ebx, ebx
    int 0x80

; Convert EAX to string in num_buf
int_to_ascii:
    push ebx
    push ecx
    push edx
    
    mov edi, num_buf + 15
    mov byte [edi], 0
    dec edi
    
    test eax, eax
    jnz .convert
    mov byte [edi], '0'
    jmp .done_convert
    
.convert:
    xor edx, edx
    mov ebx, 10
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .convert
    
.done_convert:
    inc edi
    
    ; Copy result to beginning of num_buf
    mov esi, edi
    mov edi, num_buf
.copy_result:
    lodsb
    stosb
    test al, al
    jnz .copy_result
    
    pop edx
    pop ecx
    pop ebx
    ret

; Convert EAX to string in result_buf
int_to_ascii_result:
    push ebx
    push ecx
    push edx
    
    mov edi, result_buf + 15
    mov byte [edi], 0
    dec edi
    
    test eax, eax
    jnz .convert_result
    mov byte [edi], '0'
    jmp .done_convert_result
    
.convert_result:
    xor edx, edx
    mov ebx, 10
    div ebx
    add dl, '0'
    mov [edi], dl
    dec edi
    test eax, eax
    jnz .convert_result
    
.done_convert_result:
    inc edi
    
    ; Copy result to beginning of result_buf
    mov esi, edi
    mov edi, result_buf
.copy_result_result:
    lodsb
    stosb
    test al, al
    jnz .copy_result_result
    
    pop edx
    pop ecx
    pop ebx
    ret

; Calculate string length
strlen:
    push edi
    mov edi, ecx
    xor eax, eax
.len_loop:
    cmp byte [edi], 0
    je .len_done
    inc edi
    inc eax
    jmp .len_loop
.len_done:
    pop edi
    ret

; Copy string from ESI to EDI
strcpy:
    push eax
.copy_loop:
    lodsb
    stosb
    test al, al
    jnz .copy_loop
    dec edi
    pop eax
    ret

; Concatenate string from ESI to end of string at EDI
strcat:
    push eax
    push edi                 ; Save original EDI
    
    ; Find end of destination
.find_end:
    cmp byte [edi], 0
    je .found_end
    inc edi
    jmp .find_end
    
.found_end:
    call strcpy
    pop edi                  ; Restore original EDI
    pop eax
    ret