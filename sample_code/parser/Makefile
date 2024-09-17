parser: y.tab.o
	gcc -o parser y.tab.o -ll
y.tab.o : y.tab.c 
	gcc -c y.tab.c 
y.tab.c: lex.yy.c grammar.y
	yacc -d -v grammar.y
lex.yy.c: lex.l
	flex $< 

clean:
	rm -f lex.yy.* y.tab.* y.output parser