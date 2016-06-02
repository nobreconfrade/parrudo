typedef struct atribute{
	void *info;
	Atribute *next;
}Atribute;
typedef struct {
	unsigned int sizeList;
	Atribute *head;
}List;

void listBeginning(List l, unsigned int sizeList)