;::::::::::::::::::::::::::::::::::::::::::::
; para ejecutar 32 en 64 en la pirmera en consola
; nasm -f elf32 nombrearchivo.asm
; ld -m elf_i386-o nombrearchivo nombrearchivo.o
;::::::::::::::::::::::::::::::::::::::::::::
;para recorrer
;al byte
;ah byte
buffer db "hola"
xor ecx, ecx	; inicializa en cero
mov eax, buffer ; copia dirección
mov al, buffer[buffer+ecx]; lee cntenido


;para recorrer
;al byte parte baja, sólo se accede a la baja
;ah byte parte alta
buffer db "hola"
xor ecx, ecx	; inicializa en cero
loop: mov eax, buffer ; copia dirección
	mov al, buffer[buffer+ecx]; lee cntenido
	inc ecx
	jmp loop

