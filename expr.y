%{
#include "auxexpr.h"
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE Atributo
%}

%token 
TADD TMUL TSUB TDIV 
TMENOR TMENORIG TMAIOR TMAIORIG TEQUIV TNOTEQUIV TIGUAL
TAPAR TFPAR TACHA TFCHA 
TVIRG TPONTVIRG
TE TOU TNOT
TVOID TSTRING TINT
TRETURN TIF TELSE TWHILE TPRINT TREAD 
TNUM TID TLITERAL 

%%

Programa: ListaFuncoes BlocoPrincipal{
		ImprimirInstrucoes();
		SalvarBytecode();
		exit(0);
	}
	| BlocoPrincipal{
		ImprimirInstrucoes();
		SalvarBytecode();
		exit(0);
	} 
	;
ListaFuncoes: ListaFuncoes Funcao
	| Funcao
	;
Funcao: TipoRetorno TID TAPAR DeclParametros TFPAR BlocoPrincipal
	| TipoRetorno TID TAPAR TFPAR BlocoPrincipal
	;
TipoRetorno: Tipo
	| TVOID
	;
DeclParametros: DeclParametros TVIRG Parametro
	| Parametro
	;
Parametro: Tipo TID
	;
BlocoPrincipal: TACHA Declaracao ListaCmd TFCHA
	| TACHA ListaCmd TFCHA
	;
Declaracao: Tipo ListaId TPONTVIRG
	;
Tipo: TINT
	| TSTRING
	;
ListaId: ListaId TVIRG TID {insereNoFim(&$$.IDlista, $3.id);}
	| TID {InitLista(&$$.IDlista, sizeof(NaLista)); insereNoFim(&$$.IDlista, $1.id);}
	;
Bloco: TACHA ListaCmd TFCHA
	;
ListaCmd: ListaCmd Comando
	| Comando
	;
Comando: CmdSe
	| CmdEnquanto
	| CmdAtrib
	| CmdEscrita
	| CmdLeitura
	| ChamadaFuncao
	| Retorno
	;
Retorno: TRETURN ExpressaoAritmetica TPONTVIRG
	;
CmdSe: TIF TAPAR ExpressaoLogica TFPAR Bloco
	| TIF TAPAR ExpressaoLogica TFPAR Bloco TELSE Bloco
	;
CmdEnquanto: TWHILE TAPAR ExpressaoLogica TFPAR Bloco
	;
CmdAtrib: TID TIGUAL ExpressaoAritmetica TPONTVIRG {empurra(ISTORE,$1);}
	| TID TIGUAL TLITERAL TPONTVIRG	{empurra(ISTORE,$1);}
	;
CmdEscrita: TPRINT TAPAR ExpressaoAritmetica TFPAR TPONTVIRG
	| TPRINT TAPAR TLITERAL TFPAR TPONTVIRG
	;
CmdLeitura: TREAD TAPAR TID TFPAR TPONTVIRG
	;
ChamadaFuncao: TID TAPAR ListaParametros TFPAR TPONTVIRG
	| TID TAPAR TFPAR TPONTVIRG
	;
ListaParametros: ListaParametros TVIRG ExpressaoAritmetica
	| ExpressaoAritmetica
	;
ExpressaoLogica: TermoLogico OperadorLogico TermoLogico
	| TermoLogico
	;
TermoLogico: FatorLogico
	| TNOT TermoLogico
	;
FatorLogico: TAPAR ExpressaoLogica TFPAR
	| ExpressaoRelacional
	;
OperadorLogico: TE
	| TOU
	;
ExpressaoRelacional:ExpressaoAritmetica OperadorRelacional ExpressaoAritmetica
	;
OperadorRelacional: TMENOR
	| TMENORIG
	| TMAIOR
	| TMAIORIG
	| TEQUIV
	| TNOTEQUIV
	;
ChamadaFuncaoAtrib: TID TAPAR ListaParametros TFPAR
	| TID TAPAR TFPAR
	;
ExpressaoAritmetica: ExpressaoAritmetica TADD TermoAritmetica {empurra(IADD,$1);}
	| ExpressaoAritmetica TSUB TermoAritmetica {empurra(ISUB, $1);}
	| TermoAritmetica
	;
TermoAritmetica: TermoAritmetica TMUL FatorAritmetica {empurra(TMUL,$1);}
	| TermoAritmetica TDIV FatorAritmetica {empurra(TDIV,$1);}
	| FatorAritmetica
	;
FatorAritmetica: TNUM {empurra(BIPUSH,$1);}
	| TAPAR ExpressaoAritmetica TFPAR 
	| TID {empurra(ILOAD,$1);}
	| ChamadaFuncaoAtrib
	;
%%
#include "lex.yy.c"

int yyerror (char *str)
{
	printf("%s: %s\n", str, yytext);
	
} 		 

int yywrap()
{
	return 1;
}
