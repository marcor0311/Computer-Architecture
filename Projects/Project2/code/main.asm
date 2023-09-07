%include './macros.asm'

section .data
	marcador db 'Seccion comprobada',10,13
	marcadorLen equ $-marcador
	; Game Start.
	hello db '			Bienvenido al juego del Gato', 10,10
	      db '			     Elije una opcion: ',10
	      db '			     1. Iniciar Juego', 10
	      db '			     2. Salir', 10
	helloLen equ $-hello
	
		
	; Rounds.
	turn db 'El turno es de '
	turnLen equ $-turn
	
	letterO db 'O'
	letterOLen equ $-letterO
	
	letterX db 'X'
	letterXLen equ $-letterX
	
	
	; Asking input.
	asking db 'Ingrese una posicion.', 10,13
	askingLen equ $-asking
	example db 'El formato puede ser "X,Y","X Y","X/Y", etc.', 10,13
	notValid db 'Esa no es una posicion valida', 10,13
	notValidLen equ $-notValid
	
	
	; Game win
	win db 'El ganador es '
	winLen equ $-win
	tie db 'Ambos jugadores quedaron en empate.', 10,13
	tieLen equ $-tie
	
		
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
	thisIsNotValid db 'Entrada ingresada no reconocida', 10,13
	thisIsNotValidLen equ $-thisIsNotValid
	clear db 27,"[H",27,"[2J"      ; <ESC> [H  <ESC>  [2J
    clearLen equ $-clear
	
	; Memory of Gato
	string db '012345678',0
	player db ''
	temp db ' '
;=============================================================================================	
section .bss
	intrance resb 4
	intranceLen resb 1
	actualSimbol resb 1
	rounds resb 1
	 

;=============================================================================================
section .text
	global _start
	
	
_start:
;Objective: prints the main menu
salutation:
	print hello, helloLen
	input
	cmp byte[intrance], '1'
	mov ecx, string
	je setter
	cmp byte[intrance], '2'
	je endGame
	print thisIsNotValid, thisIsNotValidLen
	jmp salutation
;Objective cleans the board
setter:
	mov byte[ecx], ' '
	inc ecx
	cmp byte[ecx], 0
	jne setter
	
	mov byte[player], '0'
	mov byte[rounds], 1
	
; 				Show the state of each round
;Objective: changes the player (X/O)
playerChange:
	print clear, clearLen
	print entering, enteringLen
	print turn, turnLen
	
	mov eax, player
	cmp byte[eax], '0'
	je roundO
	jmp roundX
;Objective: Turn of O
roundO:
	print letterO, letterOLen
	print entering, enteringLen
	jmp printBoard
;Objective: Turn of X
roundX:
	print letterX, letterXLen
	print entering, enteringLen
	jmp printBoard
;Objective: prints the board
printBoard:
	printTable

	cmp byte[rounds], 2
	jge matchTie
	
	jmp readIntrance
;Objective: read the input (X/Y X,Y etc)
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

	
; ;Objective: Validates if the intrance is in a blanck space.
validate:
	mov edx, string
	add edx, eax
	
	cmp byte[edx], ' '
	jne invalid
	
	xor eax, eax
	mov eax, player
	cmp byte[eax], '0'
	je reemplaceO
	jmp reemplaceX
;Objective: if its not valid
invalid:
	print notValid, notValidLen
	jmp readIntrance
;Objective: puts the O in the board
reemplaceO:
	mov byte[edx], 'O'
	mov byte[player], '1'
	jmp conv012
;Objective: puts the X in the board
reemplaceX:
	mov byte[edx], 'X'
	mov byte[player], '0'
	jmp conv012
	
	
	
	
	
; 	;Objective:	Validates all the convinations of victory.
	
	conv012:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		mov al, byte[edx] ; pos 0

		inc edx
		mov bl, byte[edx] ; pos 1

		inc edx
		mov cl, byte[edx] ; pos 2
		
		cmp al, 'X'
		je x012
		cmp al, 'O'
		je o012
		jmp conv048
		
		x012:
			cmp bl, 'X'
			jne conv048
			cmp cl, 'X'
			jne conv048

			jmp victory

		o012:
			cmp bl, 'O'
			jne conv048
			cmp cl, 'O'
			jne conv048

			jmp victory

	conv048:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		mov al, byte[edx] ; pos 0
		
		add edx, 4
		mov bl, byte[edx] ; pos 4

		add edx, 4
		mov cl, byte[edx] ; pos 8
		
		cmp al, 'X'
		je x048
		cmp al, 'O'
		je o048
		jmp conv036
		
		x048:
			cmp bl, 'X'
			jne conv036
			cmp cl, 'X'
			jne conv036

			jmp victory

		o048:
			cmp bl, 'O'
			jne conv036
			cmp cl, 'O'
			jne conv036

			jmp victory

	conv036:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		mov al, byte[edx] ; pos 0
		
		add edx, 3
		mov bl, byte[edx] ; pos 3
		
		add edx, 3
		mov cl, byte[edx] ; pos 6
		
		cmp al, 'X'
		je x036
		cmp al, 'O'
		je o036
		jmp conv147
		
		x036:
			cmp bl, 'X'
			jne conv147
			cmp cl, 'X'
			jne conv147

			jmp victory

		o036:
			cmp bl, 'O'
			jne conv147
			cmp cl, 'O'
			jne conv147

			jmp victory

	conv147:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		inc edx
		mov al, byte[edx] ; pos 1
		
		add edx, 3
		mov bl, byte[edx] ; pos 4
		
		add edx, 3
		mov cl, byte[edx] ; pos 7
		
		cmp al, 'X'
		je x147
		cmp al, 'O'
		je o147
		jmp conv258
		
		x147:
			cmp bl, 'X'
			jne conv258
			cmp cl, 'X'
			jne conv258

			jmp victory

		o147:
			cmp bl, 'O'
			jne conv258
			cmp cl, 'O'
			jne conv258

			jmp victory

conv258:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		add edx, 2
		mov al, byte[edx] ; pos 2
		
		add edx, 3
		mov bl, byte[edx] ; pos 5
		
		add edx, 3
		mov cl, byte[edx] ; pos 8
		
		cmp al, 'X'
		je x258
		cmp al, 'O'
		je o258
		jmp conv246
		
		x258:
			cmp bl, 'X'
			jne conv246
			cmp cl, 'X'
			jne conv246

			jmp victory

		o258:
			cmp bl, 'O'
			jne conv246
			cmp cl, 'O'
			jne conv246

			jmp victory
conv246:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		add edx, 2
		mov al, byte[edx] ; pos 2
		
		add edx, 2
		mov bl, byte[edx] ; pos 4
		
		add edx, 2
		mov cl, byte[edx] ; pos 6
		
		cmp al, 'X'
		je x246
		cmp al, 'O'
		je o246
		jmp conv345
		
		x246:
			cmp bl, 'X'
			jne conv345
			cmp cl, 'X'
			jne conv345

			jmp victory

		o246:
			cmp bl, 'O'
			jne conv345
			cmp cl, 'O'
			jne conv345

			jmp victory
conv345:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		add edx, 3
		mov al, byte[edx] ; pos 3
		
		inc edx
		mov bl, byte[edx] ; pos 4
		
		inc edx
		mov cl, byte[edx] ; pos 5
		
		cmp al, 'X'
		je x345
		cmp al, 'O'
		je o345
		jmp conv678
		
		x345:
			cmp bl, 'X'
			jne conv678
			cmp cl, 'X'
			jne conv678

			jmp victory

		o345:
			cmp bl, 'O'
			jne conv678
			cmp cl, 'O'
			jne conv678

			jmp victory
			
conv678:
		xor eax, eax
		xor ebx, ebx
		xor ecx, ecx
		xor edx, edx
		
		mov edx, string 
		add edx, 6
		mov al, byte[edx] ; pos 6
		
		inc edx
		mov bl, byte[edx] ; pos 7
		
		inc edx
		mov cl, byte[edx] ; pos 8
		
		cmp al, 'X'
		je x678
		cmp al, 'O'
		je o678
		jmp tagggggg
		
		x678:
			cmp bl, 'X'
			jne tagggggg
			cmp cl, 'X'
			jne tagggggg

			jmp victory

		o678:
			cmp bl, 'O'
			jne tagggggg
			cmp cl, 'O'
			jne tagggggg

			jmp victory


;	;Objective:	Verify that the board is not full.
tagggggg:
	mov eax, string	
	convTie:
		cmp byte[eax], ' '
		je playerChange

		cmp byte[eax], 0
		je matchTie

		inc eax
		jmp convTie

	
	
;	;Objective:		Printing the win/loose status.
victory:
	mov eax, player
	cmp byte[eax], '1'
	je vicO
	jmp vicX
	;Objective: If O wins
vicO:	
	print clear, clearLen
	printTable
	print win, winLen
	print letterO, letterOLen
	print entering, enteringLen
	print entering, enteringLen
	jmp _start
	;Objective: If X wins
vicX:
	print clear, clearLen
	printTable
	print win, winLen
	print letterX, letterXLen
	print entering, enteringLen
	print entering, enteringLen
	jmp _start
	;Objective: If its a tie
matchTie:
	print clear, clearLen
	printTable
	print tie, tieLen
	print entering, enteringLen
	jmp _start
	;Objective: If its a tie with escape

scape:
	print tie, tieLen
	jmp _start
	
	;Objective: Ends the game
endGame:
 finish

