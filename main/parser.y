%{
//C declarations
/* 
The C declarations section contains macro definitions and declarations 
of functions and variables that are used in the actions in the grammar rules. 
These are copied to the beginning of the parser file so that they precede 
the definition of yyparse. 
You can use `#include' to get the declarations from a header file. 
If you don't need any C declarations, 
you may omit the `%{' and `%}' delimiters that bracket this section.
*/
// Declare stuff from Flex that Bison needs to know about:
#include <stdio.h>
#include <stdlib.h>
/*
extern int yylex();
extern int yyparse();
extern FILE *yyin;
*/

extern FILE *fp;
//FILE * f1;

void yyerror(const char *s);

%}

/*
Use the %left, %right or %nonassoc declaration to declare a token and 
specify its precedence and associativity, all at once. 
These are called precedence declarations.
*/
%token IDENTIFIER CONSTANT STRING
%token CHAR REAL NUM POSITIVE NONE
%token STOP GO DO JUMP IF END LOOP

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%left AND OR LE GE EQUAL

%right '='

%start external_declaration

%%
external_declaration
			: compound_statement
			| declaration
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
			| direct_declarator '(' identifier_list ')'
			| direct_declarator '(' ')'
			;
identifier_list
			: IDENTIFIER
			| identifier_list ',' IDENTIFIER
			;
or_expression
			: and_expression{push();}{codegen_logical();}
			| or_expression{push();} OR and_expression{codegen_logical();}
			;

and_expression
			: equality_expression{push();}
			| and_expression{push();} AND equality_expression
			;

equality_expression
			: relational_expression
			| equality_expression EQUAL relational_expression
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
			;

multiplicative_expression
			: cast_expression
			| multiplicative_expression '*' cast_expression
			| multiplicative_expression '/' cast_expression
			| multiplicative_expression '%' cast_expression
			;


unary_expression
			: postfix_expression
			| unary_operator cast_expression
			;

postfix_expression
			: primary_expression
			| postfix_expression '[' expression ']'
			| postfix_expression '(' ')'
			| postfix_expression '(' argument_expression_list ')'
			;

primary_expression
			: IDENTIFIER
			| CONSTANT
			| STRING
			| '(' expression ')'
			;

argument_expression_list
			: assignment_expression
			| argument_expression_list ',' assignment_expression
			;
expression
			: assignment_expression 
			| expression ',' assignment_expression
			;

assignment_expression
			: or_expression
			| unary_expression '=' assignment_expression
			;


unary_operator
			: '&' 
			| '*' 
			| '+' 
			| '-'
			;

declaration
			: declaration_specifiers ';'
			| declaration_specifiers init_declarator_list ';'
			;

declaration_specifiers
			: type
			| type declaration_specifiers
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
			: IF '(' expression ')' statement %prec LOWER_THAN_ELSE ;
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
#include"lex.yy.c"

//extern char yytext[];
extern int column;

int main(int argc , char *argv[]) {
	// Open a file handle to a particular file:
	FILE *myfile = fopen("sample.ccc", "r");
	// Make sure it is valid:
	if (!myfile) {
		printf("I can't open sample file!");
		return -1;
	}
	// Set Flex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	//yylex();
	//Parse through the input:
	if(!yyparse())
		printf("\nParsing complete\n");
	else{
		printf("\nParsing failed\n");
		exit(0);
	}

}

void yyerror(char const *s){
	fflush(stdout);
	printf("\n%*s\n%*s\n", column, "^", column, s);
}
