/*
 * k_main.c
 * This file is part of KadOS
 *
 * Copyright (C) 2013 - Kadir ÇETİNKAYA, METU, Ankara TURKEY
 *
 * KadOS is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or
 * (at your option) any later version.
 *
 * KadOS is distributed in the hope that it will be useful,
 * but WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 * GNU General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with KadOS. If not, see <http://www.gnu.org/licenses/>.
 */

void k_main()
{
	char *video = (char*)0xB8000;
	char* hi = "Welcome to KadOS!!!";
	int i=0;
	for(;i<80*25;i++)
	{
		*video++=' ';
		*video++=0x16;
	}
	
	video = (char*)0xB8000;
	video[0] = hi[0];
	video[2] = hi[1];
	video[4] = hi[2];
	video[6] = hi[3];
	video[8] = hi[4];
	video[10] = hi[5];
	video[12] = hi[6];
	video[14] = hi[7];
	video[16] = hi[8];
	video[18] = hi[9];
	video[20] = hi[10];
	video[22] = hi[11];
	video[24] = hi[12];
	video[26] = hi[13];
	video[28] = hi[14];
	video[30] = hi[15];
	video[32] = hi[16];
	video[34] = hi[17];
	video[36] = hi[18];

	for(;;);
}

