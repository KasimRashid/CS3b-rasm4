all:
	as -g -o Rasm4.o Rasm4.s
	as -g -o Functions.o Functions.s
	ld -o Rasm4 /usr/lib/aarch64-linux-gnu/libc.so Rasm4.o -dynamic-linker /lib/ld-linux-aarch64.so.1 Functions.o ../obj/String_lastIndexOf_2.o ../obj/String_lastIndexOf_1.o ../obj/String_indexOf_1.o ../obj/String_indexOf_2.o ../obj/putstring.o ../obj/putch.o ../obj/String_length.o ../obj/int64asc.o ../obj/ascint64.o ../obj/getstring.o ../obj/hex64asc.o ../obj/String_equals.o ../obj/String_startsWith_2.o ../obj/String_startsWith_1.o ../obj/String_charAt.o ../obj/String_endsWith.o ../obj/String_copy.o ../obj/String_substring_1.o ../obj/String_substring_2.o ../obj/String_replace.o ../obj/String_concat.o ../obj/String_toLowerCase.o ../obj/String_toUpperCase.o ../obj/String_equalsIgnoreCase.o ../obj/String_indexOf_3.o  ../obj/String_lastIndexOf_3.o

.PHONY: clean

clear:
	rm -f * .o run *~
