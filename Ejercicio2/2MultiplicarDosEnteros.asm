section .data
    msg db "El resultado de la multiplicación es: ", 0
    len equ $ - msg
    newline db 10
    buffer times 6 db 0

section .text
    global _start

_start:
    ; Multiplicación: 12 * 5 = 60
    mov al, 12
    mov bl, 5
    mul bl      ; ax = al * bl

    ; Mostrar mensaje
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    ; Mostrar resultado
    call print_16bit_number

    ; Nueva línea
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Salir
    mov eax, 1
    xor ebx, ebx
    int 0x80

print_16bit_number:
    mov bx, 10
    mov ecx, buffer+5
    mov byte [ecx], 0
    
convert_loop:
    dec ecx
    xor dx, dx
    div bx
    add dl, '0'
    mov [ecx], dl
    test ax, ax
    jnz convert_loop

    mov edx, buffer+6
    sub edx, ecx
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret
