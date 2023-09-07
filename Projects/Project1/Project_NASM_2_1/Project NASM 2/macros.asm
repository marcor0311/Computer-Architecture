
%macro input 0
	mov eax, 3
	mov ebx, 0
    	mov ecx, intrance ; save de string.
    	mov edx, 255 ; save the leng of the string.
    	int 80h
%endmacro

%macro print 2
    	mov eax, 4
    	mov ebx, 1
    	mov ecx, %1 ; string.
    	mov edx, %2 ; len of the string.
    	int 80h
%endmacro

;Objective: print a line of the board structure.
%macro printLine 0
	print open, openLen
	pop rcx
	print ecx, 1
	push rcx
	print close, closeLen
	print separate, separateLen
	print open, openLen
	pop rcx
	inc ecx
	print ecx, 1
	push rcx
	print close, closeLen
	print separate, separateLen
	print open, openLen
	pop rcx
	inc ecx
	print ecx, 1
	push rcx
	print close, closeLen
	print entering, enteringLen

%endmacro

;Objective: print the format of the board.
%macro printTable 0
	print entering, enteringLen
	print sim123, sim123Len
	print entering, enteringLen
	print sim1, 3
	
	mov ecx, string
	push rcx
	printLine
	print equals, equalsLen
	pop rcx
	inc ecx
	push rcx
	print sim2, 3
	printLine
	print equals, equalsLen
	pop rcx
	inc ecx
	push rcx
	print sim3, 3
	printLine
	print entering, enteringLen
	
%endmacro

;Objective: get a random number between 0 and 2.
%macro random 1
	xor eax, eax
	rdtsc
	and ah, %1 ;To use any number it must be filled with 1's
	add ah, '0'
	mov byte[temp], ah
	
%endmacro

;Objective: its a spam to get from 0 to 9
%macro complexRandom 0
	random 00000011b
	mov al, byte[temp]
	mov byte[temp1], al
	random 00000011b
	mov al, byte[temp]
	mov byte[temp2], al
	random 00000011b
	mov al, byte[temp]
	sub al, '0'
	mov bl, byte[temp1]
	sub bl, '0'
	add al, bl
	mov bl, byte[temp2]
	sub bl, '0'
	add al, bl
	add al, '0'
	mov byte[temp], al
%endmacro

;Objective: close the program when appear
%macro finish 0
	mov eax, 1
	mov ebx, 0
	int 80h
	
%endmacro
