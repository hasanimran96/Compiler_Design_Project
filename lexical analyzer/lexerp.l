D		[0-9]
L		[a-zA-Z_]
%option yylineno
%{
#include <stdio.h>
//#include "y.tab.h" Bison file here
int error=0;

void print_token(char*,char*,int);
void count(void);
void comment(void);

%}

%%
"/*"			{ comment(); }
"//"[^\n]*		{ /* consume //-comment */ }

"char" 			{ count(); print_token("CHAR",NULL,0);}
"real" 			{ count(); print_token("REAL",NULL,0);}
"num"			{ count(); print_token("NUM",NULL,0);}
"positive" 		{ count(); print_token("POSITIVE",NULL,0);}
"none"			{ count(); print_token("NONE",NULL,0);}
"stop" 			{ count(); print_token("STOP",NULL,0);}
"go" 			{ count(); print_token("GO",NULL,0);}
"do" 			{ count(); print_token("DO",NULL,0);}
"else" 			{ count(); print_token("ELSE",NULL,0);}
"jump" 			{ count(); print_token("JUMP",NULL,0);}
"if"			{ count(); print_token("IF",NULL,0);}
"end" 			{ count(); print_token("END",NULL,0);}
"loop"			{ count(); print_token("LOOP",NULL,0);}
"size" 			{ count(); print_token("SIZE",NULL,0);}

{L}({L}|{D})*		{ count(); print_token("IDENTIFIER",yytext,1);}
{D}+			{ count(); print_token("NUMBER",yytext,1);}
L?'(\\.|[^\\'\n])+'	{ count(); print_token("CHARACTER",yytext,1);}
{D}*"."{D}+		{ count(); print_token("REALNUMBER",yytext,1);}
{D}+"."{D}*		{ count(); print_token("REALNUMBER",yytext,1);}
L?\"(\\.|[^\\"\n])*\"	{ count(); print_token("STRING",yytext,1);}

"+="			{ count(); print_token(yytext,NULL,0);}
"-="			{ count(); print_token(yytext,NULL,0);}
"*="			{ count(); print_token(yytext,NULL,0);}
"/="			{ count(); print_token(yytext,NULL,0);}
"%="			{ count(); print_token(yytext,NULL,0);}
"&&"			{ count(); print_token(yytext,NULL,0);}
"||"			{ count(); print_token(yytext,NULL,0);}
"<="			{ count(); print_token(yytext,NULL,0);}
">="			{ count(); print_token(yytext,NULL,0);}
"=="			{ count(); print_token(yytext,NULL,0);}
"!="			{ count(); print_token(yytext,NULL,0);}
";"			{ count(); print_token(yytext,NULL,0);}
"{"			{ count(); print_token(yytext,NULL,0);}
"}"			{ count(); print_token(yytext,NULL,0);}
","			{ count(); print_token(yytext,NULL,0);}
":"			{ count(); print_token(yytext,NULL,0);}
"="			{ count(); print_token(yytext,NULL,0);}
"("			{ count(); print_token(yytext,NULL,0);}
")"			{ count(); print_token(yytext,NULL,0);}
"["			{ count(); print_token(yytext,NULL,0);}
"]"			{ count(); print_token(yytext,NULL,0);}
"."			{ count(); print_token(yytext,NULL,0);}
"&"			{ count(); print_token(yytext,NULL,0);}
"!"			{ count(); print_token(yytext,NULL,0);}
"-"			{ count(); print_token(yytext,NULL,0);}
"+"			{ count(); print_token(yytext,NULL,0);}
"*"			{ count(); print_token(yytext,NULL,0);}
"/"			{ count(); print_token(yytext,NULL,0);}
"%"			{ count(); print_token(yytext,NULL,0);}
"<"			{ count(); print_token(yytext,NULL,0);}
">"			{ count(); print_token(yytext,NULL,0);}
[ \t\v]			{ count(); }
[\n\f]			{ count();printf("%d",yylineno); }
. 			{error=1;return yytext[0];}

%%

int yywrap(){}

void comment(void){
	char c, prev = 0;

	while ((c = input()) != 0)      /* (EOF maps to 0) */
	{
		if (c == '/' && prev == '*')
			return;
		prev = c;
	}
	printf("Unterminated comment\n");
	error=1;
}

int column = 0;

void count(void){
	for (int i = 0; yytext[i] != '\0'; i++)
		if (yytext[i] == '\n')
			column = 0;
		else if (yytext[i] == '\t')
			column += 8 - (column % 8);
		else
			column++;
	ECHO;
}

void print_token(char* type, char*text,int chk)
{
	FILE *outfile = fopen("flex_output.txt" , "a");
	if(chk)
		fprintf(outfile , "%s %s\n" , type, text);
	else
		fprintf(outfile , "%s\n",type);
	fclose(outfile);
}

int main(int argc , char *argv[]) {	
	FILE *myfile = fopen(argv[1], "r");
	FILE *outfile = fopen("flex_output.txt" , "w");

	if (!myfile) {
		printf("Input file not found\n");
		return -1;
	}
	yyin = myfile;
	printf("1");
	yylex();
	if(error)
		printf("\nLexical error on Line: %d:%d : %s\n",yylineno,column, yytext);
	else
		printf("\nSuccess! Tokens Generated\n");
	fclose(myfile);
	fclose(outfile);
}
