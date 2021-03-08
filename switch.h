/*
 * Variables Table element
 * The Variables Table is a list of entries
 * that represent the variables used by the switch.
 */

typedef struct VarTable
{
    char* varname;  /* variable name */
    int varvalue;   /* variable value */
    struct VarTable* next; /* list forward pointer */ 
} vartable;

/******** global variables ********/
vartable* thead; /* head of variable table list */

/******** function prototypes ********/
vartable* GetVar(char* );
vartable* SetVar(char*, int);