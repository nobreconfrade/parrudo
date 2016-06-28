delim	[ \t]
ws	{delim}+
digito	[0-9]
literal \".*\"
num	{digito}+(\.{digito}*(E[+-]?{digito}+)?)?
id ([A-Za-z_-])+ 

%%
{ws}	{}
"++" {return TINCR;}
"--" {return TDECR;}

"+"	{return TADD;}
"-"	{return TSUB;}
"*"	{return TMUL;}
"/"	{return TDIV;}

"<" {return TMENOR;}
"<=" {return TMENORIG;}
">" {return TMAIOR;}
">=" {return TMAIORIG;}
"==" {return TEQUIV;}
"!=" {return TNOTEQUIV;}

"("	{return TAPAR;}
")"	{return TFPAR;}
"{" {return TACHA;}
"}" {return TFCHA;}

"," {return TVIRG;}
";" {return TPONTVIRG;}

"&&" {return TE;}
"||" {return TOU;}
"!" {return TNOT;}

"=" {return TIGUAL;}

"void" {return TVOID;}
"String" {return TSTRING;}
"int" {return TINT;}

"return" {return TRETURN;}
"if" {return TIF;}
"else" {return TELSE;}
"while" {return TWHILE;}
"print" {return TPRINT;}
"read" {return TREAD;}
"for" {return TFOR;}

{num} {yylval.num = atof(yytext); return TNUM;} 
{id} {strcpy(yylval.id,yytext); return TID;}
{literal} {strcpy(yylval.literal,yytext); return TLITERAL;}

. {printf("Erro léxico\n");}
