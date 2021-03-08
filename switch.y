/*
 * YACC declarations
 */

%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdbool.h>
    #include <string.h>

    /* custom variable table definition */
    #include "switch.h"

    int yyparse();
    void yyerror(const char*);
    int yylex();

    /* global variables */
    bool exitSwitch = false;            /* true if the switch variable match a case number, so after the assignment we can exit the switch */
    bool skipAssignment = true;         /* true if the case assignment has to be skipped */
    vartable* switchVariable = NULL;    /* switch variable, pointer to vartable */
    vartable* caseVariable = NULL;      /* case variable (a.k.a. z), pointer to vartable */
%}

/********** YACC data types for variables **********/ 

%union 
{
    int value;          /* numeric data */
    vartable* tptr;     /* pointer to the entry in the variable table */
}

/********** YACC tokens **********/ 

%token<value> NUM                   /* int number referred to the value of a variable in an assignment */
%token<tptr> VAR                    /* vartable* referred to the name of a variable in an assignment */
%token SWITCH CASE DEFAULT BREAK    /* program tokens */

%%

/********** grammar rules **********/ 

/* the program is a switch or a series of assignments followed by a switch */
program : switch
        | assignment program
        ;

/* a switch is the token SWITCH followed by a VAR between parenthesis and a block of cases statements */
switch  : SWITCH '(' VAR ')'
            {   
                switchVariable = $3;  /* variable of the switch */
            } 
          '{' cases '}'
        ;

/* an assignment is a VAR followed by an equal sign followed by a NUM */
assignment  : VAR '=' NUM ';' 
                { 
                    /* the variable value is set to the value of NUM */
                    $1->varvalue = $3; 
                }
            ;

/* a zassignment is the assignment of the variable z (the one inside the case) */
zassignment  : VAR '=' NUM ';'
                    {   
                        /* if the assignment has to be skipped we do nothing */
                        if( !skipAssignment )
                            $1->varvalue = $3; 
                            caseVariable = $1;  /* set the case variable (to be printed) */
                    }

/* the block of cases can be empty, can be a default block or a case followed by other cases or default */
cases   : /* empty */
        | case cases
        | default
        ;

/* a case is a CASE token followed by a NUM, a COLON, an assignment of the case variable and a break statement */
case    : CASE NUM
            {   
                /* check if the switch variable value is equal to the case number */
                if( $2 == switchVariable->varvalue ) 
                {
                    /* if the case num matches the switch variable we do the assignment */
                    skipAssignment = false; 
                    exitSwitch = true;
                }
                else skipAssignment = true;
            }
          ':' zassignment BREAK ';'    
            {   
                /* if case match, we exit the switch and assign the value to z */
                if( exitSwitch ) 
                {
                    printf("z = %d\n", caseVariable->varvalue);
                    exit(0);
                }
            }
        ;

/* a default is a DEFAULT token followed by a colon, an assignment of the case variable and a break statement */
default : DEFAULT
            {
                /* if we reach the default statement it means that all the other cases have been checked, so we can make the assignment */
                skipAssignment = false;
            }
          ':' zassignment BREAK ';'
            {
                printf("z = %d\n", caseVariable->varvalue);
                exit(0);
            }
        ;

%%

void yyerror(const char* msg)
{
    printf("%s", msg);
}

int main()
{
    yyparse();
    return 0;
}