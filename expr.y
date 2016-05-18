%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double
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

Programa: ListaFuncoes BlocoPrincipal
	| BlocoPrincipal
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
ListaId: ListaId TVIRG TID
	| TID
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
Retorno: TRETURN ExpressaoAritmetica
	;
CmdSe: TIF TAPAR ExpressaoLogica TFPAR Bloco
	| TIF TAPAR ExpressaoLogica TFPAR Bloco TELSE Bloco
	;
CmdEnquanto: TWHILE TAPAR ExpressaoLogica TFPAR Bloco
	;
CmdAtrib: TID TIGUAL ExpressaoAritmetica TPONTVIRG
	| TID TIGUAL TLITERAL TPONTVIRG
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
ExpressaoAritmetica: ExpressaoAritmetica TADD TermoAritmetica {$$ = $1 + $3;}
	| ExpressaoAritmetica TSUB TermoAritmetica {$$ = $1 - $3;}
	| TermoAritmetica
	;
TermoAritmetica: TermoAritmetica TMUL FatorAritmetica {$$ = $1 * $3;}
	| TermoAritmetica TDIV FatorAritmetica {$$ = $1 / $3;}
	| FatorAritmetica
	;
FatorAritmetica: TNUM 
	| TAPAR ExpressaoAritmetica TFPAR {$$ = $2;}
	| TID	
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