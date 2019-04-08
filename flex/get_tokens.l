%{

int comm=1; // Comment is off if 1. Comment is on if 0.  
int exhit=0;
int Print_token(char*,char*);

%}
%%



\/\* comm=0; 
\*\/ comm=1;
\/\/  {if(comm) comm=2;}
[\n] {if(comm==2) comm=1;}



[ \t\n]          ;
[0-9]+\.[0-9]+   { 
		    	if(comm%2) Print_token("Float",yytext);
		 }

[0-9]+           {
			if(comm%2) Print_token("Integer",yytext);
		 }

if               {
			if(comm%2) Print_token("keyword",yytext);
		 }

else             {
			if(comm%2) Print_token("Keyword",yytext);
		 }

for              {
			if(comm%2) Print_token("Keyword",yytext);
		 }

int              {
			if(comm%2) Print_token("Keyword",yytext);
		 }

float            {
			if(comm%2) Print_token("Keyword",yytext);
		 }

while            {
			if(comm%2) Print_token("Keyword",yytext);
		 }

"=="             {
			if(comm%2) Print_token("Comparison",yytext);
		 }

"<="             {
			if(comm%2) Print_token("Comparison",yytext);
		 }

">="             {
			if(comm%2) Print_token("Comparison",yytext);
		 }

"<"              {
			if(comm%2) Print_token("Comparison",yytext);
		 }

">"              {
			if(comm%2) Print_token("Comparison",yytext);
		 }

"="              {
			if(comm%2) Print_token("Assignment",yytext);
		 }

[+]              {
			if(comm%2) Print_token("Operator",yytext);
		 }

[-]              {
			if(comm%2) Print_token("Operator",yytext);
		 }

[*]              {
			if(comm%2) Print_token("Operator",yytext);
		 }

[/]              {
			if(comm%2) Print_token("Operator",yytext);
		 }

[{]              {
			if(comm%2) Print_token("Open-bracket",yytext);
		 }

[}]              {
			if(comm%2) Print_token("Close-bracket",yytext);
		 }

[(]              {
			if(comm%2) Print_token("Open-paren",yytext);
		 }

[)]              {
			if(comm%2) Print_token("Close-paren",yytext);
		 }

[;]              {
			if(comm%2) Print_token("Semicolon",yytext);
		 }

[_a-zA-Z0-9]+    {
			if(comm%2) Print_token("Identifier",yytext);

		 }

.                {
		   if(comm%2) exhit=1;
		 }


%%


int Print_token(char* type, char*text)
{
	FILE *outfile = fopen("flex_output.txt" , "a");
	fprintf(outfile , "%s\n",type);
	fprintf(outfile , "%s\n" , text);
	fclose(outfile);
}




int main(int argc , char *argv[]) {	
	FILE *myfile = fopen(argv[1], "r");
	FILE *outfile = fopen("flex_output.txt" , "w");
	// make sure it's valid:
	if (!myfile) {
		printf("Input file not found\n");
		return -1;
	}
	// set lex to read from it instead of defaulting to STDIN:
	yyin = myfile;
	
	// lex through the input:
	yylex();
	if(exhit>0)
		fprintf(stdout,"Syntax error\n");
	else
		fprintf(stdout,"Success\n");
	fclose(myfile);
	fclose(outfile);
}
