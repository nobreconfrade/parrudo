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
	java -jar ./jasmin-2.4/jasmin.jar ./Bytecode.j
	java Bytecode

	wget -O Jasmin.zip 'http://downloads.sourceforge.net/project/jasmin/jasmin/jasmin-2.4/jasmin-2.4.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fjasmin%2Ffiles%2F&ts=1449124222&use_mirror=ufpr'
	unzip Jasmin.zip
	rm Jasmin.zip



*/

extern FILE *yyin;

int main(int argc, char **argv)
{
	yyin = fopen(argv[1],"r");
	yyparse();
	return 0;
}
