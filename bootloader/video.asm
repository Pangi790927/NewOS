INT_VIDEO_SERVICE equ 0x10
INT_WRITE_CHAR equ 0xE
INT_SET_CURSOR equ 0x2
INT_CLEAR equ 0x6

; bx
puthex:
	.digit_hex:
		db "0123456789ABCDEF"
	pusha
		.terminator:
			db "0x", 0
		mov si, .terminator
		call putstr

		test bx, bx
		jne .puthex_rec
		mov al, '0'
		call putchar
	popa
	ret

	.puthex_rec:
		pusha
			test bx, bx
			je .end
			mov si, bx
			and si, 0xF
			add si, .digit_hex
			shr bx, 0x4
			call .puthex_rec
			mov al, byte[si]
			call putchar
			.end:
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
		mov cx,  0
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