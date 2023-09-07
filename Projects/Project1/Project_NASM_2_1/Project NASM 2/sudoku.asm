%include './macros.asm'

;Objective: subrutina del profesor.

numTOascii:
        xor rcx,rcx                                             ; Limpia registro ecx
        xor rdx,rdx                                             ; Limpia registro edx

divida:
        inc ecx
        mov edx, 0
        mov esi, 10
        idiv esi
        add edx, '0'
        push rdx
        cmp eax, 0
        jnz divida

        xor esi, esi
retornaNumero:
        pop rax
        mov [numeroASCII+esi],eax
        inc esi
        loop retornaNumero
        ret


;=============================================================================================	
section .data
	marcador db 'Seccion comprobada',10,13
	marcadorLen equ $-marcador
	; Game Start.
	hello db '			Bienvenido a Sudoku', 10,10
	      db '			     Elije una opcion: ',10
	      db '			     1. Iniciar Juego', 10
	      db '			     2. Salir', 10
	helloLen equ $-hello
	
	; Begin
	instruction 	db 	'Para jugar ingresa 3 números separados,', 10
			db	'los primeros 2 representan la posición y', 10
			db	'el último representa el número que deseas ', 10
			db	'ingresar entre 1 y 9.',10
			db	'Si deseas borrar un número colocado por ti debes', 10
			db	'colocar un 0 en la entrada.',10, 10, 10
	instructionLen equ $-instruction
	; Asking input.
	asking db 'Coordenadas: fila, columna, numero', 10,13
	askingLen equ $-asking
	notValid1 db 'Esa posición no se encuentra disponible.', 10,13
	notValid1Len equ $-notValid1
	thisIsNotValid db 'Entrada ingresada no reconocida', 10,13
	thisIsNotValidLen equ $-thisIsNotValid
	notValid2 db 'El número que quiere colocar ya esta en uso.', 10,13
	notValid2Len equ $-notValid2
	
	; Game win.
	win db 'Haz ganado en '
	winLen equ $-win
	win2 db 'segundos!', 10,13
	win2Len equ $-win2
	loose db 'Tu tiempo se acabo!', 10,13
	looseLen equ $-loose
	incompleto db 'El tablero aun no esta lleno', 10,13
	incompletoLen equ $-incompleto
	
	; Simbols part.
	open db '['
	openLen equ $-open
	close db ']'
	closeLen equ $-close
	separate db '|'
	separateLen equ $-separate
	sim1 db '0  '
	sim2 db '1  '
	sim3 db '2  '
	sim123 db '    0   1   2  '
	sim123Len equ $-sim123
	equals db '  ============', 10,13
	equalsLen equ $-equals
	entering db ' ', 10,13
	enteringLen equ $-entering
	timeStr db 'Tiempo Restante: '
	timeStrLen equ $-timeStr
	mensajeStr db 'Mensaje: '
	mensajeStrLen equ $-mensajeStr

	clear db 27,"[H",27,"[2J"      ; <ESC> [H  <ESC>  [2J
    	clearLen equ $-clear
    
	; Memory of Sudoku.
	string db '012345678',0
	stringLen equ $-string
	string0 db '492357816',0
	string1 db '294753618',0
	string2 db '618753294',0
	validNumbers db '0123456789'
	temp db ' '
	tiempoTotal     dd      120	
	numeroASCII	db 	"0000",0

	
;=============================================================================================	
section .bss
	intrance resb 4
	intranceLen resb 1
	tiempo1 resd 1
	tiempo2 resd 1
;=============================================================================================
section .text
	global _start
	
_start:

;Objective: prints the main menu.
salutation:
	print hello, helloLen
	input
	cmp byte[intrance], '1'

	je setter

	cmp byte[intrance], '2'
	je endGame
	print thisIsNotValid, thisIsNotValidLen
	jmp salutation

	
;Objective: select a prefab board. 
setter:
	mov ecx, string
	random 00000010b
	xor ebx, ebx
	mov ebx, string0
	cmp byte[temp], '2'
	jne set
	random 00000010b
	mov ebx, string1
	cmp byte[temp], '2'
	je set
	mov ebx, string2
	jmp set

;Objective: put a prefab in the table 
set:
	mov al, byte[ebx]
	mov byte[ecx], al
	inc ecx
	inc ebx
	cmp byte[ecx], 0
	jne set
	print clear, clearLen
	print instruction, instructionLen
	mov ecx, string
	jmp setEmptys


;Objective: reemplace some spaces in the sudoku prefab.	
setEmptys:
	inc ecx
	cmp byte[ecx], 0
	je init
	random 00000011b
	mov al, byte[temp]
	sub al, '0'
	cmp al, 0
	jne clearLoop
	jmp setEmptys

;Objective: clearlooping
clearLoop:
	cmp byte[ecx], 0
	je init
	mov byte[ecx], '0'
	dec al
	inc ecx
	cmp al, 0
	je setEmptys

	jmp clearLoop

;Objective: get the initial time: by profe.
init:
	xor rcx,rcx						; Limpia registro ecx
	xor rdx,rdx						; Limpia registro edx
	xor rax,rax						; Limpia registro eax

	mov  eax, 13       					;Interrupcion que toma el primer tiempo EPOCH 
	xor rbx,rbx
	int  0x80

	mov dword [tiempo1],eax					;Almacena la cantidad de segundos desde el primer tiempo EPOCH en variable tiempo1
	
;Objective: print the board
printBoard:
	;------------
	mov  eax, 13						;Interrupcion que toma el segundo tiempo EPOCH
	xor rbx,rbx
        int  0x80


	mov dword [tiempo2],eax					;Almacena la cantidad de segundos desde el segundo tiempo EPOCH en variable tiempo2

        xor rcx,rcx                                             ; Limpia registro ecx
        xor rdx,rdx                                             ; Limpia registro edx
        xor rax,rax                                             ; Limpia registro eax

	mov ebx, dword [tiempo1]				; Se asigna ebx=tiempo1	
	mov eax, dword [tiempo2]				; Se asigna eax=tiempo2
	mov edx, dword [tiempoTotal]				; edx=120 (cantidad de 120s)
	sub eax, ebx						; Obtiene el delta en segundos (tiempo2-tiempo1)
	sub edx,eax
	mov eax,edx						; en EAX esta el tiempo 120 - (tiempo2-tiempo1)
	cmp eax, 121
	jge lostByTime
	cmp eax, 0
	je lostByTime
        call numTOascii
        ;-------------
        
	print timeStr, timeStrLen
	print numeroASCII, 4
	print entering, enteringLen
	printTable
	jmp readIntrance
   

    
;Objective: read the input (X/Y X,Y etc).
readIntrance:
	print asking, askingLen
	input
	
	cmp byte[intrance], 27
	je scape
	
	xor eax, eax
	xor ebx, ebx
	xor ecx, ecx
	xor edx, edx
	
	mov edx, intrance
	mov al, byte[edx] ; line
	inc edx
	inc edx
	mov bl, byte[edx] ; column

	sub eax, '0'
	sub ebx, '0'
	
	mov ecx, 3
	mul ecx
	add eax, ebx

	jmp validate
 
    
;Objective: Compare to clean the position or try to put a number in it.
validate:
	mov edx, string
	add edx, eax
	
	xor ebx, ebx
	mov ebx, intrance
	inc ebx
	inc ebx
	inc ebx
	inc ebx	
	cmp byte[ebx], '0'
	mov al, byte[ebx]
	je reemplaceNumber
	
	cmp byte[edx], '0'
	jne invalid
	
	xor eax, eax
	mov al, byte[ebx]
	jmp checkNumber1
    
    
;Objective: trows invalid for ocupied position.
invalid:
	print clear, clearLen
	print mensajeStr, mensajeStrLen
	print notValid1, notValid1Len
	jmp printBoard
    
;Objective: asegurates that the input is actually a number
checkNumber1:
	mov ebx, validNumbers
	
	CN1LOOP:
	cmp byte[ebx], al
	je checkNumber2
	cmp byte[ebx], 0
	je invalidCheck1
	inc ebx
	jmp CN1LOOP


;Objective: search if the new number is not used again.
checkNumber2:
	mov ebx, string
	
	CN2LOOP:
	cmp byte[ebx], al
	je invalidCheck2
	cmp byte[ebx], 0
	je reemplaceNumber
	inc ebx
	jmp CN2LOOP


;Objective: prints the error of input.
invalidCheck1:
	print clear, clearLen
	print mensajeStr, mensajeStrLen
	print thisIsNotValid, thisIsNotValidLen
	jmp printBoard
	
;Objective: prints the error of duplication.
invalidCheck2:
	print clear, clearLen
	print mensajeStr, mensajeStrLen
	print notValid2, notValid2Len
	jmp printBoard

;Objective: replace the number in the pos with the 3th number
reemplaceNumber:
	mov byte[edx], al
	jmp conv012
    
;Objective: validates all the convinations for victory.
	
	conv012:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		mov al, byte[edx] ; pos 0
		sub al, '0'

		inc edx
		mov bl, byte[edx] ; pos 1
		sub bl, '0'

		inc edx
		mov cl, byte[edx] ; pos 2
    		sub cl, '0'
    
    		add al, bl
    		add al, cl
    		cmp al, 15
    		jne refresh
    
    	conv048:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		mov al, byte[edx] ; pos 0
		sub al, '0'
		
		add edx, 4
		mov bl, byte[edx] ; pos 4
		sub bl, '0'
		
		add edx, 4
		mov cl, byte[edx] ; pos 8
		sub cl, '0'
    		
    		add al, bl
    		add al, cl
    		cmp al, 15
    		jne refresh
    		
    	conv036:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		mov al, byte[edx] ; pos 0
		sub al, '0'
		
		add edx, 3
		mov bl, byte[edx] ; pos 3
		sub bl, '0'
		
		add edx, 3
		mov cl, byte[edx] ; pos 6
		sub cl, '0'
		
    		add al, bl
    		add al, cl
    		cmp al, 15
    		jne refresh
   
	conv147:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		inc edx
		mov al, byte[edx] ; pos 1
		sub al, '0'
		
		add edx, 3
		mov bl, byte[edx] ; pos 4
		sub bl, '0'
		
		add edx, 3
		mov cl, byte[edx] ; pos 7   
		sub cl, '0'

    		add al, bl
    		add al, cl
    		cmp al, 15
    		jne refresh
    		
    	conv258:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		add edx, 2
		mov al, byte[edx] ; pos 2
		sub al, '0'
		
		add edx, 3
		mov bl, byte[edx] ; pos 5
		sub bl, '0'
		
		add edx, 3
		mov cl, byte[edx] ; pos 8
    		sub cl, '0'
    		
    		add al, bl
    		add al, cl
    		cmp al, 15
    		jne refresh
    		
	conv246:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		add edx, 2
		mov al, byte[edx] ; pos 2
		sub al, '0'
		
		add edx, 2
		mov bl, byte[edx] ; pos 4
		sub bl, '0'
		
		add edx, 2
		mov cl, byte[edx] ; pos 6    		
    		sub cl, '0'
    		
   		add al, bl
    		add al, cl
    		cmp al, 15
    		jne refresh
    		
    	conv345:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		add edx, 3
		mov al, byte[edx] ; pos 3
		sub al, '0'
		
		inc edx
		mov bl, byte[edx] ; pos 4
		sub bl, '0'
		
		inc edx
		mov cl, byte[edx] ; pos 5
    		sub cl, '0'
    		
   		add al, bl
    		add al, cl
    		cmp al, 15
    		jne refresh
    		
    	conv678:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		add edx, 6
		mov al, byte[edx] ; pos 6
		sub al, '0'
		
		inc edx
		mov bl, byte[edx] ; pos 7
		sub bl, '0'
		
		inc edx
		mov cl, byte[edx] ; pos 8
    		sub cl, '0'
    		
   		add al, bl
    		add al, cl
    		cmp al, 15
    		je victory
    		
;Objective: clear the screen.    		
refresh:
	print clear, clearLen
	print mensajeStr, mensajeStrLen
	print incompleto, incompletoLen
	jmp printBoard
	
;Objective: print the win
victory:
	print clear, clearLen
	printTable
	print win, winLen
	print numeroASCII, 4
	print win2, win2Len
	jmp _start

lostByTime:
        call numTOascii
        print clear, clearLen
        print loose, looseLen
scape:
	jmp _start
	
	;Objective: Ends the game
endGame:
 finish

