# asm-playground

Assembly Playground

### Learning Some Assembly

Assign values to registers
```asm
mov edi, 1
```

Increment register by 1
```asm
inc esi
```

Multiply 2 registers and store on the first one
```asm
imul eax, ebx
```

Compare register value with decimal
```asm
cmp edi, 11
```

Jump to the label if the condition is met
```asm
je single_digit
```

Convert from ASCII to number
```asm
mov al, '7'    ; al = 55
sub al, '0'    ; al = 55 - 48 = 7
```

Push register value onto the stack
```asm
mov ebx, 1234
push ebx       ; stack now holds 1234 at the top
```

Pop value from the stack into a register
```asm
pop ebx        ; ebx now holds 1234, stack top is removed
```

Linux Kernel SysCall 
```asm
mov eax, 4      ; syscall number for sys_write
mov ebx, 1      ; file descriptor (1 = stdout)
mov ecx, msg    ; pointer to message
mov edx, len    ; length of message
int 0x80        ; perform syscall: write(1, msg, len) - trigger interrupt
```