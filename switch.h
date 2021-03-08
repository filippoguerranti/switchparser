/*
 * Symbol Table element
 * The Symbol Table is a list of entries
 * that represent the variables used by the switch.
 */

typedef struct SymbTbl
{
    char* varname;  /* symbol name */
    int varvalue;   /* symbol value */
    struct SymbTbl* next; /* list forward pointer */ 
} symbtbl;

/******** global variables ********/
symbtbl* st; /* head of symbol table list */

/******** function prototypes ********/
symbtbl* GetSymb(char* );
symbtbl* PutSymb(char*, int);