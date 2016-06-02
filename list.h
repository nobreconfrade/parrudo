/*
PRAISE THE SUN
Author: William Pereira
A list for multiple purposes
*/
typedef struct atribute{
	void *data;
	Atribute *next;
	Atribute *before;
}Atribute;
typedef struct list{
	unsigned int sizeList;
	Atribute *head;
}List;

void listBeginning(List l, unsigned int sizeList);
int listIncludeFirst(List *L1, void *data);
int listRemoveFirst(List *L1, void *data);
Atribute *allocAtribute(unsigned int size, void *data);