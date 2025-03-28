all: y.tab.c lex.yy.c
	gcc -o parser y.tab.c
y.tab.c: Realang_Yacc.y lex.yy.c
	yacc -d -v Realang_Yacc.y
lex.yy.c: Realang_Lexer.l
	lex Realang_Lexer.l
clean:
	rm -f lex.yy.c y.tab.c parser