#include "lista.h"
#include <stdio.h>
#include <string.h>

// DEFINES
#define INF       0xFFFF
#define INT       0x2000
#define STRING    0x2001
#define BIPUSH    0x0000
#define ICONST    0x0001
#define LDC       0x0002
#define ILOAD     0x0003
#define ISTORE    0x0004
#define PRINT     0x0005
#define IADD      0x0006
#define ISUB      0x0007
#define IMUL      0x0008
#define IDIV      0x0009
#define GETSTATIC 0x000A
#define IFCMP     0x000B
#define GOTO      0x000C
#define IINCR     0x9000
#define IDECR     0x9001

#define LT        0x100A
#define LE        0x100B
#define GT        0x100C
#define GE        0x100D
#define EQ        0x100E
#define NE        0x100F
//STRUCTS
typedef struct{
    char id[20];
    int tipo;
    int pos;
}NaLista;
typedef struct{
    char id[20];
    char literal[256];
    int num;
    int label;
    Lista IDlista;
    Lista listaV;
    Lista listaF;
    int tipo;
}Atributo;
typedef struct {
	int label; 
    int para1;
	int para2;
	char str[256];
	int instrucao;
}Instrucao;

//VARIAVEIS
Instrucao codigo[64];
char bufferSaida[2000];
int proxInstrucao;
int proxLabel;
Lista IDtabela;

//FUNCOES
int CompararID(void *id1, void *id2);
void Correcao(Lista *l, int label);
void iniciaListaVaziaVF(Atributo * item);
void iniciaListaVF(Atributo *item);
void passaListaVF(Atributo *dest, Atributo *fonte);
void passaTrocandoListaVF(Atributo *dest, Atributo *fonte);
void Junta(Lista *dest, Lista *fonte1, Lista *fonte2);
int novoLabel();
void InsereNaTabela (Lista *IDlista, int tipo);
const char* pegaNomeComparacao(const int comp_tipo);
void pegaNomeInstrucao(Instrucao codigo, char *instNome);
void ImprimeInstrucoes();
void InicializaBytecode();
void salvarArquivoBytecode();
void EscreveBytecode(const char *bytecode);
void empurra(int instrucao, Atributo param);