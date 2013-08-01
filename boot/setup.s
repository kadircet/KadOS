;
; setup.s
; This file is part of KadOS
;
; Copyright (C) 2013 - Kadir ÇETİNKAYA, METU, Ankara TURKEY
;
; KadOS is free software; you can redistribute it and/or modify
; it under the terms of the GNU General Public License as published by
; the Free Software Foundation; either version 2 of the License, or
; (at your option) any later version.
;
; KadOS is distributed in the hope that it will be useful,
; but WITHOUT ANY WARRANTY; without even the implied warranty of
; MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
; GNU General Public License for more details.
;
; You should have received a copy of the GNU General Public License
; along with KadOS. If not, see <http://www.gnu.org/licenses/>.
;


; setup.s is responsible for gettin the system data from the BIOS,
; and putting them into the memory.


	mov ax, SETUPSEG
	mov ds, ax
	mov cx, setup
	call print
	
; save cursor position for later uses
	mov ah, 0x03
	xor bh, bh
	int 0x10
	mov [0], dx			; position saved to SETUPSEG:0 (0x90000)
	
; Get memory size (kB)
	mov ah, 0x88
	int 0x15
	mov [2], ax

; Get video-card data:
	mov ah, 0x0F
	int 0x10
	mov [4], bx		; bh = display mode
	mov [6], ax		; al = video mode, ah = window width
	
; Check for EGA/VGA
	mov ah, 0x12
	mov bl, 0x10
	int 0x10
	mov [8], ax
	mov [10], bx
	mov [12], cx

; now lets move to protected mode!
	cli
	
; move system to its home (0x0000)
	mov ax, 0x0000
	cld
do_move:
	mov es, ax		;set destination
	add ax, 0x1000
	cmp ax, 0x9000
	jz  end_move
	mov ds, ax		;set source
	sub di, di
	sub si, si
	mov cx, 0x8000
	rep
	movsw
	jmp do_move
end_move:

; enable A20
	call a20

; lets load segment descriptors
	mov ax, SETUPSEG
	mov ds, ax

	lgdt [gdt_desc]
	lidt [idt_desc]

;now we are actually moving into protected mode :D
	mov eax, cr0
	or eax, 0x01
	mov cr0, eax

;JUMP TO KERNEL!!!
	jmp 0x08:0x00


;Prints the string at [cx]
;string must be null terminated
print:
	push ax
	push bx

.putc:
	mov ah, 0x0E
	mov bx, cx
	mov al, [bx]
	mov bh, 0x0F
	mov bl, 0x00

	or al, al
	jz .return

	int 0x10
	inc cx
	jmp .putc

.return:
	pop bx
	pop ax
	ret
;END OF print

;enables A20 line
a20:
	push ax
	in al, 0x92
	or al, 0x02
	out 0x92, al
	pop ax
	ret
;END OF a20

;variables
setup:	db "Setting up environment", 0x0D, 0x0A, 0x00
reset:	db "Reseting Drive.. ", 0x00
done:	db "[DONE]", 0x0D, 0x0A, 0x00
SETUPSEG	equ 0x9000
;END OF variables

;gdt
gdt:
	dw	0,0,0,0		;dummy
	
	dw	0xFFFF		; 8Mb - limit=2047 (2048*4096=8Mb)
	dw	0x0000		; base address=0
	dw	0x9A00		; code read/exec
	dw	0x00C0		; granularity=4096, 386

	dw	0xFFFF		; 8Mb - limit=2047 (2048*4096=8Mb)
	dw	0x0000		; base address=0
	dw	0x9200		; data read/write
	dw	0x00C0		; granularity=4096, 386

gdt_end:

gdt_desc:
	dw 0x800
	dw gdt,0x9

idt_desc:
	dw 0x00
	dd 0x00

times 512-($-$$) db 0x00
