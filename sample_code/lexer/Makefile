lexer      : lex.yy.o
	cc -o lexer lex.yy.o -ll
lex.yy.o : lex.yy.c 
	cc -c lex.yy.c 
lex.yy.c: lex.l
	flex lex.l

clean:
	rm -f lex.yy.* lexer