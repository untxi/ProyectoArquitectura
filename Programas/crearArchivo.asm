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
digitaNombreArchivo db "Digite el nombre del archivo (sólo 8 caracteres): ",0
digitaCantidadBases db "Digite la cantidad de Bases de ADN que desea generar (de 0 a 9999): ", 0
confirmar 	  	db "Desea escribir <<", 0
confirmarCantidad 	db ">> bases de ADN? (S/N)  ", 0
confirmarNombre 	db ">> como nombre para el archivo? (S/N)  ",0
ubicaArchivo  	db "El archivo se guardará en la carpeta de...",0
resultadoBien 	db "El archivo se ha creado y guardado", 0
resultadoMal  	db "Ha ocurrido un error en el proceso, vuelva a crear el archivo",0
;Contantes para generar el numero random
randConst   dd 0x00000003     ;ANSI C: Addition constant:   =          3
randMult    dd 0x41C64E6D     ;ANSI C: Multiplicator:       = 1103515245
randShift   dd 0x00000000     ;ANSI C: No shift necessary
randMask    dd 0x7FFFFFFF     ;ANSI C: Take bits 0..30
randValue   dd 0x3C6EF35F     ;Initial value & result container

.UDATA
nombreArchivo 	RESB 8
respuesta 		RESB 1

.CODE
	.STARTUP

	PutStr 	bienvenida00 ; Presentación de Programa
	nwln
	PutStr 	bienvenida01
	nwln
	PutStr 	bienvenida02
	nwln
	nwln
	PutStr 	intro

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

asignaBase:
	call random
	push AX
	XOR  AX,AX
	mov AX, random
	PutInt AX
	
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
	pop   edx                           ;Restore edx regsiter
	fild  dword [randValue]             ;Normalize
	fidiv dword [randMask]              ; to ONE in FPU
	ret                                 ;Return
;.end
;::::::::::::::::::::::::::::::::::::::::::::::::::::::::::