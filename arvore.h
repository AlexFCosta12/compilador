#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
typedef struct no{
	char *string;
	int linha;
	int coluna;
}no;

typedef struct node {
	char* tipo;
	void* valor;
	int n_filhos;
	int usado;
	char *ArvTipo;
	no* estrutura;
	struct node** filho;
} node;
node* Arvore;
node *novo_node (char *tipo, void *valor,int n_filhos,int usado);
node *junta_linha_coluna (no *add, node* noAdd);
node *create_node_terminal (char* tipo, int usado, void* valor);
node *cria_Insere_node(char *tipo, int usado, int n_filhos,...);
node* cria_ifelse(node* a, node* b, node* c);
void print_node(node* n, int depth);

/*semantic*/
typedef struct FormalParams
{
	char *tipo;
	char * valor;
	struct FormalParams *next;
 
}FormalParams;

typedef struct simbolos
{
	char *tipo;
	char *nome;
	int flag; // se tiver a 0 não tem Parametros
	struct FormalParams *ParametrosFunc;
	struct simbolos *next;
}simbolos;

typedef struct tabela_Simbolos
{
	struct simbolos* simboloAt;
	char* nome;
	char* tipo;
	struct FormalParams * parametros;
	struct tabela_Simbolos *next;

}tabela_Simbolos;
tabela_Simbolos * tabela;
simbolos *novo_simbolo (char* tipo, char* nome, int flag, FormalParams *formal);
tabela_Simbolos *inicia_tabela();
tabela_Simbolos *nova_tabela_simbolos(char *nome, char* tipo, FormalParams* parametros,simbolos *simboloAt);
void coloca_tabela_fim(tabela_Simbolos* sim,tabela_Simbolos*add);
void Adiciona_Simbolo(simbolos *sim, simbolos *add);
FormalParams *inicia_FormalParams();

void adiciona_param (FormalParams* Par, char *tipo, char* valor);
void Preenche_tabelas (node * n,tabela_Simbolos* tabelak);
simbolos *inicia_simbolos();
void continuacao_tab(node *n, tabela_Simbolos *tabelak);
void print(tabela_Simbolos* tabela);
void coloca_notacao(node * n,tabela_Simbolos* tabelak);
char *String_arg(char *var2, tabela_Simbolos *tabelak,node *n);
char *Verifica_parecido(char *var2, tabela_Simbolos* tabelak, node*n);
char *check_return (char *nome,tabela_Simbolos *tabela);
char *check_existencia_variaveis(char * var, tabela_Simbolos *principal);
char* check_existencia (char *var, tabela_Simbolos *principal);
void print_arvore_final(node* n, int depth);