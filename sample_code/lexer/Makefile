go      : lexdrv.o lex.yy.o table.o
	cc -o go lexdrv.o lex.yy.o table.o -ll
lexdrv.o: lexdrv.c token.h
	cc -c lexdrv.c
lex.yy.o : lex.yy.c 
	cc -c lex.yy.c 
table.o  : table.c
	cc -c table.c
lex.yy.c: lex.l token.h
	flex lex.l
