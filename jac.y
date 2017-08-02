%{
#include <stdio.h>
#include <string.h>
#include "arvore.h"
int yylex(void);
void yyerror (const char *s);
extern int flagYY;
int erros =0;
char tipo[6];
%}

%union {
   struct no* valor;
   struct node *node;
}
%type <node> ReturnAux STRINGaux MethodInvocationAB Expr4 Expr3 FieldDeclIDAux STRLITaux VarDeclB VarDeclC Expraux VOIDaux IDaux Program ProgramL FieldDecl FieldDeclL MethodDecl MethodHeader MethodBody MethodBodyA FormalParams FormalParamsA VarDecl Type Statement StatementA Assignment MethodInvocation MethodInvocationA ParseArgs Expr FormalParamsB FormalParamsC 
%token <valor> STRING AND OR LT GT EQ NEQ LEQ GEQ PLUS MINUS STAR DIV MOD NOT DOTLENGTH PARSEINT
%token VOID STATIC RETURN PUBLIC PRINT INT IF ELSE DOUBLE DO CLASS BOOL WHILE OCURV CCURV OBRACE CBRACE OSQUARE CSQUARE ASSIGN SEMI COMMA
%token <valor> ID
%token <valor> STRLIT
%token <valor> DECLIT
%token <valor> REALLIT
%token <valor> BOOLLIT
%token <valor> RESERVED

%left ID
%left COMMA
%right ASSIGN
%left OR
%left AND
%left EQ NEQ
%left GT LT GEQ LEQ
%left PLUS MINUS
%left STAR DIV MOD
%right NOT
%left OCURV CCURV OSQUARE CSQUARE
%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%%

Program: CLASS IDaux OBRACE ProgramL CBRACE 	{if (flagYY == 2) $$ = Arvore = cria_Insere_node("Program",1,2,$2,$4);}
ProgramL: FieldDecl ProgramL				{if (flagYY == 2) $$ = cria_Insere_node("ProgramL",0,2,$1,$2);}
| MethodDecl ProgramL						{if (flagYY == 2) $$ = cria_Insere_node("ProgramL",0,2,$1,$2);}
| SEMI ProgramL								{if (flagYY == 2) $$ = cria_Insere_node("ProgramL",0,1,$2);}
|											{if (flagYY == 2) $$ = create_node_terminal("ProgramL",0,NULL);}

FieldDecl: PUBLIC STATIC Type FieldDeclIDAux FieldDeclL SEMI	{if (flagYY == 2) $$ = cria_Insere_node("FieldDecl",0,2,$4,$5);}
| error SEMI													{ $$ = create_node_terminal("ERROR",0,NULL); if (flagYY == 2){ erros ++; }}
FieldDeclL: COMMA FieldDeclIDAux FieldDeclL						{if (flagYY == 2) $$=cria_Insere_node("FieldDeclL",0,2,$2,$3);}
|																{if (flagYY == 2) $$=create_node_terminal("FieldDeclL",0,NULL);}
FieldDeclIDAux: IDaux 											{if (flagYY ==2){ $$=cria_Insere_node("FieldDecl",1,2,create_node_terminal(tipo,1,NULL),$1);}}
MethodDecl: PUBLIC STATIC MethodHeader MethodBody 	{if (flagYY == 2) $$ = cria_Insere_node("MethodDecl",1,2,$3,$4);}
MethodHeader: Type IDaux OCURV FormalParams CCURV	{if (flagYY == 2) $$ = cria_Insere_node("MethodHeader",1,3,$1,$2,cria_Insere_node("MethodParams",1,1,$4));}
| VOIDaux IDaux OCURV FormalParams CCURV			{if (flagYY == 2) $$ = cria_Insere_node("MethodHeader",1,3,$1,$2,cria_Insere_node("MethodParams",1,1,$4));}
| Type IDaux OCURV CCURV							{if (flagYY == 2) $$ = cria_Insere_node("MethodHeader",1,3,$1,$2,create_node_terminal("MethodParams",1,NULL));}
| VOIDaux IDaux OCURV CCURV							{if (flagYY == 2) $$ = cria_Insere_node("MethodHeader",1,3,$1,$2,create_node_terminal("MethodParams",1,NULL));}
|													{if (flagYY == 2) $$ = create_node_terminal("MethodHeader",0,NULL);}
MethodBody: OBRACE MethodBodyA CBRACE				{if (flagYY == 2) {$$ = cria_Insere_node("MethodBody",1,1,$2);}}
MethodBodyA: VarDecl MethodBodyA					{if (flagYY == 2) {$$ = cria_Insere_node("MethodBodyA",0,2,$1,$2);}}
| Statement MethodBodyA								{if (flagYY == 2) {$$ = cria_Insere_node("MethodBodyA",0,2,$1,$2);}}
| 													{if (flagYY == 2) $$ = create_node_terminal("MethodBodyA",0,NULL);}
FormalParams: FormalParamsA FormalParamsC 			{if (flagYY == 2) $$ = cria_Insere_node("MethodParams",0,2,$1,$2);}
| FormalParamsB		 								{if (flagYY == 2) $$ = cria_Insere_node("MethodParams",0,1,$1);}
FormalParamsA: Type IDaux 							{if (flagYY == 2) $$ = cria_Insere_node("ParamDecl",1,2,$1,$2);}
FormalParamsB: STRINGaux OSQUARE CSQUARE IDaux		{if (flagYY == 2) $$ = cria_Insere_node("ParamDecl",1,2,$1,$4);}
FormalParamsC: COMMA FormalParamsA FormalParamsC	{if (flagYY == 2) $$ = cria_Insere_node("ParamDecl",0,2,$2,$3);}
|													{if (flagYY == 2) $$ = create_node_terminal("ParamDecl",0,NULL);}
VarDecl:  Type VarDeclC VarDeclB SEMI				{if (flagYY == 2) $$ = cria_Insere_node("VarDecl",0,2,$2,$3);}
VarDeclB: COMMA VarDeclC VarDeclB					{if (flagYY == 2) $$ = cria_Insere_node("VarDecl",0,2,$2,$3);}
|													{if (flagYY == 2) $$ = cria_Insere_node("VarDecl",0,0,NULL);}
VarDeclC: IDaux										{if (flagYY == 2) $$ = cria_Insere_node("VarDecl",1,2,create_node_terminal(tipo,1,NULL),$1);}
Type: BOOL 											{strcpy (tipo,"Bool");if (flagYY == 2) $$ = create_node_terminal("Bool",1,NULL);}
| INT 												{strcpy(tipo,"Int"); if (flagYY == 2) $$ = create_node_terminal("Int",1,NULL);}
| DOUBLE											{strcpy (tipo,"Double");if (flagYY == 2) $$ = create_node_terminal("Double",1,NULL);}
Statement: OBRACE StatementA CBRACE							{if (flagYY == 2){if ($2->n_filhos>1) $2 = cria_Insere_node("Block",1,1,$2); $$ = cria_Insere_node($2->tipo,0,1,$2);}}
| IF OCURV Expr CCURV Statement  %prec LOWER_THAN_ELSE		{if (flagYY ==2) {if ($5->n_filhos == 0 ) $$=cria_Insere_node("If",0,1,cria_Insere_node("If",1,3,$3,create_node_terminal("Block",1,NULL),create_node_terminal("Block",1,NULL))); else if ($5->n_filhos==1) $$=cria_Insere_node("If",0,1,cria_Insere_node("If",1,3,$3,$5,create_node_terminal("Block",1,NULL)));else if ($5->n_filhos>1) $$ = cria_Insere_node("If",0,1,cria_Insere_node("If",1,3,$3,cria_Insere_node("Block",1,1,$5),create_node_terminal("Block",1,NULL)));}}
| IF OCURV Expr CCURV Statement ELSE Statement 				{if (flagYY ==2) {if ($5->n_filhos!=1) $5 = cria_Insere_node("Block",1,1,$5); if ($7->n_filhos!=1) $7 = cria_Insere_node("Block",1,1,$7); $$ = cria_Insere_node("If",0,1,cria_Insere_node("If",1,3,$3,$5,$7));}}
| WHILE OCURV Expr CCURV Statement							{if (flagYY ==2) {if ($5->n_filhos !=1) $$=cria_Insere_node("aux",0,1,cria_Insere_node("While",1,2,$3,cria_Insere_node("Block",1,1,$5)));else $$ = cria_Insere_node("aux",0,1,cria_Insere_node("While",1,2,$3,$5));}}
| DO Statement WHILE OCURV Expr CCURV SEMI					{if (flagYY ==2) {if ($2->n_filhos !=1) $$=cria_Insere_node("aux",0,1,cria_Insere_node("DoWhile",1,2,cria_Insere_node("Block",1,1,$2),$5)); else $$ = cria_Insere_node("aux",0,1,cria_Insere_node("DoWhile",1,2,$2,$5));}}
| PRINT OCURV Expr CCURV SEMI								{if (flagYY == 2) {$$=junta_linha_coluna($3->valor,cria_Insere_node("Print",1,1,$3));}}
| PRINT OCURV STRLITaux CCURV SEMI							{if (flagYY==2) {$$=cria_Insere_node("Print",1,1,$3);}}
| Assignment SEMI											{if (flagYY == 2) {$$ = cria_Insere_node("Assignment",0,1,$1);}}
| MethodInvocation SEMI										{if (flagYY == 2) {$$ = cria_Insere_node("Call",0,1,$1);}}
| ParseArgs SEMI											{if (flagYY == 2) {$$ = cria_Insere_node("ParseArgs",0,1,$1);}}
| SEMI														{if (flagYY == 2) $$ = create_node_terminal("termina",0,NULL);}
| RETURN Expr SEMI											{if (flagYY == 2) $$ = cria_Insere_node("Return",1,1,$2);}
| ReturnAux SEMI												{if (flagYY == 2) $$ = cria_Insere_node("Return",0,1,$1);}
| error SEMI												{$$ = create_node_terminal("ERROR",0,NULL); if (flagYY == 2){ erros ++;}}
ReturnAux: RETURN 											{if (flagYY==2) $$= create_node_terminal("Return",1,NULL);}
StatementA: Statement StatementA							{if (flagYY==2) $$= cria_Insere_node($1->tipo,0,2,$1,$2);}
|															{if (flagYY == 2) $$ = create_node_terminal("vazio",0,NULL);}
Assignment: IDaux ASSIGN  Expr								{if (flagYY == 2) $$ = cria_Insere_node("Assign",1,2,$1,$3);}
MethodInvocation: IDaux OCURV MethodInvocationAB CCURV						{if (flagYY == 2) $$ = cria_Insere_node("Call",1,2,$1,$3);}
| IDaux OCURV error CCURV									{ $$ = create_node_terminal("ERROR",0,NULL); if (flagYY == 2){ erros ++;}} 
MethodInvocationA: COMMA Expr MethodInvocationA				{if (flagYY == 2) $$ = cria_Insere_node("MethodInvocationA",0,2,$2,$3);}
| 															{if (flagYY == 2) $$ = create_node_terminal("MethodInvocationA",0,NULL);}
MethodInvocationAB: Expr MethodInvocationA 					{if (flagYY==2) $$ = cria_Insere_node("MethodInvocationAB",0,2,$1,$2);}
| 															{if (flagYY ==2) $$ = create_node_terminal("MethodInvocationAB",0,NULL);}
ParseArgs: PARSEINT OCURV IDaux OSQUARE Expr CSQUARE CCURV	{if (flagYY == 2) $$ = junta_linha_coluna($1,cria_Insere_node("ParseArgs",1,2,$3,$5));}
| PARSEINT OCURV error CCURV								{ $$ = create_node_terminal("ERROR",0,NULL); if (flagYY == 2){ erros ++;}}
Expr: Assignment											{if (flagYY==2) $$ = cria_Insere_node("Assign",0,1,$1);}
| Expraux													{if (flagYY==2) $$ = cria_Insere_node("Expraux",0,1,$1);}
Expraux: Expr3												{if (flagYY==2) $$ = $1;}
| Expraux AND Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("And",1,2,$1,$3));}
| Expraux OR Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Or",1,2,$1,$3));}
| Expraux EQ Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Eq",1,2,$1,$3));}
| Expraux GEQ Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Geq",1,2,$1,$3));}
| Expraux GT Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Gt",1,2,$1,$3));}
| Expraux LEQ Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Leq",1,2,$1,$3));}
| Expraux LT Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Lt",1,2,$1,$3));}
| Expraux NEQ Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Neq",1,2,$1,$3));}
| Expraux PLUS Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Add",1,2,$1,$3));}
| Expraux MINUS Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Sub",1,2,$1,$3));}
| Expraux STAR Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Mul",1,2,$1,$3));}
| Expraux DIV Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Div",1,2,$1,$3));}
| Expraux MOD Expraux										{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Mod",1,2,$1,$3));}
| PLUS Expraux						%prec NOT				{if (flagYY == 2) $$ = junta_linha_coluna($1,cria_Insere_node("Plus",1,1,$2));}
| MINUS Expraux						%prec NOT				{if (flagYY == 2) $$ = junta_linha_coluna($1,cria_Insere_node("Minus",1,1,$2));}
| NOT Expraux												{if (flagYY == 2) $$ = junta_linha_coluna($1,cria_Insere_node("Not",1,1,$2));}
| IDaux 													{$$ = $1;}
| IDaux DOTLENGTH											{if (flagYY == 2) $$ = junta_linha_coluna($2,cria_Insere_node("Length",1,1,$1));}
| OCURV Expr CCURV											{if (flagYY == 2) $$ = cria_Insere_node("Expr",0,1,$2);}
| Expr4 													{if (flagYY==2) $$ = cria_Insere_node("Expr4",0,1,$1);}
| OCURV error  CCURV										{$$ = create_node_terminal("ERROR",0,NULL); if (flagYY == 2){ erros ++;}}
Expr3: MethodInvocation 									{if (flagYY==2) $$ = cria_Insere_node("MethodInvocation",0,1,$1);}
| ParseArgs													{if (flagYY==2) $$ = cria_Insere_node("ParseArgs",0,1,$1);}
Expr4: BOOLLIT												{if (flagYY == 2) $$ = junta_linha_coluna($1,create_node_terminal("BoolLit",1,$1->string));}
| DECLIT													{if (flagYY == 2) $$ = junta_linha_coluna($1,create_node_terminal("DecLit",1,$1->string));}
| REALLIT													{if (flagYY == 2) $$ = junta_linha_coluna($1,create_node_terminal("RealLit",1,$1->string));}
IDaux: ID 													{if (flagYY == 2) $$ = junta_linha_coluna($1,create_node_terminal("Id",1,$1->string));}
VOIDaux: VOID 												{if (flagYY == 2) $$ = create_node_terminal("Void",1,NULL);}
STRINGaux: STRING 											{if (flagYY == 2) $$ = junta_linha_coluna($1,create_node_terminal("StringArray",1,NULL));}
STRLITaux: STRLIT 											{if (flagYY == 2) $$ = junta_linha_coluna($1,create_node_terminal("StrLit",1,$1->string));}
%%