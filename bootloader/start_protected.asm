%include "bios_utils.asm"
%include "gdt.asm"

start_protected:
	; disable interrupts
	cli

	call enable_a20

	lgdt [gdt_descriptor]

	mov eax, cr0
	or al, 1
	mov cr0, eax

	jmp 0x8:protected_mode_enabled

[bits 32]
protected_mode_enabled:
; set rest of segments
; call kernel
	jmp $