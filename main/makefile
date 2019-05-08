all:bison flex sparser.tab.h
	gcc sparser.tab.c -ll -ly -w #lex.yy.c -o comp -lfl -lm

flex: lexer.l
	flex -i lexer.l

bison: sparser.y
	bison -d sparser.y

clean:
	rm a.out lex.yy.c sparser.tab.c sparser.tab.h sparser.output #*~ *\#
