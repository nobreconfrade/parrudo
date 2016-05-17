%{
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE double
%}

%token TADD TMUL TSUB TDIV TAPAR TFPAR TACHA TFCHA TPONTVIRG TNUM TVIRG TIGUAL TVOID TSTRING TINT TRETURN TIF TELSE TWHILE TPRINT TREAD TID TLITERAL 

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
TipoRetoro: Tipo
			| TVOID
			;
DeclParametros: DeclParametros TVIRG Parametro
				| Parametro
				;
Parametro: Tipo TID
			;
BlocoPrincipal: TACHA Declaracoes ListaCmd TFCHA
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
Retorno: TRETURN ExpressaoAritimetica
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
Linha :Expr TFIM {printf("Resultado:%lf\n", $1);exit(0);}
	; 
Expr: Expr TADD Termo {$$ = $1 + $3;}
	| Expr TSUB Termo {$$ = $1 - $3;}
	| Termo
	;
Termo: Termo TMUL Fator {$$ = $1 * $3;}
	| Termo TDIV Fator {$$ = $1 / $3;}
	| Fator
	;
Fator: TNUM 
	| TAPAR Expr TFPAR {$$ = $2;}
	| TSUB Fator {$$ = -$2;}	
	;
%%
#include "lex.yy.c"

int yyerror (char *str)
{
	printf("%s - antes %s\n", str, yytext);
	
} 		 

int yywrap()
{
	return 1;
}
