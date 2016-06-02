#include <stdio.h>

/*
	PRAISE THE SUN 

	Author: William Pereira
	
	A compiler for a strange language

	Compiling commands of the compiler: 
	bison --verbose expr.y
	gcc expr.c exp.tab.c -o nome
	flex expr.l
	bison expr.y
*/

extern FILE *yyin;

int main(int argc, char **argv)
{
	yyin = fopen(argv[1],"r");
	yyparse();
	return 0;
}
