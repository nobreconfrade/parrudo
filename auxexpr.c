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
			insereNoFim(IDlista, &aux);
		}
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
			if (codigo.para1 =! INF)
				sprintf(str, "\tbipush %d\n", codigo.para1);
			else
				sprintf(str, "\tbipush %s\n", codigo.str);
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
			if (codigo.para1 != INF){
				sprintf(str, "\tinvokevirtual java/io/PrintStream/println(I)V\n");
			}else{
				sprintf(str, "\tinvokevirtual java/io/PrintStream/println(Ljava/lang/String;)V\n");
			}
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
	for (i = 0; i < 256; i++){
		char instNome[270];
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
	EscreveBytecode("\treturn\n.end method\n");
	FILE* arquivoBytecode = fopen("Bytecode.j","w");
	fputs(bufferSaida, arquivoBytecode);
	printf("%s", bufferSaida); 
}

void EscreveBytecode(const char *bytecode){
	sprintf(bufferSaida + strlen(bufferSaida), "%s", bytecode);
}
//////////////////////////////////////////////////////////////////////////////////////////////////

void empurra(int instrucao, Atributo param){
	NaLista aux;
	switch (instrucao){
		case BIPUSH:
			if(param.num >= 0 && param.num < 6)
				instrucao = ICONST;
			else if(param.num < -128 && param.num > 127)
				instrucao = LDC;
			codigo[proxInstrucao].para1 = param.num;
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
			break;
		case PRINT:
			if(codigo[proxInstrucao-1].para1 == INF)
				codigo[proxInstrucao].para1 = INF;
			else
				codigo[proxInstrucao].para1 = 0;
			break;
		default: // expressoes aritmeticas caem aqui!
			break;
	}
	codigo[proxInstrucao].instrucao = instrucao;
	proxInstrucao++;
}

//////////////////////////////////////////////////////////////////////////////////////////////////