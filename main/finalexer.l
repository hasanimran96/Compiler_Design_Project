D		[0-9]
L		[a-zA-Z_]
%option yylineno
%{
#include <stdio.h>
//#include "parser.tab.h" //Bison file here

int error=0;

void print_token(char*,char*,int);
void count(void);
void comment(void);

extern int yylex();
%}

%%
"/*"			{ comment(); }
"//"[^\n]*		{ /* consume //-comment */ }

"char" 			{ count(); return(CHAR);}
"real" 			{ count(); return(REAL);}
"num"			{ count(); return(NUM);}
"positive" 		{ count(); return(POSITIVE);}
"none"			{ count(); return(NONE);}
"stop" 			{ count(); return(STOP);}
"go" 			{ count(); return(GO);}
"do" 			{ count(); return(DO);}
"else" 			{ count(); return(ELSE);}
"jump" 			{ count(); return(JUMP);}
"if"			{ count(); return(IF);}
"end" 			{ count(); return(END);}
"loop"			{ count(); return(LOOP);}

{L}({L}|{D})*		{ count(); return(IDENTIFIER); }
{D}+			{ count(); return(CONSTANT); }
L?'(\\.|[^\\'\n])+'	{ count(); return(CONSTANT); }
{D}*"."{D}+		{ count(); return(CONSTANT); }
{D}+"."{D}*		{ count(); return(CONSTANT); }
L?\"(\\.|[^\\"\n])*\"	{ count(); return(STRING); }

"&&"			{ count(); return(AND); }
"||"			{ count(); return(OR); }
"<="			{ count(); return(LE); }
">="			{ count(); return(GE); }
"=="			{ count(); return(EQUAL); }
";"			{ count(); return(';'); }
"{"			{ count(); return('{'); }
"}"			{ count(); return('}'); }
","			{ count(); return(','); }
"="			{ count(); return('='); }
"("			{ count(); return('('); }
")"			{ count(); return(')'); }
"["			{ count(); return('['); }
"]"			{ count(); return(']'); }
"&"			{ count(); return('&'); }
"-"			{ count(); return('-'); }
"+"			{ count(); return('+'); }
"*"			{ count(); return('*'); }
"/"			{ count(); return('/'); }
"%"			{ count(); return('%'); }
"<"			{ count(); return('<'); }
">" 			{ count(); return('>'); }
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
/*
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
	//FILE *outfile = fopen("flex_output.txt" , "w");

	if (!myfile) {
		printf("Input file not found\n");
		return -1;
	}
	yyin = myfile;
	yylex();
	if(error)
		printf("\nLexical error on Line: %d:%d : %s\n",yylineno,column, yytext);
	else
		printf("\nSuccess! Tokens Generated\n");
	fclose(myfile);
	//fclose(outfile);
}*/
