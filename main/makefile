all:bison flex parser.tab.h
	gcc parser.tab.c -ll -ly -w #lex.yy.c -o comp -lfl -lm

flex: lexer.l
	flex -i lexer.l

bison: parser.y
	bison -d parser.y

clean:
	rm a.out lex.yy.c parser.tab.c parser.tab.h parser.output #*~ *\#
