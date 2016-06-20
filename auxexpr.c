#include "auxexpr.h"

int CompararID(void *id1, void *id2){
	return strcmp(((NaLista*)id1)->id,((NaLista*)id2)->id);
}

void InsereNaTabela (Lista *IDlista, int tipo){
	if(listaVazia(&IDtabela))
		InitLista(&IDtabela, sizeof(NaLista));
	NaLista aux;
	while (removeDoInicio(IDlista, aux.id) == 1){
		if(elementoExiste(IDlista, aux.id, CompararID)){
			printf("Erro na InsereNaTabela \n");
			exit(0);
		}else{
			static int i = 0; //static indica que esta variavel sera inicializada uma vez nesta execução
			aux.pos = ++i;
			aux.tipo = tipo;
			insereNoFim(&IDtabela, &aux);
			// printf("-------------------------------------------------------\n");
		}
			// printf("-------------------------------------------------------\n");
	}
}

void pegaNomeInstrucao(Instrucao codigo, char *instNome){
	char str[270] = "\0";
	switch(codigo.instrucao){
		case ICONST:
			sprintf(str, "\ticonst_%d\n", codigo.para1);
			break;
		case BIPUSH: 
			sprintf(str, "\tbipush %d\n", codigo.para1);
			break;
		case LDC:
			if (codigo.para1 != INF)
				sprintf(str, "\tldc %d\n", codigo.para1);
			else
				sprintf(str, "\tldc %s\n", codigo.str);
			// printf("----------------------------%d---------------------------\n",codigo.para1);
			break;
		case ISTORE:
			sprintf(str, "\tistore %d\n", codigo.para1);
			break;
		case ILOAD:
			sprintf(str, "\tiload %d\n", codigo.para1);
			break;
		case IADD:
			sprintf(str, "\tiadd\n");
			break;
		case IMUL:
			sprintf(str, "\timul\n");
			break;
		case ISUB:
			sprintf(str, "\tisub\n");
			break;
		case IDIV:
			sprintf(str, "\tidiv\n");
			break;
		case GETSTATIC:
			sprintf(str, "\tgetstatic java/lang/System/out Ljava/io/PrintStream;\n");
			break;
		case PRINT:
			if (codigo.para2 == STRING){
				sprintf(str, "\tinvokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
				// printf("----------------------------%d---------------------------\n",codigo.para1);
			}
			else
				sprintf(str, "\tinvokevirtual java/io/PrintStream/println(I)V\n");
			// printf("----------------------------%d---------------------------\n",codigo.para2);
			break;
		default:
			printf("Well, this is embarrassing...\n");
			break;
	}
	strcpy(instNome,str);
}

void ImprimeInstrucoes(){
	InicializaBytecode();
	int i;
	for (i = 0; i < proxInstrucao; i++){
		char instNome[270];
		// printf("_____%d______\n",codigo[i].para2);
		// printf("%s\n",instNome);
		pegaNomeInstrucao(codigo[i], instNome);
		EscreveBytecode(instNome);

	}
}

void InicializaBytecode(){
	EscreveBytecode(".class public Bytecode\n"
		".super java/lang/Object\n\n"
		".method public <init>()V\n"
		"\taload_0\n\n"
		"\tinvokenonvirtual java/lang/Object/<init>()V\n"
		"\treturn\n"
		".end method\n\n"
		".method public static main([Ljava/lang/String;)V\n"
		"\t.limit stack  10\n"
		"\t.limit locals 10\n");
}

void salvarArquivoBytecode(){
	// ImprimeTabela(&IDtabela);
	EscreveBytecode("\treturn\n.end method\n");
	FILE* arquivoBytecode = fopen("Bytecode.j","w");
	fputs(bufferSaida, arquivoBytecode);
	printf("%s", bufferSaida); 
}

void EscreveBytecode(const char *bytecode){
	sprintf(bufferSaida + strlen(bufferSaida), "%s", bytecode);
}

/*void ImprimeTabela(void * id){
	NaLista* table = (NaLista*)id;
	printf("(%i) %s:%s\n", table->pos, table->id, pegaTipoInstrucao(table->tipo));	
}
const char* pegaTipoInstrucao(const int type)
{
	switch(type)
	{
		case INT:
			return "INT";
			break;
		case STRING:
			return "STRING";
			break;
		default:
			return "NOPE";
			break;
	}
}*/
//////////////////////////////////////////////////////////////////////////////////////////////////

void empurra(int instrucao, Atributo param){
	NaLista aux;
	switch (instrucao){
		case BIPUSH:
			if(param.num >= 0 && param.num < 6){
				instrucao = ICONST;
				// printf("-----------------------------------------  %d  -----------------------------------------\n",param.num);
			}
			else if(param.num < -128 || param.num > 127){
				instrucao = LDC;
				// printf("-------------------------------------------------------\n");

			}
			codigo[proxInstrucao].para1 = param.num;
			codigo[proxInstrucao].para2 = INT;
			// printf("\n\n\n\n%d\n\n\n\n",codigo[proxInstrucao].para1); ou para2
			break;
		case ILOAD:
			strcpy(aux.id, param.id);
			buscaElemento(&IDtabela, &aux, CompararID);
			codigo[proxInstrucao].para1 = aux.pos;
			break;
		case ISTORE:
			strcpy(aux.id, param.id);
			buscaElemento(&IDtabela, &aux, CompararID);
			codigo[proxInstrucao].para1 = aux.pos;
			break;
		case LDC:
			strcpy(codigo[proxInstrucao].str, param.literal);
			codigo[proxInstrucao].para1 = INF;
			codigo[proxInstrucao].para2 = STRING;
			break;
		case PRINT:
			if(codigo[proxInstrucao-1].para2 == STRING)
				codigo[proxInstrucao].para2 = STRING;
			else
				codigo[proxInstrucao].para1 = 0;
				/*
			if(codigo[proxInstrucao-1].para1 == INF)
				codigo[proxInstrucao].para1 = INF;
			else
				codigo[proxInstrucao].para1 = 0;*/
			break;
		default: // expressoes aritmeticas caem aqui!
			break;
	}
	codigo[proxInstrucao].instrucao = instrucao;
	proxInstrucao++;
}

//////////////////////////////////////////////////////////////////////////////////////////////////