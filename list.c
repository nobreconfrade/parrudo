#include "list.h"
#include <stdio.h>

void listBeginning(List *L1, unsigned int size){
	L1->sizeList = size;
	L1->head = NULL;

}

int listVoid(List *L1){
	if(L1->head == NULL)
		return 1;
	else
		return 0;
}

int listIncludeFirst(List *L1, void *data){
	Atribute *temp = allocAtribute(L1->sizeList,data);
	if(temp == NULL || temp->data == NULL)
		return 0;
	if(L1->head = NULL){
		temp->next = NULL;
		temp->before = NULL;
		L1->head = temp;
	}else{
		temp->next = L1->head;
		temp->before = NULL;
		L1->before = temp;
	}	
	return 1
}

Atribute *allocAtribute(unsigned int size, void *data){
	Atribute *temp;
	temp = (Atribute *) malloc(sizeof(Atribute));
	if (temp == NULL)
		return NULL;
	temp->data = malloc(size)
	if (temp->data = NULL){
		free(temp);
		return NULL;
	}
	memcpy(temp->data,data,size);
	return temp;				
}