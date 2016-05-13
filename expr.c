#include <stdio.h>

/*
	bison --verbose expr.y
	gcc expr.c exp.tab.c -o nome
	flex expr.l
	bison expr.y
*/

extern FILE *yyin;

int main()
{
	yyin = stdin;
	printf("Digite uma expressão:");
	yyparse();
	return 0;
}
