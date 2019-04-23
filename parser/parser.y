%{
C declarations
/* 
The C declarations section contains macro definitions and declarations 
of functions and variables that are used in the actions in the grammar rules. 
These are copied to the beginning of the parser file so that they precede 
the definition of yyparse. 
You can use `#include' to get the declarations from a header file. 
If you don't need any C declarations, 
you may omit the `%{' and `%}' delimiters that bracket this section.
*/

%}

/*
Use the %left, %right or %nonassoc declaration to declare a token and 
specify its precedence and associativity, all at once. 
These are called precedence declarations.
*/

Bison declarations

%%
translation_unit: external_declaration
	| translation_unit external_declaration
	;


external-declaration: function-definition 
                                    | declaration

function-definition: {type}* declarator {declaration}* compound-statement

type: "none" 
                                    | "char" 
                                    | "num" 
                                    | "real" 
                                    | "positive"

declarator: {pointer}? direct-declarator

pointer: *{pointer}?

direct-declarator: identifier
                                    | "(" declarator ")"
                                    | direct-declarator "[" {or-expression}? "]"
                                    | direct-declarator "(" parameter-type-list ")"
                                    | direct-declarator "(" {identifier}* ")"

or-expression: and-expression
                                    | or-expression "||" and-expression


and-expression: equality-expression
                                    | and-expression "&&" equality-expression
	
equality-expression: relational-expression
                                    | equality-expression "==" relational-expression
                                    | equality-expression "!=" relational-expression

relational-expression: additive-expression
                                    | relational-expression "" additive-expression
                                    | relational-expression "" additive-expression
                                    | relational-expression "=" additive-expression
                                    | relational-expression "=" additive-expression

additive-expression: multiplicative-expression
                                    | additive-expression "+" multiplicative-expression
                                    | additive-expression "-" multiplicative-expression

multiplicative-expression: cast-expression
                                    | multiplicative-expression "*" cast-expression
                                    | multiplicative-expression "/" cast-expression
                                    | multiplicative-expression "%" cast-expression

cast-expression: unary-expression 
                                    | "(" type-name ")" cast-expression

unary-expression: postfix-expression
                                    | unary-operator cast-expression
                                    | "size" unary-expression
                                    | "size" type-name

postfix-expression: primary-expression
                                    | postfix-expression "[" expression "]"
                                    | postfix-expression "(" {assignment-expression}* ")"

primary-expression: identifier
                                    | constant
                                    | words
                                    | "(" expression ")"

constant: number 
                                    | character 
                                    | real-number

expression: assignment-expression 
                                    | expression "," assignment-expression

assignment-expression: or-expression
                                    | unary-expression assignment-operator assignment-expression

assignment-operator: "=" 
                                    | "*=" 
                                    | "/="
                                    | "%=" 
                                    | "+=" 
                                    | "-=" 

unary-operator: "&" 
                                    | "*" 
                                    | "+" 
                                    | "-" 
                                    | "!"

type-name: {specifier-qualifier}+ {abstract-declarator}?

parameter-type-list: parameter-list 
                                    | parameter-list "," ...

parameter-list: parameter-declaration 
                                    | parameter-list "," parameter-declaration

parameter-declaration: {type}+ declarator
                                    | {type}+ abstract-declarator
                                    | {type}+

abstract-declarator: pointer
                                    | pointer direct-abstract-declarator
                                    | direct-abstract-declarator

direct-abstract-declarator:  "(" abstract-declarator ")"
                                    | {direct-abstract-declarator}? "[" {or-expression}? "]"
                                    | {direct-abstract-declarator}? "(" {parameter-type-list}? ")"

declaration:  {type}+ {init-declarator}* ";"

init-declarator: declarator 
                                    | declarator "=" initializer

initializer: assignment-expression
                                    | "{" initializer-list "}"
                                    | "{" initializer-list "," "}"

initializer-list: initializer 
                                    | initializer-list "," initializer

compound-statement: "{" {declaration}* {statement}* "}"

statement:  expression-statement
                                    | compound-statement
                                    | condition-statement
                                    | iteration-statement
                                    | jump-statement

expression-statement: {expression}? ";"

condition-statement: "if" "(" expression ")" statement
                                    | "if" "(" expression ")" statement "else" statement

iteration-statement: "loop" "(" expression ")" statement
                                    | "do" statement "loop" "(" expression ")" ";"

jump-statement: "jump" identifier ";"
                                    | "go" ";"
                                    | "stop" ";"
                                    | "end" {expression}? ";"

%%

Additional C code
