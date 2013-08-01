;
; head.s
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

[BITS 32]
global _start, _kernel_stack
extern k_main
[EXTERN code]
[EXTERN bss]
[EXTERN end]

SECTION .text
_start:
	jmp short _startup
	align 4
	
_startup:
	mov ax, 0x10
	mov ds, ax
	mov es, ax
	mov ss, ax
	mov esp, _kernel_stack
	call k_main
	
	cli
	hlt

SECTION .bss
	resb 8192
_kernel_stack:
