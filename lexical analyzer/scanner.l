D		[0-9]
L		[a-zA-Z_]
FS		(f|F|l|L)
IS		((u|U)|(u|U)?(l|L|ll|LL)|(l|L|ll|LL)(u|U))

%{
#include <stdio.h>
//#include "y.tab.h" Bison file here

void count(void);
void comment(void);

%}

%%
"/*"			{ comment(); }
"//"[^\n]*  		{ /* consume //-comment */ }

"char" 			{ count(); return(CHAR);}
"real" 			{ count(); return REAL;}
"num"			{ count(); return NUM;}
"positive" 		{ count(); return POSITIVE;}
"none"			{ count(); return NONE;}
"stop" 			{ count(); return STOP;}
"go" 			{ count(); return GO;}
"do" 			{ count(); return DO;}
"else" 			{ count(); return ELSE:}
"jump" 			{ count(); return JUMP;}
"if"			{ count(); return IF;}
"end" 			{ count(); return END;}
"loop"			{ count(); return LOOP;}
"size" 			{ count(); return SIZE;}

{L}({L}|{D})*		{ count(); return(IDENTIFIER); }

[1-9]{D}*{IS}?		{ count(); return(CONSTANT); }
L?'(\\.|[^\\'\n])+'	{ count(); return(CONSTANT); }

{D}*"."{D}+{FS}?	{ count(); return(CONSTANT); }
{D}+"."{D}*{FS}?	{ count(); return(CONSTANT); }

L?\"(\\.|[^\\"\n])*\"	{ count(); return(STRING_LITERAL); }

"+="			{ count(); return(ADD_ASSIGN); }
"-="			{ count(); return(SUB_ASSIGN); }
"*="			{ count(); return(MUL_ASSIGN); }
"/="			{ count(); return(DIV_ASSIGN); }
"%="			{ count(); return(MOD_ASSIGN); }
"&&"			{ count(); return(AND_OP); }
"||"			{ count(); return(OR_OP); }
"<="			{ count(); return(LE_OP); }
">="			{ count(); return(GE_OP); }
"=="			{ count(); return(EQ_OP); }
"!="			{ count(); return(NE_OP); }
";"			{ count(); return(';'); }
"{"			{ count(); return('{'); }
"}"			{ count(); return('}'); }
","			{ count(); return(','); }
":"			{ count(); return(':'); }
"="			{ count(); return('='); }
"("			{ count(); return('('); }
")"			{ count(); return(')'); }
"["			{ count(); return('['); }
"]"			{ count(); return(']'); }
"."			{ count(); return('.'); }
"&"			{ count(); return('&'); }
"!"			{ count(); return('!'); }
"-"			{ count(); return('-'); }
"+"			{ count(); return('+'); }
"*"			{ count(); return('*'); }
"/"			{ count(); return('/'); }
"%"			{ count(); return('%'); }
"<"			{ count(); return('<'); }
">"			{ count(); return('>'); }

[ \t\v\n\f]		{ count(); }
. 			return yytext[0];{} /*{Add code to complain about unmatched characters }*/

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
	printf("unterminated comment");//error("unterminated comment");
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

int main(){ 
	// yywrap() - wraps the above rule section 
	/* yyin - takes the file pointerwhich contains the input*/
	/* yylex() - this is the main flex function	which runs the Rule Section*/
	// yytext is the text in the buffer 

	FILE *fp; 
	char filename[50]; 
	printf("Enter filename: \n"); 
	scanf("%s",filename); 
	fp = fopen(filename,"r"); 
	yyin = fp; 
	yylex(); 

	return 0; 
} 
