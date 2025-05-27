section .data
    msg db "El resultado de la división es: ", 0
    len equ $ - msg
    remainder_msg db " y el residuo es: ", 0
    remainder_len equ $ - remainder_msg
    newline db 10
    buffer times 11 db 0

section .text
    global _start

_start:
    ; División: 100 / 7 = 14 (residuo 2)
    mov eax, 100
    mov ebx, 7
    xor edx, edx
    div ebx

    ; Guardar resultados
    push edx    ; Residuo
    push eax    ; Cociente

    ; Mostrar mensaje
    mov eax, 4
    mov ebx, 1
    mov ecx, msg
    mov edx, len
    int 0x80

    ; Mostrar cociente
    pop eax
    call print_32bit_number

    ; Mostrar mensaje residuo
    mov eax, 4
    mov ebx, 1
    mov ecx, remainder_msg
    mov edx, remainder_len
    int 0x80

    ; Mostrar residuo
    pop eax
    call print_32bit_number

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

print_32bit_number:
    mov ebx, 10
    mov ecx, buffer+10
    mov byte [ecx], 0
    
convert_loop:
    dec ecx
    xor edx, edx
    div ebx
    add dl, '0'
    mov [ecx], dl
    test eax, eax
    jnz convert_loop

    mov edx, buffer+11
    sub edx, ecx
    mov eax, 4
    mov ebx, 1
    int 0x80
    ret
