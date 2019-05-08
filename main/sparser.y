%{
#include <stdio.h>
#include <stdlib.h>

extern FILE *fp;
FILE * f1;

%}
%define parse.error verbose

%token IDENTIFIER CONSTANT STRING
%token CHAR REAL NUM NONE
%token STOP GO DO JUMP IF END LOOP

%right '='

%left AND OR 
%left EQUAL
%left LE GE '<' '>'
%left '+' '-' 
%left '*' '/' 

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE

%start begin_declaration

%%

begin_declaration		: type IDENTIFIER '(' ')' compound_statement
				;

compound_statement		: '{' statement_list '}'|
				;

statement_list			: statement_list statement
				| statement
				;

statement			: statement_declare    //all types of statements
				| statement_assignment  
				| statement_condition
				| statement_iteration
				| statement_jump
				| ';'
				;
expression			: statement_assignment 
				| expression ',' statement_assignment
				;
				;
				
statement_assignment		: or_expression
				| primary_expression '='{push();} statement_assignment {assign();}
				;
		
or_expression			: and_expression
				| or_expression OR{push();} and_expression {logical();}
				;

and_expression			: equality_expression
				| and_expression AND{push();} equality_expression {logical();}
				;

equality_expression		: relational_expression
				| equality_expression EQUAL{push();} relational_expression {logical();}
				;

relational_expression		: additive_expression
				| relational_expression '<'{push();} additive_expression {logical();}
				| relational_expression '>'{push();} additive_expression {logical();}
				| relational_expression LE {push();} additive_expression {logical();}
				| relational_expression GE {push();} additive_expression {logical();}
				;

additive_expression		: multiplicative_expression
				| additive_expression '+'{push();} multiplicative_expression {algebric();}
				;

multiplicative_expression	: primary_expression
				| multiplicative_expression '*'{push();} primary_expression {algebric();}
				| multiplicative_expression '/'{push();} primary_expression {algebric();}
				| multiplicative_expression '%'{push();} primary_expression {algebric();}
				;

primary_expression		: IDENTIFIER{check();push();}
				| CONSTANT{push();}
				| STRING{push();}
				| '(' expression ')'
				;

statement_condition		: IF '(' expression ')' {if_label1();} compound_statement statement_else
				;

statement_else			: ELSE {if_label2();} compound_statement {if_label3();}
				| {if_label3();}
				;

statement_iteration		: {loop_start();} LOOP '(' expression ')' {loop_rep();} compound_statement {loop_end();}
				| {loop_start();} DO compound_statement LOOP '(' expression ')'{loop_rep();} ';'{loop_end();}
				;

statement_declare 		: type {setType();}  IDENTIFIER {declare();} identifiers_list   //setting type for that line
				;

statement_jump			: JUMP IDENTIFIER ';'
				| GO ';'
				| STOP ';'{loop_break();}
				| END ';'
				| END expression ';'
				;

identifiers_list		: ';'
				| ','  IDENTIFIER {declare();} identifiers_list 
				;

type				: NUM
				| NONE
				| REAL
				| CHAR
				;

%%

#include"lex.yy.c"
#include <ctype.h>
int top=0,i=0,ltop=0,lnum=0,stop=0,tableCount=0;

int label[200];//array to store labels for jumping in code

char st[1000][10];//variable stack for ts (register variables)
char temp[2]="t";

char type[10];//variable type

struct Table{
	char id[20];
	char type[10];
}table[10000]; //Symbol Table


int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	f1=fopen("output","w");
	
	if(!yyparse())	printf("\nParsing complete\n");
	else{
		printf("\nParsing failed\n");
		exit(0);
	}
	fclose(yyin);
	fclose(f1);
	generateAssembly();
	return 0;
}
         
yyerror(char *s) {
	printf("\nSyntax Error on line: %d : %s %s\n", yylineno, s, yytext );
}
    
push(){
  	strcpy(st[++top],yytext);
}

logical(){
 	sprintf(temp,"$t%d",i);
  	fprintf(f1,"%s\t=\t%s\t%s\t%s\n",temp,st[top-2],st[top-1],st[top]);
  	top-=2;
 	strcpy(st[top],temp);
 	i++;
}

algebric(){
 	sprintf(temp,"$t%d",i); // converts temp to reqd format
  	fprintf(f1,"%s\t=\t%s\t%s\t%s\n",temp,st[top-2],st[top-1],st[top]);
  	top-=2;
 	strcpy(st[top],temp);
 	i++;
}
assign(){
 	fprintf(f1,"%s\t=\t%s\n",st[top-2],st[top]);
 	top-=3;
}
 
if_label1(){
 	lnum++;
 	fprintf(f1,"\tif( not %s)",st[top]);
 	fprintf(f1,"\tgoto $L%d\n",lnum);
 	label[++ltop]=lnum;
}

if_label2(){
	int x;
	lnum++;
	x=label[ltop--]; 
	fprintf(f1,"\t\tgoto $L%d\n",lnum);
	fprintf(f1,"$L%d: \n",x); 
	label[++ltop]=lnum;
}

if_label3(){
	int y;
	y=label[ltop--];
	fprintf(f1,"$L%d: \n",y);
	top--;
}
loop_start(){
	lnum++;
	label[++ltop]=lnum;
	fprintf(f1,"$L%d:\n",lnum);
}
loop_rep(){
	lnum++;
 	fprintf(f1,"if( not %s)",st[top]);
 	fprintf(f1,"\tgoto $L%d\n",lnum);
 	label[++ltop]=lnum;
}
loop_end(){
	int x,y;
	y=label[ltop--];
	x=label[ltop--];
	fprintf(f1,"\t\tgoto $L%d\n",x);
	fprintf(f1,"$L%d: \n",y);
	top--;
}
loop_break()
{	//FIX THIS
	fprintf(f1,"\t\tgoto $L%d\n",label[ltop-1]);
}
/* for symbol table*/

check(){
	char temp[20];
	strcpy(temp,yytext);
	int flag=0;
	for(i=0;i<tableCount;i++){
		if(!strcmp(table[i].id,temp)){
			flag=1;
			break;
		}
	}
	if(!flag){
		yyerror("Variable not declard");
		exit(0);
	}
}

setType(){
	strcpy(type,yytext);
}


declare()
{
	char temp[20];
	int i,flag;
	flag=0;
	strcpy(temp,yytext);
	for(i=0;i<tableCount;i++){
		if(!strcmp(table[i].id,temp)){
			flag=1;
			break;
		}
	}
	if(flag){
		yyerror("redeclare of ");
		exit(0);
	}
	else{
		strcpy(table[tableCount].id,temp);
		strcpy(table[tableCount].type,type);
		tableCount++;
	}
}

generateAssembly()
{
	int Labels[100000];
	char buf[100];
	f1=fopen("output","r");
	int flag=0,lineno=1;
	memset(Labels,0,sizeof(Labels));
	while(fgets(buf,sizeof(buf),f1)!=NULL){
		if(buf[0]=='$'&&buf[1]=='$'&&buf[2]=='L'){
			int k=atoi(&buf[3]);
			Labels[k]=lineno;
		}
		else	lineno++;
	}
	fclose(f1);
	f1=fopen("output","r");
	lineno=0;

	printf("\n\n\n----------------------Three Address Code--------------------\n\n");
	while(fgets(buf,sizeof(buf),f1)!=NULL){
		if(buf[0]=='$'&&buf[1]=='$'&&buf[2]=='L'){;}
		else{
			flag=0;
			lineno++;
			printf("%3d:\t",lineno);
			int len=strlen(buf),i,flag1=0;
			for(i=len-3;i>=0;i--){
				if(buf[i]=='$'&&buf[i+1]=='$'&&buf[i+2]=='L'){
					flag1=1;
					break;
				}
			}
			if(flag1){
				buf[i]=='\0';
				int k=atoi(&buf[i+3]),j;
				//printf("%s",buf);
				for(j=0;j<i;j++)
					printf("%c",buf[j]);
				printf(" %d\n",Labels[k]);
			}
			else printf("%s",buf);
		}
	}
	printf("%3d:\tend\n",++lineno);
	fclose(f1);
}
