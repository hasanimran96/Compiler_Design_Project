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

%token CHAR REAL NUM POSITIVE NONE
%token STOP GO DO ELSE JUMP IF END LOOP
%token SIZE IDENTIFIER CONSTANT STRING
Bison declarations

%%
translation_unit: external_declaration
			| translation_unit external_declaration
			;


external_declaration: function_definition 
			| declaration
			;

function_definition: {type}* declarator {declaration}* compound_statement

type: 'none' 
                                    | 'char' 
                                    | 'num' 
                                    | 'real' 
                                    | 'positive'
                                    ;

declarator: {pointer}? direct_declarator

pointer: *{pointer}?

direct_declarator: identifier
                                    | '(' declarator ')'
                                    | direct_declarator '[' {or_expression}? ']'
                                    | direct_declarator '(' parameter_type_list ')'
                                    | direct_declarator '(' {identifier}* ')'

or_expression: and_expression
                                    | or_expression '||' and_expression


and_expression: equality_expression
                                    | and_expression '&&' equality_expression
	
equality_expression: relational_expression
                                    | equality_expression '==' relational_expression
                                    | equality_expression '!=' relational_expression

relational_expression: additive_expression
                                    | relational_expression "<" additive_expression
                                    | relational_expression ">" additive_expression
                                    | relational_expression "<=" additive_expression
                                    | relational_expression ">=" additive_expression

additive_expression: multiplicative_expression
                                    | additive_expression "+" multiplicative_expression
                                    | additive_expression "-' multiplicative_expression

multiplicative_expression: cast_expression
                                    | multiplicative_expression '*' cast_expression
                                    | multiplicative_expression '/' cast_expression
                                    | multiplicative_expression '%' cast_expression

cast_expression: unary_expression 
                                    | '(' type_name ')' cast_expression

unary_expression: postfix_expression
                                    | unary_operator cast_expression
                                    | 'size' unary_expression
                                    | 'size' type_name

postfix_expression: primary_expression
                                    | postfix_expression '[' expression ']'
                                    | postfix_expression '(' {assignment_expression}* ')'

primary_expression: identifier
                                    | constant
                                    | words
                                    | '(' expression ')'

constant: number 
                                    | character 
                                    | real_number

expression: assignment_expression 
                                    | expression ',' assignment_expression

assignment_expression: or_expression
                                    | unary_expression assignment_operator assignment_expression

assignment_operator: '=' 
                                    | '*=' 
                                    | '/='
                                    | '%=' 
                                    | '+=' 
                                    | '-=' 

unary_operator: '&' 
                                    | '*' 
                                    | '+' 
                                    | '-' 
                                    | '!'

type_name: {specifier_qualifier}+ {abstract_declarator}?

parameter_type_list: parameter_list 
                                    | parameter_list ',' ...

parameter_list: parameter_declaration 
                                    | parameter_list ',' parameter_declaration

parameter_declaration: {type}+ declarator
                                    | {type}+ abstract_declarator
                                    | {type}+

abstract_declarator: pointer
                                    | pointer direct_abstract_declarator
                                    | direct_abstract_declarator

direct_abstract_declarator:  '(' abstract_declarator ')'
                                    | {direct_abstract_declarator}? '[' {or_expression}? ']'
                                    | {direct_abstract_declarator}? '(' {parameter_type_list}? ')'

declaration:  {type}+ {init_declarator}* ';'

init_declarator: declarator 
                                    | declarator '=' initializer

initializer: assignment_expression
                                    | '{' initializer_list '}'
                                    | '{' initializer_list ',' '}'

initializer_list: initializer 
                                    | initializer_list ',' initializer

compound_statement: '{' {declaration}* {statement}* '}'

statement:  expression_statement
                                    | compound_statement
                                    | condition_statement
                                    | iteration_statement
                                    | jump_statement

expression_statement: {expression}? ';'

condition_statement: 'if' '(' expression ')' statement
                                    | 'if' '(' expression ')' statement 'else' statement

iteration_statement: 'loop' '(' expression ')' statement
                                    | 'do' statement 'loop' '(' expression ')' ';'

jump_statement: 'jump' identifier ';'
                                    | 'go' ';'
                                    | 'stop' ';'
                                    | 'end' {expression}? ';'

%%

Additional C code
