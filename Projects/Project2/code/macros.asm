
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

;Objective: print a line of the gato structure.
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
;Objective: print the format of the gato.
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

%macro finish 0
	; Close the program.
	mov eax, 1
	mov ebx, 0
	int 80h
%endmacro
