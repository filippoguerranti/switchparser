%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <stdbool.h>    // to handle boolean variables
    #include <string.h>

    int yyparse();
    void yyerror(const char* s);
    int yylex();

    /********** GLOBAL VARIABLES **********/ 

    #define VAR_NUMBER 3    // number of variables that are accepted in the code to be parsed

    // variable struct which handle the name and the value of a variable inside the code to be parsed
    typedef struct {
        char* varname;
        int  varvalue;
    } variable;

    variable switch_var;            // variable used by the switch
    variable v[VAR_NUMBER];         // array of variables used in the code
    int assignCounter = 0;          // counter for the number of assignments 
    bool assignmentSkip = false;    // boolean flag used to skip the assignment in the case(s) of the switch
    bool switchExit = false;        // boolean flag used to exit the switch
    bool isDefault = false;         // boolean flag used to indicate that the switch must go to "default"
%}

/********** YACC TOKENS **********/ 

%union {
    int   num;
    char* str;
}

%token<num> NUM                     // int number referred to the value of a variable in an assignment
%token<str> VAR                     // char* string referred to the name of a variable in an assignment
%token SWITCH CASE DEFAULT BREAK    // program tokens

%%

/********** GRAMMAR DEFINITION **********/ 

program     :   switch
            |   assignment program
            ;

switch      :   SWITCH '(' VAR ')'  {   
                                        switch_var.varname = $3;    // name of the variable of the switch
                                        switch_var.varvalue = 0;    /* initialization of the variable value 
                                                                       (in case of no assignment before switch) */
                                        
                                        int i;
                                        // loop over the already initialized variables to check the value of the switch variable
                                        for (i = 0; i < assignCounter; i++){
                                            if (strcmp(switch_var.varname,v[i].varname) == 0){
                                                switch_var.varvalue = v[i].varvalue;
                                            }
                                        }
                                    } 
                                    '{' cases '}'
            ;

assignment  :   VAR '=' NUM ';'     {   // if the number of assignments is greater than the number of admissible variable, exit with error.
                                        if ((assignCounter + 1) > VAR_NUMBER){  
                                            yyerror("error: the number of variables must be <= 3.");
                                            exit(1);
                                        }
                                        /* if the assignment has to be skipped (due to already matched case inside switch) do nothing,
                                           else assign the value to the variable */
                                        if (!assignmentSkip){
                                            v[assignCounter].varname = $1;
                                            v[assignCounter].varvalue = $3;
                                            // this if is matched by the assignments before the switch
                                            if (!switchExit) assignCounter++;
                                        }
                                        // if the switch variable value is not in one the cases, go to default
                                        if (isDefault){
                                            printf("z = %d\n", $3);
                                            exit(0);
                                        }
                                    }
            ;

cases       :   /* empty */
            |   case cases
            |   default
            ;

case        :   CASE NUM    {   // check if the switch variable value is equal to the case number
                                if ($2 == switch_var.varvalue) {
                                    assignmentSkip = false;
                                    switchExit = true;
                                }
                                else assignmentSkip = true;
                            }
                            ':' assignment BREAK ';'    
                            {   // in case of case match, we exit the switch and assign the value to z
                                if (switchExit) {
                                    printf("z = %d\n", v[assignCounter].varvalue);
                                    exit(0);
                                }
                            }
            ;

default     :   DEFAULT     {
                                isDefault = true;
                            }
                            ':' assignment BREAK ';'
            ;

%%

void yyerror(const char *msg)
{
    printf("%s", msg);
}

int main()
{
    yyparse();
    return 0;
}