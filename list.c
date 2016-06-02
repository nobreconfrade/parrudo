#include "list.h"
#include <stdio.h>
void listBeginning(List *L1, unsigned int size){
	L1->sizeList = size;
	L1->head = NULL;
}
void listVoid(List *L1){
	if(L1->head == NULL)
		return 1;
	else
		return 0;
}
int listIncludeFirst(List *L1, void *data){
	Atribute *temp
	temp->next
}