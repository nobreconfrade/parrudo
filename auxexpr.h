#define INF 0xFFFF

#include "lista.h"
#include <stdio.h>
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
Instrucao codigo[256];
int proxInstrucao = 0;