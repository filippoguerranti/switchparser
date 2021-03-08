/*
 * Variables Table element
 * The Variables Table is a list of entries
 * that represent the variables used by the switch.
 */

typedef struct VarTable
{
    char* varname;  /* symbol name */
    int varvalue;   /* symbol value */
    struct VarTable* next; /* list forward pointer */ 
} vartable;

/******** global variables ********/
vartable* st; /* head of symbol table list */

/******** function prototypes ********/
vartable* GetVar(char* );
vartable* SetVar(char*, int);