all:
	flex expr.l
	bison expr.y
	gcc expr.c auxexpr.c lista.c expr.tab.c -o parrudo

run:
	make
	./parrudo simple.parrudo

rm:
	rm Croissant genscanner.c genparser.c Bytecode.j Bytecode.class
	rm -rf ./jasmin-2.4

jasminget:
	wget -O Jasmin.zip 'http://downloads.sourceforge.net/project/jasmin/jasmin/jasmin-2.4/jasmin-2.4.zip?r=http%3A%2F%2Fsourceforge.net%2Fprojects%2Fjasmin%2Ffiles%2F&ts=1449124222&use_mirror=ufpr'
	unzip Jasmin.zip
	rm Jasmin.zip

jasminrun:
	java -jar ./jasmin-2.4/jasmin.jar ./Bytecode.j
	java Bytecode

compile:
	make run
	make jasminrun
