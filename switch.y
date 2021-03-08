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
    bool caseMatch = false;
    bool skipAssignment = true;
    vartable* switchVariable = NULL;
    vartable* caseVariable = NULL;
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

assignment  : VAR '=' NUM ';' 
                { 
                    $1->varvalue = $3; 
                }
            ;

zassignment  : VAR '=' NUM ';'
                    {
                        if( !skipAssignment )
                            $1->varvalue = $3; 
                            caseVariable = $1;
                    }

cases   : /* empty */
        | case cases
        | default
        ;

case    : CASE NUM
            {   
                /* check if the switch variable value is equal to the case number */
                if( $2 == switchVariable->varvalue ) 
                {
                    skipAssignment = false;
                    caseMatch = true;
                }
                else skipAssignment = true;
            }
          ':' zassignment BREAK ';'    
            {   
                /* if case match, we exit the switch and assign the value to z */
                if( caseMatch ) 
                {
                    printf("z = %d\n", caseVariable->varvalue);
                    exit(0);
                }
            }
        ;

default : DEFAULT
            {
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