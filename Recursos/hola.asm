; Hola Mundo
section .data
buffer: db "Hola Mundo", 10
BUFFLEN: equ $ - buffer

section .bss

datos resb 10

section .text

global _start

_start:
	xor ecx,ecx ;vale 0 contador
	mov al,byte[buffer+ecx] ;al tiene H
	mov byte[datos+ecx],al  ;el primer byte de datos ahora tiene H
	;mov ecx,datos ;H esta en datos
	
	;mov byte[datos+1],datos; error de direcionamiento por que 10 no cabe en 1

	mov eax, 4
	mov ebx, 0
	mov ecx,datos
	mov edx,10
	int 80h
	
	mov eax,1
	mov ebx,0
	int 80h
	


