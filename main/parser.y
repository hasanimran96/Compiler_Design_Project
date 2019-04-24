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
%token SIZE IDENTIFIER CONSTANT STRING
%token CHAR REAL NUM POSITIVE NONE
%token STOP GO DO ELSE JUMP IF END LOOP
%token ELLIPSIS
%token INLINE
%token	ADDEQ SUBEQ MULEQ DIVEQ MODEQ AND OR LE GE EQUAL NOTEQ

%start translation_unit

%%
translation_unit
				: external_declaration
				| translation_unit external_declaration
				;

external_declaration
				: function_definition 
				| declaration
				;

function_definition
				: declaration_specifiers declarator declaration_list compound_statement
				| declaration_specifiers declarator compound_statement
				;

declaration_list
				: declaration
				| declaration_list declaration
				;
				
type
				: NONE
				| CHAR 
				| NUM 
				| REAL 
				| POSITIVE
				;

declarator
				: pointer direct_declarator
				| direct_declarator
				;

pointer
				: '*'
				| '*' pointer
				;

direct_declarator
				: IDENTIFIER
				| '(' declarator ')'
				| direct_declarator '[' assignment_expression ']'
				| direct_declarator '[' '*' ']'
				| direct_declarator '[' ']'
				| direct_declarator '(' parameter_type_list ')'
				| direct_declarator '(' identifier_list ')'
				| direct_declarator '(' ')'
				;
identifier_list
				: IDENTIFIER
				| identifier_list ',' IDENTIFIER
				;
or_expression
				: and_expression
				| or_expression OR and_expression
				;

and_expression
				: equality_expression
				| and_expression AND equality_expression
				;
	
equality_expression
				: relational_expression
				| equality_expression EQUAL relational_expression
				| equality_expression NOTEQ relational_expression
				;

relational_expression
				: additive_expression
				| relational_expression '<' additive_expression
				| relational_expression '>' additive_expression
				| relational_expression LE additive_expression
				| relational_expression GE additive_expression
				;

additive_expression
				: multiplicative_expression
				| additive_expression '+' multiplicative_expression
				| additive_expression '-' multiplicative_expression
				;

multiplicative_expression
				: cast_expression
				| multiplicative_expression '*' cast_expression
				| multiplicative_expression '/' cast_expression
				| multiplicative_expression '%' cast_expression
				;

cast_expression
				: unary_expression 
				| '(' type_name ')' cast_expression
				;

unary_expression
				: postfix_expression
				| unary_operator cast_expression
				| SIZE unary_expression
				| SIZE type_name
				;

postfix_expression
				: primary_expression
				| postfix_expression '[' expression ']'
				| postfix_expression '(' {assignment_expression}* ')'
				;

primary_expression
				: IDENTIFIER
				| CONSTANT
				| STRING
				| '(' expression ')'
				;

expression
				: assignment_expression 
				| expression ',' assignment_expression
				;

assignment_expression
				: or_expression
				| unary_expression assignment_operator assignment_expression
				;

assignment_operator
				: '=' 
				| MULEQ 
				| DIVEQ
				| MODEQ 
				| ADDEQ 
				| SUBEQ 
				;

unary_operator
				: '&' 
				| '*' 
				| '+' 
				| '-' 
				| '!'
				;

type_name
				: specifier_qualifier_list
				| specifier_qualifier_list abstract_declarator
				;

specifier_qualifier_list
				: type specifier_qualifier_list
				| type
				;

parameter_type_list
				: parameter_list 
				| parameter_list ',' ELLIPSIS
				;

parameter_list
				: parameter_declaration 
				| parameter_list ',' parameter_declaration
				;

parameter_declaration
				: declaration_specifiers declarator
				| declaration_specifiers abstract_declarator
				| declaration_specifiers
				;
abstract_declarator
				: pointer
				| pointer direct_abstract_declarator
				| direct_abstract_declarator
				;

direct_abstract_declarator
				: '(' abstract_declarator ')'
				| '[' ']'
				| '[' assignment_expression ']'
				| direct_abstract_declarator '[' ']'
				| direct_abstract_declarator '[' assignment_expression ']'
				| '[' '*' ']'
				| direct_abstract_declarator '[' '*' ']'
				| '(' ')'
				| '(' parameter_type_list ')'
				| direct_abstract_declarator '(' ')'
				| direct_abstract_declarator '(' parameter_type_list ')'
				;

declaration
				: declaration_specifiers ';'
				| declaration_specifiers init_declarator_list ';'
				;

declaration_specifiers
				: type_specifier
				| type_specifier declaration_specifiers
				| function_specifier
				| function_specifier declaration_specifiers
				;

function_specifier
				: INLINE
				;
				
init_declarator_list
				: init_declarator
				| init_declarator_list ',' init_declarator
				;

init_declarator
				: declarator 
				| declarator '=' initializer
				;


initializer
				: assignment_expression
				| '{' initializer_list '}'
				| '{' initializer_list ',' '}'
				;

initializer_list
				: initializer 
				| initializer_list ',' initializer
				;

compound_statement
				: '{' '}'
				| '{' block_item_list '}'
				;

block_item_list
				: block_item
				| block_item_list block_item
				;

block_item
				: declaration
				| statement
				;
statement  
				:expression_statement
				| compound_statement
				| condition_statement
				| iteration_statement
				| jump_statement
				;
expression_statement
				: ';'
				| expression ';'
				;

condition_statement
				: IF '(' expression ')' statement
				| IF '(' expression ')' statement ELSE statement
				;

iteration_statement
				: LOOP '(' expression ')' statement
				| DO statement LOOP '(' expression ')' ';'
				;
				
jump_statement
				: JUMP IDENTIFIER ';'
				| GO ';'
				| STOP ';'
				| END ';'
				| END expression ';'
				;
%%
#include <stdio.h>

extern char yytext[];
extern int column;

void yyerror(char const *s)
{
	fflush(stdout);
	printf("\n%*s\n%*s\n", column, "^", column, s);
}
