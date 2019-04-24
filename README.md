# Compiler_Design_Project

## The is the term project for our Compiler Design class.

### Steps to execute the project:

1. yacc parser.y or bison parser.y -d 
the -d is used to generate header file parser.tab.h
2. lex finalexer.l or flex finalexer.l 
3. gcc y.tab.c -ll -ly or gcc parser.tab.c -ll -ly -w
4. ./a.out test

### References:

1. http://dinosaur.compilertools.net/bison/bison_6.html?fbclid=IwAR0VicThJFmpGt9gD_kAYhPt9EhaneTwPtWyzD0NUGalWaSnE0-2YSnD9rQ

2. https://github.com/kranthikiran01/subc-compiler

3. https://c9x.me/yacc/

4. https://github.com/SilverScar/C-Language-Parser

5. https://gist.github.com/codebrainz/2933703

6. http://aquamentus.com/flex_bison.html

7. http://www.quut.com/c/ANSI-C-grammar-l-1995.html

8. https://stackoverflow.com/questions/47420730/linker-error-multiple-definition-of-yylex
