# Compiler_Design_Project

## The is the term project for our Compiler Design class.

### Steps to execute the project:

1. make all
2. make clean
3. ./a.out "code.ccc"

## References:

1. http://dinosaur.compilertools.net/bison/bison_6.html?fbclid=IwAR0VicThJFmpGt9gD_kAYhPt9EhaneTwPtWyzD0NUGalWaSnE0-2YSnD9rQ

2. https://github.com/kranthikiran01/subc-compiler

3. https://c9x.me/yacc/

4. https://github.com/SilverScar/C-Language-Parser

5. https://gist.github.com/codebrainz/2933703

6. http://aquamentus.com/flex_bison.html

7. http://www.quut.com/c/ANSI-C-grammar-l-1995.html

8. https://stackoverflow.com/questions/47420730/linker-error-multiple-definition-of-yylex

9. https://www.geeksforgeeks.org/operators-c-c/

10. https://www.youtube.com/watch?v=eF9qWbuQLuw

11. https://www.youtube.com/watch?v=fDKfdyDWdE4

12. https://docs.microsoft.com/en-us/cpp/c-language/c-abstract-declarators?view=vs-2019

13. https://github.com/ZhenoSan/ThreeAddressCode

----------------------------------------------

bison parser.y --report=all  
bison parser.y -o parser.cc  
gcc parser.cc -fno-diagnostics-show-caret  

----------------------------------------------

## Grammar Reduction

!x is x == 0  
x!=y is !(x==y) is (x==y)==0  
x-y is x+(-y)  
x[y] is \*(x+y)  
removed positive type (unsigned)  
removed casting  
