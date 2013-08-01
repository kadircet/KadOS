;
;boot.s
;This file is part of KadOS
;
;Copyright (C) 2013 - Kadir ÇETİNKAYA, METU, Ankara TURKEY
;
;KadOS is free software; you can redistribute it and/or modify
;it under the terms of the GNU General Public License as published by
;the Free Software Foundation; either version 2 of the License, or
;(at your option) any later version.
;
;KadOS is distributed in the hope that it will be useful,
;but WITHOUT ANY WARRANTY; without even the implied warranty of
;MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
;GNU General Public License for more details.
;
;You should have received a copy of the GNU General Public License
;along with KadOS. If not, see <http:;www.gnu.org/licenses/>.
;
;
;
;bootloader is loaded at 0x7c00 by the bios-startup routines.
;
;It then loads setup after itself and the system using BIOS interrupts.
;

[ORG 0x7C00]
	
	mov cx, boot
	call print

	mov ax, SETUPSEG
	mov es, ax
	call read_setup
	
	mov ax, SYSSEG
	mov es, ax
	call read_kernel

	jmp SETUPSEG:0x0000


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


;makes floppy drive ready
;to read the kernel
reset_drive:
	push ax
	push cx

	mov cx, reset
	call print

.try:
	mov ah, 0x00
	int 0x13
	or ah, ah
	jnz .try
	
	mov cx, done
	call print
	pop cx
	pop ax
	ret
;END OF reset_drive


;reads the setup from
;the floppy
read_setup:
	call reset_drive
	mov cx, setup
	call print

	mov dx, 0x0000
	mov cx, 0x0002
	xor bx, bx
	mov ax, 0x0200+SETUPLEN
	int 0x13
	or ah, ah
	jnz read_setup
	
	add [sector], al
	
	mov cx, done
	call print
	ret
;END OF read_kernel

;reads the kernel from
;the floppy
read_kernel:
	call reset_drive
	mov cx, kernel
	call print

	mov dx, 0x0000
	mov ch, 0x00
	mov cl, 0x03
	xor bx, bx
	mov ax, 0x0200+SYSLEN
	int 0x13
	or ah, ah
	jnz read_kernel
	
	mov cx, done
	call print
	ret
;END OF read_kernel


;variables
boot:	db "Boot Started!", 0x0D, 0x0A, 0x00
reset:	db "Reseting Drive.. ", 0x00
setup:	db "Reading Setup.. ", 0x00
kernel:	db "Reading Kernel.. ", 0x00
done:	db "[DONE]", 0x0D, 0x0A, 0x00
sector: db 0x02
SETUPLEN	equ 2
SETUPSEG	equ 0x9000
BOOTSEG		equ 0x7C00
SYSSEG		equ 0x1000
SYSLEN		equ 2
;END OF variables

times 510-($-$$) db 0x00
dw 0xAA55
