%{
#include "auxexpr.h"
#include <stdio.h>
#include <stdlib.h>
#define YYSTYPE Atributo
%}

%token 
TINCR TDECR
TADD TMUL TSUB TDIV 
TMENOR TMENORIG TMAIOR TMAIORIG TEQUIV TNOTEQUIV TIGUAL
TAPAR TFPAR TACHA TFCHA 
TVIRG TPONTVIRG
TE TOU TNOT
TVOID TSTRING TINT
TRETURN TIF TELSE TWHILE TPRINT TREAD TFOR
TNUM TID TLITERAL 

%%

Programa: ListaFuncoes BlocoPrincipal{
		ImprimeInstrucoes();
		salvarArquivoBytecode();
		exit(0);
	}
	| BlocoPrincipal{
		ImprimeInstrucoes();
		salvarArquivoBytecode();
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
BlocoPrincipal: TACHA Declaracoes ListaCmd TFCHA
	| TACHA ListaCmd TFCHA
	;
Declaracoes: Declaracoes Declaracao
	| Declaracao
	;
Declaracao: Tipo ListaId TPONTVIRG {InsereNaTabela(&$2.IDlista, $1.tipo);}
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
	| CmdIncrementa
	| CmdAtrib
	| CmdEscrita
	| CmdLeitura
	| ChamadaFuncao
	| Retorno
	;
Retorno: TRETURN ExpressaoAritmetica TPONTVIRG
	;
CmdSe: TIF TAPAR ExpressaoLogica TFPAR M_label Bloco{Correcao(&$3.listaV, $5.label);
													Correcao(&$3.listaF, novoLabel());}
	| TIF TAPAR ExpressaoLogica TFPAR M_label Bloco N_if TELSE M_label Bloco{
																	Correcao(&$3.listaV, $5.label); 
																	Correcao(&$3.listaF, $9.label);
																	Correcao(&$7.listaV, novoLabel());}
	;
CmdEnquanto: TWHILE M_label TAPAR ExpressaoLogica TFPAR M_label Bloco{	empurra(GOTO, $2);
																		Correcao(&$4.listaV, $6.label);
																		Correcao(&$4.listaF, novoLabel());}
	;
CmdIncrementa: TID TINCR TPONTVIRG {empurra(ILOAD,$1);
									empurra(IINCR,$1);
									empurra(ISTORE,$1);}
	;
M_label: {$$.label = novoLabel();}
	;
N_if:{iniciaListaVF(&$$);
	empurra(GOTO,$$);}
	;
CmdAtrib: TID TIGUAL ExpressaoAritmetica TPONTVIRG {empurra(ISTORE,$1);}
	;
CmdEscrita: TPRINT Flag_Escrita1 TAPAR ExpressaoAritmetica TFPAR Flag_Escrita2 TPONTVIRG
	| TPRINT Flag_Escrita1 TAPAR String TFPAR Flag_Escrita2 TPONTVIRG
	;
String: TLITERAL {empurra(LDC,$1);}
	;
Flag_Escrita1: {empurra(GETSTATIC,$$);}
	; 
Flag_Escrita2: {empurra(PRINT,$$);}
	;
CmdLeitura: TREAD TAPAR TID TFPAR TPONTVIRG
	;
ChamadaFuncao: TID TAPAR ListaParametros TFPAR TPONTVIRG
	| TID TAPAR TFPAR TPONTVIRG
	;
ListaParametros: ListaParametros TVIRG ExpressaoAritmetica
	| ExpressaoAritmetica
	;
ExpressaoLogica: TermoLogico TE M_label TermoLogico{iniciaListaVaziaVF(&$$);
													Correcao(&$1.listaV, $3.label);
													Junta(&$$.listaF, &$1.listaF, &$4.listaF);
													passaLista(&$$.listaV, &$4.listaV);}
	| TermoLogico TOU M_label TermoLogico {iniciaListaVaziaVF(&$$);
											Correcao(&$1.listaF, $3.label);
											Junta(&$$.listaV, &$1.listaV, &$4.listaV);
											passaLista(&$$.listaF, &$4.listaF);}
	| TermoLogico {passaListaVF(&$$, &$1);}
	;
TermoLogico: FatorLogico {passaListaVF(&$$,&$1);}
	| TNOT TermoLogico {passaTrocandoListaVF(&$$, &$2);}
	;
FatorLogico: TAPAR ExpressaoLogica TFPAR {passaListaVF(&$$,&$2);}
	| ExpressaoRelacional {passaListaVF(&$$,&$1);}
	;

ExpressaoRelacional:OperadorRelacional {iniciaListaVF(&$$); 
										empurra(IFCMP, $$); 
										empurra(GOTO, $$);}
	;
OperadorRelacional: ExpressaoAritmetica TMENOR ExpressaoAritmetica {$$.tipo = LT;}
	| ExpressaoAritmetica            TMENORIG  ExpressaoAritmetica {$$.tipo = LE;}
	| ExpressaoAritmetica            TMAIOR    ExpressaoAritmetica {$$.tipo = GT;}
	| ExpressaoAritmetica            TMAIORIG  ExpressaoAritmetica {$$.tipo = GE;}
	| ExpressaoAritmetica            TEQUIV    ExpressaoAritmetica {$$.tipo = EQ;}
	| ExpressaoAritmetica            TNOTEQUIV ExpressaoAritmetica {$$.tipo = NE;}
	;
ChamadaFuncaoAtrib: TID TAPAR ListaParametros TFPAR
	| TID TAPAR TFPAR
	;
ExpressaoAritmetica: ExpressaoAritmetica TADD TermoAritmetica {empurra(IADD,$1);}
	| ExpressaoAritmetica TSUB TermoAritmetica {empurra(ISUB, $1);}
	| TermoAritmetica
	;
TermoAritmetica: TermoAritmetica TMUL FatorAritmetica {empurra(IMUL,$1);}
	| TermoAritmetica TDIV FatorAritmetica {empurra(IDIV,$1);}
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
