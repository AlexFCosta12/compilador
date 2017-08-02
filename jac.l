%{

#include <stdio.h>
#include <string.h>
#include "arvore.h"
#include "y.tab.h"
int flag;
int flagYY;
int linha=1;
int coluna=1;
int ini_li=1;
int ini_col=1;
char *texto;
extern int erros;

void envia_linha_coluna (int linha, int coluna, char *texto);


%}
%X COMMETBB COMMET_2 ERRO_STRING
minusculas 		[a-z]
maisculas 		[A-z]
BOOL			"boolean"
BOOLLIT 		"true"|"false"
CLASS			"class"
DO 				"do"
DOTLENGTH		".length"
DOUBLE			"double"
ELSE 			"else"
IF  			"if"
INT 			"int"
PARSEINT 		"Integer.parseInt"
PRINT 			"System.out.println"
PUBLIC 			"public"
RETURN 			"return"
STATIC 			"static"
STRING 			"String"
VOID 			"void"
WHILE 			"while"
OCURV 			"("
CCURV 			")"
OBRACE 			"{"
CBRACE			"}"
OSQUARE 		"["
CSQUARE			"]"
AND 			"&&"
OR 				"||" 
LT 				"<"
GT				">"
EQ 				"=="
NEQ				"!="
LEQ 			"<="
GEQ 			">="
PLUS 			"+"
MINUS 			"-"
STAR 			"*"
DIV 			"/"
MOD 			"%"
NOT 			"!"
ASSIGN 			"="
SEMI 			";"
COMMA 			","
ESCAPE 			\\n|\\t|\\f|\\r|\\\\|\\\"
DIGITO 			[0-9]+("_"+[0-9]+)*
RESERVED		"++"|"--"|"null"|"abstract"|"assert"|"break"|"byte"|"case"|"catch"|"char"|"const"|"continue"|"default"|"enum"|"extends"|"final"|"finally"|"float"|"for"|"goto"|"implements"|"import"|"instanceof"|"interface"|"long"|"native"|"new"|"package"|"private"|"protected"|"short"|"strictfp"|"super"|"switch"|"synchronized"|"this"|"throw"|"throws"|"transient"|"try"|"volatile"|"Integer"|"System"
ID				("_"|"$"|[a-z]|[A-Z])+("_"|"$"|[a-z]|[A-Z]|[0-9])*
NUMBERS			([0-9]|"_")*
NUMBERS2		[0-9]+({NUMBERS}[0-9])*
DECLIT			0|([1-9]({NUMBERS}{NUMBERS2})*)		
ASPAS			\"
STRLIT			([^\\\n\r\"]|{ESCAPE})*
REALLIT			({NUMBERS2}"."({NUMBERS2}|("E"|"e")("+"|"-")?{NUMBERS2}|{NUMBERS2}("E"|"e")("+"|"-")?{NUMBERS2})?)|("."{NUMBERS2}(("E"|"e")("+"|"-")?{NUMBERS2})?)|({NUMBERS2}("E"|"e")("+"|"-")?{NUMBERS2})
%%

{BOOL} 			{if (flag ==1) printf("BOOL\n");coluna+=yyleng; if (flag == -1){envia_linha_coluna(linha,coluna,strdup (yytext)); return BOOL;}}
{BOOLLIT} 		{if (flag ==1) printf("BOOLLIT(%s)\n",yytext);coluna+=yyleng; if (flag == -1){envia_linha_coluna(linha,coluna,strdup (yytext)); return BOOLLIT;}}
{CLASS}			{if (flag ==1) printf("CLASS\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return CLASS;}}
{DO}			{if (flag ==1) printf("DO\n");coluna+=yyleng; if (flag == -1){envia_linha_coluna(linha,coluna,strdup (yytext)); return DO;}}
{DOTLENGTH}		{if (flag ==1) printf("DOTLENGTH\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return DOTLENGTH;}}
{DOUBLE}		{if (flag ==1) printf("DOUBLE\n");coluna+=yyleng; if (flag == -1){envia_linha_coluna(linha,coluna,strdup (yytext)); return DOUBLE;}}
{ELSE}			{if (flag ==1) printf("ELSE\n");coluna+=yyleng; if (flag == -1){envia_linha_coluna(linha,coluna,strdup (yytext));return ELSE;}}
{IF}			{if (flag ==1) printf("IF\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return IF;}}
{INT}			{if (flag ==1) printf("INT\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return INT;}}
{PARSEINT}		{if (flag ==1) printf("PARSEINT\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return PARSEINT;}}
{PRINT}			{if (flag ==1) printf("PRINT\n");coluna+=yyleng; if (flag == -1){envia_linha_coluna(linha,coluna,strdup (yytext)); return PRINT;}}
{PUBLIC}		{if (flag ==1) printf("PUBLIC\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return PUBLIC;}}
{RETURN}		{if (flag ==1) printf("RETURN\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return RETURN;}}
{STATIC}		{if (flag ==1) printf("STATIC\n");coluna+=yyleng; if (flag == -1){envia_linha_coluna(linha,coluna,strdup (yytext)); return STATIC;}}
{STRING}		{if (flag ==1) printf("STRING\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext));return STRING;}}
{VOID}			{if (flag ==1) printf("VOID\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return VOID;}}
{WHILE}			{if (flag ==1) printf("WHILE\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return WHILE;}}
{OCURV}			{if (flag ==1) printf("OCURV\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return OCURV;}}
{CCURV}			{if (flag ==1) printf("CCURV\n");coluna+=yyleng; if (flag == -1){envia_linha_coluna(linha,coluna,strdup (yytext)); return CCURV;}}
{OBRACE}		{if (flag ==1) printf("OBRACE\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return OBRACE;}}
{CBRACE}		{if (flag ==1) printf("CBRACE\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return CBRACE;}}
{OSQUARE}		{if (flag ==1) printf("OSQUARE\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return OSQUARE;}}
{CSQUARE}		{if (flag ==1) printf("CSQUARE\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return CSQUARE;}}
{AND}			{if (flag ==1) printf("AND\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return AND;}}
{OR}			{if (flag ==1) printf("OR\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return OR;}}
{LT}			{if (flag ==1) printf("LT\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return LT;}}
{GT}			{if (flag ==1) printf("GT\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return GT;}}
{EQ}			{if (flag ==1) printf("EQ\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return EQ;}}
{NEQ}			{if (flag ==1) printf("NEQ\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return NEQ;}}
{LEQ}			{if (flag ==1) printf("LEQ\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return LEQ;}}
{GEQ}			{if (flag ==1) printf("GEQ\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return GEQ;}}
{PLUS}			{if (flag ==1) printf("PLUS\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return PLUS;}}
{MINUS}			{if (flag ==1) printf("MINUS\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return MINUS;}}
{STAR}			{if (flag ==1) printf("STAR\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return STAR;}}
{DIV}			{if (flag ==1) printf("DIV\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return DIV;}}
{MOD}			{if (flag ==1) printf("MOD\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return MOD;}}
{NOT}			{if (flag ==1) printf("NOT\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return NOT;}}
{ASSIGN}		{if (flag ==1) printf("ASSIGN\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return ASSIGN;}}
{SEMI}			{if (flag ==1) printf("SEMI\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return SEMI;}}
{COMMA}			{if (flag ==1) printf("COMMA\n");coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return COMMA;}}
{RESERVED}		{if (flag ==1) printf("RESERVED(%s)\n",yytext);coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return RESERVED;}}
{ID}			{if (flag ==1) printf("ID(%s)\n",yytext);coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return ID;}}
{DECLIT}		{if (flag ==1) printf("DECLIT(%s)\n",yytext);coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return DECLIT;}}
{REALLIT}		{if (flag ==1) printf("REALLIT(%s)\n",yytext);coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return REALLIT;}}
" "				{coluna+=yyleng;}
\f 				{coluna+=yyleng;}
\t 				{coluna+=yyleng;}
\n				{linha++;coluna=1;}
\r 				{linha++;coluna=1;}
\r\n 			{linha++;coluna=1;}

"/*"									{BEGIN COMMET_2;ini_li=linha; ini_col=coluna;coluna +=yyleng;}
<COMMET_2>"*/"							{BEGIN 0;coluna+=yyleng;}
<COMMET_2><<EOF>>						{BEGIN 0;printf("Line %d, col %d: unterminated comment\n",ini_li,ini_col);if (flag==-1){return 0;}}
<COMMET_2>"\n"|"\r"|"\r\n"				{linha++;coluna=1;}
<COMMET_2>.								{coluna+=yyleng;}

"//"									{BEGIN COMMETBB;coluna+=yyleng;}
<COMMETBB>"\n"|"\r"|"\r\n"				{BEGIN 0;linha++;coluna=1;}
<COMMETBB><<EOF>> 						{if(flag==-1) return 0;}
<COMMETBB>.								{coluna+=yyleng;}


{ASPAS}{STRLIT}{ASPAS}					{if (flag ==1) printf("STRLIT(%s)\n",yytext);coluna+=yyleng; if (flag == -1){ envia_linha_coluna(linha,coluna,strdup (yytext)); return STRLIT;}}
\"										{BEGIN ERRO_STRING;ini_li=linha; ini_col=coluna;coluna +=yyleng;}
<ERRO_STRING>{STRLIT}					{coluna+=yyleng;}
<ERRO_STRING>\n|\r|\r\n 				{BEGIN 0;printf("Line %d, col %d: unterminated string literal\n",ini_li,ini_col);linha++;coluna=1;}
<ERRO_STRING>\\(.?)						{printf("Line %d, col %d: invalid escape sequence (%s)\n",linha,coluna,yytext);coluna+=yyleng;}
<ERRO_STRING>\"							{BEGIN 0;coluna+=yyleng;}
<ERRO_STRING><<EOF>>					{BEGIN 0;printf("Line %d, col %d: unterminated string literal\n",ini_li,ini_col);if (flag == -1){return 0;}}
<<EOF>> 								{return 0;}
.				{printf("Line %d, col %d: illegal character (%s)\n",linha,coluna,yytext);coluna+=yyleng;}
%%
int yywrap() {
    return 1;
}
void yyerror (const char *s) {
int coluna_erro = (int) coluna -strlen(yytext);
 printf ("Line %d, col %d: %s: %s\n", linha, coluna_erro, s, yytext);
}
void meteFlag(){
	flagYY = 2;
}
void envia_linha_coluna (int linha, int coluna, char *texto){
	no *aux= (no*)malloc(sizeof(no));
	aux ->linha = linha;
	aux ->coluna = coluna;
	aux->string = texto;

	yylval.valor = aux;
}
int main(int argc,char *argv[])
{
flag =0;
if (argc>1){
	//printf("Numero de argumentos errado");
	//return 0;
	if((strcmp(argv[1],"-l")==0)){
		flag =1;
		yylex();
	}else if (strcmp(argv[1],"-1")==0){
		yylex();
	}else if (strcmp(argv[1],"-t")==0){
		flag =-1;
		meteFlag();
		yyparse();
		if (erros ==0){
			print_node(Arvore,0);
		}
	}else if (strcmp(argv[1],"-2")==0){
		flag=-1;
		meteFlag();
		yyparse();
	}else if (strcmp(argv[1],"-s")==0){
		flag =-1;
		meteFlag();
		yyparse();
		tabela = inicia_tabela();
		Preenche_tabelas(Arvore,tabela);
		if (erros ==0){
			print(tabela);
			print_arvore_final(Arvore,0);
			
		}
	}
}else{
	flag =-1;
	yyparse();
}
return 0;
}
