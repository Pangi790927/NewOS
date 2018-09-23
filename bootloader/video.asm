INT_VIDEO_SERVICE equ 0x10
INT_WRITE_CHAR equ 0xe
INT_SET_CURSOR equ 0x2
INT_CLEAR equ 0x6

digit_hex:
	db "0123456789ABCDEF"

; bx
puthex:	
	pusha
		.terminator:
			db "0x", 0
		mov si, .terminator
		call putstr

		mov di, bx
		and di, 0xF000
		shr di, 12
		mov al, byte[digit_hex + di]
		call putchar

		mov di, bx
		and di, 0x0F00
		shr di, 8
		mov al, byte[digit_hex + di]
		call putchar

		mov di, bx
		and di, 0x00F0
		shr di, 4
		mov al, byte[digit_hex + di]
		call putchar

		mov di, bx
		and di, 0x000F
		mov al, byte[digit_hex + di]
		call putchar
	popa
	ret

; si -> NULL terminated string
putstr:
	pusha
		.start:
			mov al, byte[si]
			test al, al
			je .end
			call putchar
			inc si
			jmp .start
		.end:
	popa
	ret

; al -> char
putchar:
	pusha
		mov ah, INT_WRITE_CHAR
		mov bh, 0
		int INT_VIDEO_SERVICE
	popa
	ret

clear:
	pusha
		mov ah, INT_CLEAR
		mov al, 0x0
		mov bh, 0x8
		mov ch, 0x0
		mov cl, 0x0
		mov dh, 24
		mov dl, 79
		int INT_VIDEO_SERVICE

		mov ah, INT_SET_CURSOR
		mov bh, 0x0
		mov dh, 0x0
		mov dl, 0x0
		int INT_VIDEO_SERVICE
	popa
	ret

str_error:
	db "ERROR", 0
