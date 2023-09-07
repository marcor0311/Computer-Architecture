Instrucciones para la ejecuccion del programa

1.Primero lo compilamos con el comando

nasm -f elf64 sudoku.asm
y
ld -s -o sudoku sudoku.o

2.Lo ejecutamos con el comando
./sudoku

3.Nos va a salir un menu con 2 opciones

	3.1.opcion 1 para jugar al juego

	3.2 opcion 2 para volver a la terminal

4.En caso de seleccionar la opcion 1 nos va a pedir que ingresemos la cordenada de la matriz y un numero
Son validos los siguientes formatos de cordenadas: X,Y,N  X Y N X/Y/Z entre otros

5.Se repite el paso 4 hasta que termine la partida

6.En caso de querer finalizar la partida antes, se puede presionar escape+enter

