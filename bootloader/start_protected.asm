
disable_interupts:
	cli

; allow more than 1Mb memory
enable_a20:
	in al, 0x92
	or al, 2
	out 0x92, al

; check if 64 bit is supported and return in eax
check_cpuid:
	pusha
		; try to switch cpuid bit
		pushfd
		pop eax

		mov ecx, eax
		xor eax, 1 << 21

		push eax
		popfd

		; get back result
		pushfd
		pop eax

		; restore cpuid flag
		push ecx
		popfd

		mov ebx, 0

		xor eax, ecx
		jz .noCPUID
		mov ebx, 1
		.noCPUID:
		mov eax, ebx
	popa
	ret

; disputed coding style
check_long_mode:
	pusha
		call check_cpuid

		test eax, eax
		jz .no_cpuid
			mov eax, 0x80000000
			cpuid
			cmp eax, 0x80000001
			mov eax, 1
			jmp .is_long_mode
		.no_cpuid:
			mov eax, 0
		.is_long_mode:
	popa
	ret
