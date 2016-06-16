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
#define GETSTATIC 0x0010

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
    Lista IDlista;
    int tipo;
}Atributo;
typedef struct {
	int para1;
	int para2;
	char str[256];
	int instrucao;
}Instrucao;

//VARIAVEIS
Instrucao codigo[64];
char bufferSaida[2000];
int proxInstrucao;
Lista IDtabela;

//FUNCOES
void InsereNaTabela (Lista *IDlista, int tipo);
void pegaNomeInstrucao(Instrucao codigo, char *instNome);
void ImprimeInstrucoes();
void InicializaBytecode();
void salvarArquivoBytecode();
void EscreveBytecode(const char *bytecode);
void empurra(int instrucao, Atributo param);