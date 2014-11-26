;File Name: SAMPLE.ASM
;Author   : Sivarama Page 179
;Student  : Samantha Arburola
;Date     : oct.26.2014
;Description:
;An example assembly language programs
;---> Login
;
;Library to simple command lines inputs and outpus
%include "io.mac"

.DATA
name_msg     db 'Please enter your name: ', 0
query_msg    db 'How many times to repeat welcome message? ', 0
confirm_msg1 db 'Repeat welcome message ', 0
confirm_msg2 db ' times? (Y/N) ', 0
welcome_msg  db 'Welcome to Assembly Language Programming ',0

.UDATA
user_name resb 16 				;saves user name
response  resb 1				;save time response

.CODE
	.STARTUP						;zip start using io.mac
	PutStr name_msg				;prompt user for name
	GetStr user_name, 16		;read name (max. 15 characters)
ask_count:						;code tag 
	PutStr query_msg			;times msg to repeat welcome
	GetInt CX					;read repeat count
	PutStr confirm_msg1			;confirm repeat count
	PutInt CX					; by display value save before in CX
	PutStr confirm_msg2			;ending confirm msg
	GetCh  [response]			;read user response
	cmp	   byte [response], 'y' ;if 'y', display welcome
	jne    ask_count			;otherwise, request repeat count 
display_msg:					;code tag
	PutStr welcome_msg			;display welcome message
	PutStr user_name			;display user name
	nwln						;equal to \n
	loop display_msg			;feed counters loop with CX
	
.EXIT
