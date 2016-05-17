delim	[ \t]
ws	{delim}+
digito	[0-9]
num	{digito}+(\.{digito}*(E[+-]?{digito}+)?)?
id ([A-Za-z_-])+ 
literal \"(.)*\"

%%
{ws}	{}
"+"	{return TADD;}
"-"	{return TSUB;}
"*"	{return TMUL;}
"/"	{return TDIV;}
"("	{return TAPAR;}
")"	{return TFPAR;}
"{" {return TACHA;}
"}" {return TFCHA;}
"," {return TVIRG;}
"=" {return TIGUAL;}
";" {return TPONTVIRG;}
"void" {return TVOID;}
"String" {return TSTRING;}
"int" {return TINT;}
"return" {return TRETURN;}
"if" {return TIF;}
"else" {return TELSE;}
"while" {return TWHILE;}
"print" {return TPRINT;}
"read" {return TREAD;}
\n	{return TFIM;}
{num}	{yylval = atof(yytext); return TNUM;} 
{id} {yylval = strcop(yytext); return TID;}
{literal} {yylval = strcop(yytext); return TLITERAL;}