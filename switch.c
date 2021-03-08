/* Symbol Table management function */

#include <string.h>
#include <stdlib.h>

#include "switch.h"

/* Get a variable from the table */
vartable* GetVar(char* varname)
{
    vartable* ptr;
    /* scan the list of elements */
    for( ptr = thead; ptr != NULL; ptr = ptr->next)
        if( !strcmp(ptr->varname, varname) )
            return ptr;
}

/* Add a variable to the table and set its value */
vartable* SetVar(char* varname)
{
    vartable* ptr;

    if( (ptr = (vartable*)(malloc(sizeof(vartable)))) == NULL )
    {
        return NULL;    /* allocation failed */
    }

    ptr->varname = strdup(varname);
    if( ptr->varname == NULL )
    {
        free(ptr);
        return NULL;    /* allocation failed */
    }

    ptr->varvalue = 0;
    ptr->next = thead;
    thead = ptr;
    return ptr;
}