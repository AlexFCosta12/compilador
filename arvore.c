#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <stdarg.h>
#include "arvore.h"

tabela_Simbolos *tabelaAtual2 = NULL;
tabela_Simbolos *tabelaAtual=NULL;
int count =0;

node *novo_node (char *tipo, void *valor,int n_filhos,int usado){
	node* n = (node*)malloc(sizeof(node));
	n->tipo = strdup(tipo);
	n->valor = valor;
	n->n_filhos = n_filhos;
	n->usado = usado;
	n->ArvTipo = NULL;
	n->filho = (node**)malloc(sizeof(node)*n_filhos);
	return n;

}

node *create_node_terminal (char* tipo, int usado, void* valor){
	node* n = novo_node(tipo, valor,0,usado);
	return n;
}
node *junta_linha_coluna ( no *add, node* noAdd){
	noAdd -> estrutura = add;
	return noAdd;
}
node *cria_Insere_node(char *tipo, int usado, int n_filhos,...){
	int i,j=0,h;
	node *Pai;
	node *auxiliar;
	va_list argumentos;
	va_start (argumentos,n_filhos);
	Pai = novo_node(tipo,NULL,n_filhos,usado);
	for (i=0;i<n_filhos;i++){
		auxiliar = va_arg(argumentos,node*);
		if (auxiliar -> usado !=1){//Se o filho ainda não tiver a ser usado
			Pai->n_filhos = (Pai->n_filhos-1)+auxiliar->n_filhos;
			Pai->filho = (node **)realloc (Pai->filho,sizeof(node)*(Pai->n_filhos));
			for (h=0;h<auxiliar->n_filhos;h++) {
				Pai->filho[j] = auxiliar->filho[h];
				j++;
			}
		}else{
			Pai->filho[j]= auxiliar;
			j++; 
		}
	}
	va_end(argumentos);
	return Pai;
}

void print_node(node* n, int depth) {
	int i;
	char* ident = (char*)malloc(sizeof(char)*depth*2+1);
	for (i=0;i<depth*2;i++) {
		ident[i] = '.';
	}
	printf("%s", ident);
	if (!strcmp(n->tipo, "Id")) {
		printf("%s(%s)\n", n->tipo, (char*)n->valor);
	}else if (!strcmp(n->tipo,"DecLit")){
		printf("%s(%s)\n", n->tipo, (char*)n->valor);
	}else if (!strcmp(n->tipo,"StrLit")){
		printf("%s(%s)\n",n->tipo,(char*)n->valor );
	}
	else if (!strcmp(n->tipo,"RealLit")){
		printf("%s(%s)\n",n->tipo,(char*)n->valor );
	}
	else if (!strcmp (n->tipo,"BoolLit")){
		printf("%s(%s)\n",n->tipo,(char*)n->valor);
	}
	else {
		printf("%s\n", n->tipo);
	}
	for (i=0;i<n->n_filhos;i++) {
		print_node(n->filho[i], depth+1);
	}
}


simbolos *novo_simbolo (char* tipo, char* nome,int flag, FormalParams *formal){
	if (strcmp(tipo,"Bool")==0){
		tipo = strdup("boolean");
	}else if (strcmp(tipo,"Int")==0){
		tipo = strdup("int");
	}else if (strcmp(tipo,"Void")==0){
		tipo = strdup("void");
	}else if (strcmp(tipo,"Double")==0){
		tipo = strdup("double");
	}else if (strcmp(tipo,"StringArray")==0){
		tipo = strdup ("String[]");
	}
	simbolos *sim = (simbolos*)malloc(sizeof(simbolos));
	sim->tipo= strdup(tipo);
	sim->nome = strdup(nome);
	sim->flag = flag;
	sim->ParametrosFunc = formal;
	return sim;
}

void Adiciona_Simbolo(simbolos *sim, simbolos *add){
	while (sim->next !=NULL){
		sim = sim->next;
	}

	simbolos *temp = sim->next;
	sim->next = add;
	add->next = temp;

}

simbolos *inicia_simbolos(){
	simbolos* Par = (simbolos*) malloc(sizeof(simbolos));
	Par -> tipo = strdup("");
	Par -> nome = strdup ("");
	Par ->flag = 0;
	Par-> ParametrosFunc = NULL;
	Par -> next = NULL;
	return Par;
}

tabela_Simbolos *inicia_tabela(){
	tabela_Simbolos * tab = (tabela_Simbolos*) malloc(sizeof(tabela_Simbolos));
	tab -> simboloAt = NULL;
	tab->nome = strdup("");
	tab->tipo = strdup("");
	tab->parametros = NULL;
	tab ->next = NULL;
	return tab;
}

tabela_Simbolos *nova_tabela_simbolos(char *nome, char* tipo, FormalParams* parametros, simbolos *simboloAt){
	tabela_Simbolos * tab = (tabela_Simbolos*) malloc(sizeof(tabela_Simbolos));
	tab -> simboloAt = simboloAt;
	tab->nome = strdup(nome);
	tab->tipo = strdup(tipo);
	tab->parametros = parametros;
	return tab;
}
void coloca_tabela_fim(tabela_Simbolos* sim,tabela_Simbolos*add){
	while (sim->next !=NULL){
		sim = sim->next;
	}
	sim->next = add;
	add->next = NULL;

}
FormalParams *inicia_FormalParams(){
	FormalParams* Par = (FormalParams*) malloc(sizeof(FormalParams));
	Par -> tipo = strdup("");
	Par -> valor = strdup ("");
	Par -> next = NULL;
	return Par;
}
void adiciona_param (FormalParams* Par, char *tipo, char* valor){
	if (strcmp(tipo,"StringArray")==0){
		tipo = strdup("String[]");
	}else if (strcmp(tipo,"Bool")==0){
		tipo = strdup("boolean");
	}else if (strcmp(tipo,"Int")==0){
		tipo = strdup("int");
	}else if (strcmp(tipo,"Double")==0){
		tipo = strdup("double");
	}
	FormalParams* insere = (FormalParams*) malloc(sizeof(FormalParams));
	insere -> tipo = strdup(tipo);
	insere -> valor = strdup(valor);
	while (Par->next!=NULL){
		Par = Par ->next;
	}
	FormalParams *temp = Par->next;
	Par->next = insere;
	insere->next = temp;
}

void Preenche_tabelas (node * n,tabela_Simbolos* tabelak){
	int j=0;
		int i;
		simbolos * add;
		tabela_Simbolos* tabelaAdd;
	if (strcmp(n->tipo,"Program")==0){
		tabelaAdd = nova_tabela_simbolos((char*)n->filho[0]->valor,"Class",NULL,inicia_simbolos());
		coloca_tabela_fim(tabelak,tabelaAdd);
		tabela_Simbolos * tabelaN = tabelak ->next;
		for (i=0;i<n->n_filhos;i++){
			Preenche_tabelas (n->filho[i],tabelaN);
		}
		for (i=0;i<n->n_filhos;i++){
			continuacao_tab(n->filho[i],tabelak);
		}
		return ;
	}else if (strcmp(n->tipo,"FieldDecl")==0){
		simbolos * novo = novo_simbolo(n->filho[0]->tipo,(char*)n->filho[1]->valor,0,NULL);
		Adiciona_Simbolo(tabelak->simboloAt,novo);
	}else if (strcmp(n->tipo,"MethodDecl")==0){
		node *methheader = n ->filho[0];
		tabela_Simbolos* TabelaNova;
		TabelaNova = nova_tabela_simbolos((char*)methheader->filho[1]->valor,"Method",inicia_FormalParams(),inicia_simbolos());
		coloca_tabela_fim(tabelak,TabelaNova);
		add = novo_simbolo(methheader->filho[0]->tipo,"return",0,NULL);
		Adiciona_Simbolo(TabelaNova->simboloAt,add);

		if (methheader->filho[2]->n_filhos>0 && methheader->n_filhos>2 && strcmp (methheader->filho[2]->tipo,"MethodParams")==0){
			simbolos * param;
			while (methheader->filho[2]->n_filhos>j){
				node *aux2 = methheader->filho[2]->filho[j];
				adiciona_param(TabelaNova->parametros,aux2->filho[0]->tipo,(char*)aux2->filho[1]->valor);
				param = novo_simbolo(aux2->filho[0]->tipo,(char*)aux2->filho[1]->valor,2,NULL);
				Adiciona_Simbolo(TabelaNova->simboloAt,param);
				j++;
			}
			add = novo_simbolo(methheader->filho[0]->tipo,(char*)methheader->filho[1]->valor,1,TabelaNova->parametros);
			Adiciona_Simbolo(tabelak->simboloAt,add);
		}else{
			adiciona_param(TabelaNova->parametros,"vazio","vazio");
			add = novo_simbolo(methheader->filho[0]->tipo,(char*)methheader->filho[1]->valor,1,TabelaNova->parametros);
			Adiciona_Simbolo(tabelak->simboloAt,add);
		}
		if (count==0){
			tabelaAtual = tabela->next;
			tabelaAtual2 = tabela->next->next;
			count++;
		}else{
			tabelaAtual2 = tabelaAtual2->next;	
		}
		for (i=0;i<n->n_filhos;i++){
			Preenche_tabelas (n->filho[i],TabelaNova);
		}
		return;
	}
	else if (strcmp(n->tipo,"VarDecl")==0){
		simbolos * AddS = novo_simbolo(n->filho[0]->tipo,(char*)n->filho[1]->valor,0,NULL);
		Adiciona_Simbolo(tabelak->simboloAt,AddS);

	}else if (strcmp(n->tipo,"MethodBody")==0){
		return;
	}
	for (i=0;i<n->n_filhos;i++){
		Preenche_tabelas (n->filho[i],tabelak);
	}
}

void continuacao_tab(node *n, tabela_Simbolos *tabelak){
	int i,j;
	if (strcmp(n->tipo,"MethodDecl")==0){
		tabelaAtual = tabelaAtual->next;
		for (i=0;i<n->n_filhos;i++){
			if (strcmp(n->filho[i]->tipo,"MethodBody")==0){
				for (j=0;j<n->filho[i]->n_filhos;j++){
					if (strcmp(n->filho[i]->filho[j]->tipo,"VarDecl")==0){
						Preenche_tabelas(n->filho[i]->filho[j],tabelaAtual);
					}else coloca_notacao(n->filho[i]->filho[j],tabelak);
				}
			}
		}
	}
}

void print(tabela_Simbolos* tabela){
	tabela = tabela->next;
	while(tabela!=NULL){
	simbolos *aux = tabela -> simboloAt;
	aux = aux->next;
	if (tabela->parametros!=NULL){
		FormalParams * parame = tabela->parametros;
		printf("===== %s %s(", tabela->tipo,tabela->nome);
		parame = parame ->next;
		if (strcmp(parame->tipo,"vazio")!=0){
			while (parame !=NULL){
				if (parame->next == NULL){
					printf("%s",parame->tipo);
				}else{
					printf("%s,",parame->tipo);
				}
				parame = parame->next;
			}
		}
		printf(") Symbol Table =====\n");
	}else{
		printf("===== %s %s Symbol Table =====\n",tabela->tipo, tabela->nome);
	}
	while (aux!=NULL){
		FormalParams *AF = aux->ParametrosFunc;
		if (aux->flag == 0){
			printf("%s\t\t%s\n", aux->nome, aux->tipo);
		}else if (aux->flag == 2){
			printf("%s\t\t%s\tparam\n",aux->nome,aux->tipo);
		}
		else{
			printf("%s\t(",aux->nome);
			AF = AF->next;
			if (strcmp(AF->tipo,"vazio")!=0){
				while(AF->next !=NULL){
					printf("%s,",AF->tipo);
					AF = AF->next;
				}
				printf("%s)\t%s\n",AF->tipo,aux->tipo);
			}else{
				printf(")\t%s\n",aux->tipo);
			}
		}
		aux = aux->next;
		// colocar a flag 1 para as funçes que são criadas nessa class
	}
	printf("\n");
	tabela = tabela->next;
}
}
void coloca_notacao(node * n,tabela_Simbolos* tabelak){
	tabela_Simbolos *tabelaAux = tabelak->next;
	int i;
	char *comp = NULL;
	if (strcmp(n->tipo,"DecLit")==0 || strcmp (n->tipo,"ParseArgs")==0 || strcmp (n->tipo,"Length")==0){
		n->ArvTipo = strdup("int");
	}else if (strcmp(n->tipo,"RealLit")==0){
		n->ArvTipo = strdup("double");
	}
	else if (strcmp(n->tipo,"StrLit")==0){
		n->ArvTipo = strdup("String");
	}else if (strcmp (n->tipo,"Not")==0||strcmp(n->tipo,"BoolLit")==0 ||strcmp (n->tipo,"And")==0|| strcmp(n->tipo,"Or")==0 || strcmp(n->tipo,"Lt")==0|| strcmp(n->tipo,"Gt")==0|| strcmp(n->tipo,"Eq")==0|| strcmp(n->tipo,"Neq")==0|| strcmp(n->tipo,"Leq")==0||strcmp(n->tipo,"Geq")==0){
		n->ArvTipo = strdup ("boolean");
	}else if (strcmp(n->tipo,"Call")==0){/*VER DEPOIS*/	
		for (i=1;i<n->n_filhos;i++){
			coloca_notacao(n->filho[i],tabelak);
		}
		comp = Verifica_parecido(n->filho[0]->valor,tabelak,n);
		if (comp!=NULL){
			n->filho[0]->ArvTipo = strdup(comp);
			comp = String_arg(n->filho[0]->valor, tabelak,n);
			if (comp!=NULL){
				n->filho[0]->ArvTipo = strdup(comp);
			}
		}
		
		return;
	}else if (strcmp(n->tipo,"Assign")==0){
		comp = check_existencia_variaveis((char*)n->filho[0]->valor,tabelaAux);
		if (comp!=NULL){
			n->filho[0]->ArvTipo= strdup(comp);
			n->ArvTipo = strdup(comp);
		}
	}else if (strcmp(n->tipo,"Id")==0){
		comp = check_existencia_variaveis((char*)n->valor,tabelaAux);
		if (comp != NULL){
			n->ArvTipo = strdup(comp);
		}
	}else if (strcmp (n->tipo,"Sub")== 0 || strcmp (n->tipo,"Add")==0 || strcmp(n->tipo,"Mul")==0|| strcmp (n->tipo,"Div")==0 || strcmp (n->tipo,"Mod")==0){
		int j;
		for (j=0;j<n->n_filhos;j++){
			coloca_notacao(n->filho[j],tabelak);
		}
		if (n->filho[0]->ArvTipo!=NULL){
			n->ArvTipo = strdup (n->filho[0]->ArvTipo);
		}else if (n->filho[1]->ArvTipo!=NULL){
			n->ArvTipo = strdup (n->filho[1]->ArvTipo);
		}
	}	
	for (i=0;i<n->n_filhos;i++) {
		coloca_notacao(n->filho[i],tabelak);
	}
}

char *String_arg(char *var2, tabela_Simbolos *tabelak, node *n){
	int h;
	int j =0;
	char *returnar = NULL;
	FormalParams * formal;
	FormalParams * verifica = NULL;
	simbolos * aux = tabelak->next->simboloAt;
		while (aux!=NULL && j==0){
		if (strcmp(aux->nome, var2)==0){
			if (aux->ParametrosFunc != NULL){
				verifica = aux->ParametrosFunc->next;
				j=1;
				if (n->n_filhos!=1 && strcmp(verifica->tipo,"vazio")!=0){
					for (h=1;h<n->n_filhos;h++){
						if (verifica !=NULL){
							if (strcmp(verifica->tipo,n->filho[h]->ArvTipo)==0){
								verifica = verifica->next;
							}
							else{
								j=0;
								break;
							}
						}else{
							j=0;
							break;
						}
						
					}
				}else if (n->n_filhos ==1 && strcmp (verifica->tipo,"vazio")!=0){
					j=0;
				}else if (n->n_filhos !=1 && strcmp (verifica->tipo,"vazio")==0){
					j=0;
				}
			}
		}
		if (j==0)
			aux = aux->next;
		else{
			break;
		}
	}
	if (j==1){
		n->ArvTipo = strdup (aux->tipo);
		formal  = aux->ParametrosFunc->next;
		if (strcmp(formal->tipo,"vazio")==0){
			returnar = strdup("()");
		}else{
			returnar = strdup("(");
			while(formal->next !=NULL){
				char * string = strdup(formal->tipo);
				strncat(returnar,string,strlen(string));
				strncat(returnar,",",strlen(","));
				formal = formal->next;
			}
			strncat(returnar,formal->tipo,strlen(formal->tipo));
			strncat(returnar,")",strlen(")"));
			}
		}
	return returnar;
}

char *Verifica_parecido(char *var2, tabela_Simbolos* tabelak, node*n){
		int h;
	int j =0;
	char *returnar = NULL;
	FormalParams * formal;
	FormalParams * verifica = NULL;
	simbolos * aux = tabelak->next->simboloAt;
		while (aux!=NULL && j==0){
		if (strcmp(aux->nome, var2)==0){
			if (aux->ParametrosFunc != NULL){
				verifica = aux->ParametrosFunc->next;
				j=1;
				if (n->n_filhos!=1 && strcmp(verifica->tipo,"vazio")!=0){
					for (h=1;h<n->n_filhos;h++){
						if (verifica !=NULL){
							if (strcmp(verifica->tipo,n->filho[h]->ArvTipo)==0 || (strcmp(verifica->tipo,"double")==0 && strcmp(n->filho[h]->ArvTipo,"int")==0)){
								verifica = verifica->next;
							}
							else{
								j=0;
								break;
							}
						}else{
							j=0;
							break;
						}
						
					}
				}else if (n->n_filhos ==1 && strcmp (verifica->tipo,"vazio")!=0){
					j=0;
				}else if (n->n_filhos !=1 && strcmp (verifica->tipo,"vazio")==0){
					j=0;
				}
			}
		}
		if (j==0)
			aux = aux->next;
		else{
			break;
		}
	}
	if (j==1){
		n->ArvTipo = strdup (aux->tipo);
		formal  = aux->ParametrosFunc->next;
		if (strcmp(formal->tipo,"vazio")==0){
			returnar = strdup("()");
		}else{
			returnar = strdup("(");
			while(formal->next !=NULL){
				char * string = strdup(formal->tipo);
				strncat(returnar,string,strlen(string));
				strncat(returnar,",",strlen(","));
				formal = formal->next;
			}
			strncat(returnar,formal->tipo,strlen(formal->tipo));
			strncat(returnar,")",strlen(")"));
			}
		}
	return returnar;
}

char *check_return (char *nome,tabela_Simbolos *tabelak){ /*retorna de que tipo é a funcao*/	
	char *returnar = NULL;
	simbolos *aux = tabelak->next->simboloAt; 
	while (aux!=NULL){
		if (strcmp(aux->nome,nome)==0&&aux->flag ==1){
			returnar = strdup(aux->tipo);
		}
		aux = aux->next;
	}
	return returnar;
}

char *check_existencia_variaveis(char * var, tabela_Simbolos *principal){
	char *returnar = NULL;
	simbolos * simb = principal->simboloAt;
	while (simb !=NULL){
		if (strcmp(var,simb->nome)==0 && simb->flag == 0){
			returnar = strdup(simb->tipo);
		}
		simb = simb->next;
	}
	simbolos *simbSec = tabelaAtual->simboloAt->next;
	while (simbSec !=NULL){
		if (strcmp(var,simbSec->nome)== 0){
			returnar = strdup(simbSec->tipo);
		}
		simbSec = simbSec->next;
	}
	FormalParams * formal = tabelaAtual->parametros;
	while(formal!=NULL){
		if (strcmp(var,formal->valor)==0){
			returnar = strdup(formal->tipo);
		}
		formal = formal ->next;
	}
	return returnar;
}
char* check_existencia (char *var, tabela_Simbolos *principal){/*retorna o tipo que é suposto ser a variavel se retornar NULL essa variavel não existe*/
	char *returnar = NULL;
	simbolos * simb = principal->simboloAt;
	simb = simb->next;
	while (simb !=NULL){
		if (strcmp(var,simb->nome)==0){
			returnar = strdup(simb->tipo);
		}
		simb = simb->next;
	}
	simbolos *simbSec = tabelaAtual->simboloAt->next;
	while (simbSec !=NULL){
		if (strcmp(var,simbSec->nome)== 0){
			returnar = strdup(simbSec->tipo);
		}
		simbSec = simbSec->next;
	}
	FormalParams * formal = tabelaAtual->parametros;
	while(formal!=NULL){
		if (strcmp(var,formal->valor)==0){
			returnar = strdup(formal->tipo);
		}
		formal = formal ->next;
	}
	return returnar;
}

void print_arvore_final(node* n, int depth) {
	int i;
	char* ident = (char*)malloc(sizeof(char)*depth*2+1);
	for (i=0;i<depth*2;i++) {
		ident[i] = '.';
	}
	printf("%s", ident);
	if (!strcmp(n->tipo, "Id") || !strcmp(n->tipo,"DecLit")|| !strcmp(n->tipo,"StrLit")|| !strcmp(n->tipo,"RealLit")||!strcmp (n->tipo,"BoolLit")) {
		if (n->ArvTipo !=NULL){
			printf("%s(%s) - %s\n",n->tipo,(char*)n->valor,n->ArvTipo);
		}else{
			printf("%s(%s)\n", n->tipo, (char*)n->valor);
		}
	}
	else {
		if (n->ArvTipo !=NULL){
			printf("%s - %s\n", n->tipo, n->ArvTipo);
		}else{
			printf("%s\n", n->tipo);
	}
	}
	for (i=0;i<n->n_filhos;i++) {
		print_arvore_final(n->filho[i], depth+1);
	}
}