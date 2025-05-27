section .data
    msg db "El resultado de la resta es: ", 0
    len equ $ - msg
    newline db 10
    buffer times 6 db 0  ; Buffer para conversión numérica

section .text
    global _start

_start:
    ; Resta: 60 - 20 - 10 = 30 
    mov ax, 60       ; ax = 60 
    sub ax, 20       ; ax = ax - 20 (40)
    sub ax, 10       ; ax = ax - 10 (30)
    
    ; Mostrar mensaje
    mov eax, 4       ; sys_write
    mov ebx, 1       ; stdout
    mov ecx, msg
    mov edx, len
    int 0x80

    ; Convertir resultado a ASCII y mostrar
    call print_16bit_number

    ; Nueva línea
    mov eax, 4
    mov ebx, 1
    mov ecx, newline
    mov edx, 1
    int 0x80

    ; Salir
    mov eax, 1       ; sys_exit
    xor ebx, ebx     ; return 0
    int 0x80

print_16bit_number:
    ; Función para imprimir número de 16 bits en AX
    mov bx, 10       ; Divisor
    mov ecx, buffer+5 ; Puntero al final del buffer
    mov byte [ecx], 0 ; Null terminator

convert_loop:
    dec ecx          ; Movemos el puntero hacia atrás
    xor dx, dx       ; Limpiar DX para división
    div bx           ; Divide AX por 10
    add dl, '0'      ; Convierte resto a ASCII
    mov [ecx], dl    ; Almacena el dígito
    test ax, ax      ; ¿AX == 0?
    jnz convert_loop ; Si no, sigue

    ; Calcular longitud
    mov edx, buffer+6 ; Final del buffer
    sub edx, ecx     ; EDX = longitud

    ; Imprimir número
    mov eax, 4       ; sys_write
    mov ebx, 1       ; stdout
    int 0x80
    ret
