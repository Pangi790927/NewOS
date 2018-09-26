[bits 16]
[org 0x7c00]

mov bp, 0x7BFF
mov sp, bp

mov [drive], dl

call clear

mov bl, dl
call puthex

call load_disk

mov bx, [0x7fff]
call puthex

jmp more_memory_zone

%include "video.asm"

load_disk:
	pusha
		mov word[disk_address_packet + 2], 0x580
		mov word[disk_address_packet + 4], 0x7e00
		mov word[disk_address_packet + 6], 0x0
		mov word[disk_address_packet + 8], 0x1
		
		mov ax, 0
		mov ds, ax
		mov ah, 0x42
		mov dl, byte[drive]
		mov si, disk_address_packet
		int 0x13

		mov bl, ah
		call puthex

	popa
	ret

drive:
	db 0

disk_address_packet:
	db 0x10		;size
	db 0x0		;zero
	dw 0x0		;sectors
	dd 0x0		;offset
	dd 0x0		;start
	dd 0x0		;start part 2

times 510 - ($-$$) db 0
dw 0xaa55

%include "start_protected.asm"

more_memory_zone:
		

	jmp $