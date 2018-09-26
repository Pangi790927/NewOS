; global descriptor table

start_gdt:
	.null:
		dq 0

	.kern_code:
		dw 0xffff
		dw 0
		db 0
		db 10011010b
		db 11001111b
		db 0

	.kern_data:
		dw 0xffff
		dw 0
		db 0
		db 10010010b
		db 11001111b
		db 0

	.user_code:
		dw 0xffff
		dw 0
		db 0
		db 11111010b
		db 11001111b
		db 0

	.user_data:
		dw 0xffff
		dw 0
		db 0
		db 11110010b
		db 11001111b
		db 0
end_gdt:

gdt_descriptor:
	dw end_gdt - start_gdt - 1
	dd start_gdt	
