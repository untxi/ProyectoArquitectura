;:::::::::::::::::::::::::::::::::::
;:: File   proyecto.asm           ::
;:: Author Samantha Arburola León ::
;:: Date   26.nov.2014            ::
;:::::::::::::::::::::::::::::::::::


;Librería para simplificar inputs y outpus
; Para compilar con la librería
;nasm -f elf fileName.asm
;ld -s -o fileName fileName.o io.o
%include "io.mac"

;Manejo de Archivos en ASM
;Para crear archivo: 3ch
;Para abrir un archivo:  3dh
;Para escribir sobre un archivo: 40h
;Para cerrar un archivo: 3eh
;Eliminar un archivo: 41h
;Todas las instrucciones llevan la interrupción int 21h

.DATA
bienvenida00  	db " ::::\           :|   ++              ::::\   ::::::\  ::\ ::|",0  
bienvenida01  	db "::|,::|:::| .::/ :::| :| :\:| ,::\   ::|,::|  ::| ::|  ::::::|",0 
bienvenida02  	db "::| ::|:|   `::\ :|:| :|  :/  `::/   ::| ::|  ::::::/  ::| \:|",0
intro         	db "Vamos a crear un archivo con secuencias de ADN",0
digitaNombreArchivo db "Digite el nombre del archivo (sólo 8 caracteres) finalizando con <<.adn>>: ",0
digitaCantidadBases db "Digite la cantidad de Bases de ADN que desea generar (de 0 a 9999): ", 0
confirmar 	  	db "Desea escribir <<", 0
confirmarCantidad 	db ">> bases de ADN? (S/N)  ", 0
confirmarNombre 	db ">> como nombre para el archivo? (S/N)  ",0
;extensionArchivo	db ".adn",0
ubicaArchivo  	db "El archivo se guardará en la carpeta de...",0
resultadoBien 	db "El archivo se ha creado y guardado", 0
resultadoMal  	db "Ha ocurrido un error en el proceso, vuelva a crear el archivo",0
;paraArchivo		db 300 dup(?)
baseA			db "A", 0
msjBases		db "Asignando Bases...",0
;Contantes para generar el numero random
randConst   dd 0x00000003     ;ANSI C: Addition constant:   =          3
randMult    dd 0x00004E6D     ;ANSI C: Multiplicator
randShift   dd 0x00000000     ;ANSI C: No shift necessary
randMask    dd 0x7FFFFFFF     ;ANSI C: Take bits 0..30
randValue   dd 0x3C6EF35F     ;Initial value & result container

.UDATA
nombreArchivo 	RESB    12 ;nombre00.adn
;nombreGuardar   RESB 12
respuesta 		RESB     1 ; s/n
tiraArchivo		RESB 40000 ; Cantidad de Bases Máximas(9999) * cantidad de simbolos Base(4) = 39 996

randAnswer		RESB 16

.CODE
	.STARTUP
; Concatenar a la tira una letra a la vez, la cual es parte de la base "A", "C", "T" ó "G"	
;los va pasando de uno en uno en un loop con  mov e indexado con variable[di]
plusA:
	;mov 	ax, 'A'
	push eax
	mov 	eax, baseA[0]
	mov 	tiraArchivo, eax
	;aaa		;Ajust ASCII
	pop eax
	ret

plusC:
	mov BX, 'C'
	mov [tiraArchivo], BX
	aaa		;Ajust ASCII
	ret

plusT:
	mov BX, 'T'
	mov [tiraArchivo], BX
	aaa		;Ajust ASCII
	ret

plusG:
	mov BX, 'G'
	mov [tiraArchivo], BX
	aaa		;Ajust ASCII
	ret

; ::::::::::::: Inicio del Programa :::::::::::::
inicio:
	PutStr 	bienvenida00 ; Presentación de Programa
	nwln
	PutStr 	bienvenida01
	nwln
	PutStr 	bienvenida02
	nwln
	nwln
	PutStr 	intro
; ::::::::::: Solicitudes al usuario :::::::::::
cuantasBases:
	nwln
	PutStr 	digitaCantidadBases ; Cantidad de bases
	GetInt 	CX
	PutStr 	confirmar
	PutInt 	CX
	PutStr 	confirmarCantidad
	GetCh 	[respuesta]
	cmp		byte [respuesta], 's' 
	jne 	cuantasBases
	
cualNombre:
	nwln
	PutStr 	digitaNombreArchivo
	GetStr 	nombreArchivo, 8
	PutStr 	confirmar
	PutStr 	nombreArchivo
	PutStr 	confirmarNombre
	GetCh 	[respuesta]
	cmp 	byte [respuesta], 's'
	jne		cualNombre

	PutStr  msjBases
	nwln

; ::::::::::::: Crea la Tira para el archivo :::::::::::::
asignaBase:
	call 	random ; llama un número aleatorio
	call 	modulo ; le saca módulo
	; lo compara para asignar una letra a la tira
	cmp     EAX, 0 
	cmp     EAX, 5
	cmp		EAX, 9
	je      plusA
	cmp     EAX, 1
	cmp     EAX, 6
	je      plusC
	cmp     EAX, 2
	cmp     EAX, 7
	je      plusT
	cmp     EAX, 3
	cmp     EAX, 8
	je      plusG
	; repite la cantidad de bases ingresadas por el usuario
	loop asignaBase
	
;La int 21h, sirve para "mostrar cosas por pantalla". 
;Para que funcione, es necesario que en AH este el 
;numero de la funcion a llamar.

; ::::::::::::: Crea el Archivo :::::::::::::
guardaArchivo:
	nwln
	PutStr tiraArchivo
	nwln
	PutStr nombreArchivo
	nwln
	PutStr  guardaArchivo
	mov ah,3ch
	mov cx,0
	mov dx, nombreArchivo;offset
	int 21h
	jc finMal ;si no se pudo crear
	mov bx,ax
	mov ah,3eh ;cierra el archivo
	jmp finBien
	
; ::::::Si se presenta algun error lo reporta y solicita al usuario repetir el procedimiento
finMal:
	nwln
	PutStr resultadoMal
	jmp inicio
; ::::::Si no se presentan errores, finaliza el programa
finBien:
	nwln
	PutStr resultadoBien; Resultado del Programa: Exitóso
	nwln
	.EXIT

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
;Procedimiento para obtener un número random entre 0-4
;  Cada dígito corresponderá a una letra de la base
;    0 -> A
;	 1 -> C
;    2 -> T
;    3 -> G
random:
	push  edx                           ;Save edx register
	mov   eax,  [randValue]             ;Calculate
	mov   edx,  [randMult]              ; R(n+1) :=
	mul   edx                           ; (R(n)*MULT + CONST)
	add   eax,  [randConst]             ; MOD MASK
	and   eax,  [randMask]              ; in CPU register and
	mov   dword [randValue],   eax      ; save back R(n+1)
	;mov	  randAnswer, randValue
	;pop   edx                           ;Restore edx regsiter
	;fild  dword [randValue]             ;Normalize
	;fidiv dword [randMask]              ; to ONE in FPU
	ret                                 ;Return
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::

;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::
; Módulo 10 de un número
;nos quedaría el módulo (resto) en edx y el cociente en eax.	
modulo:
	;mov eax, 23
	cdq
	mov ecx, 5
	idiv ecx
	ret
	;EDX = residuo
