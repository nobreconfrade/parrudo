delim	[ \t]
ws	{delim}+
digito	[0-9]
literal \".*\"
num	{digito}+(\.{digito}*(E[+-]?{digito}+)?)?
id ([A-Za-z_-])+ 

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
";" {return TPONTVIRG;}

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

{num}	{yylval = atof(yytext); return TNUM;} 
{id} {strcpy(yylval.id,yytext);return TID;}
{literal} {strcpy(yylval.literal,yytext);return TLITERAL;}