%{
    #include "switch.h"
    /* invlude YACC symbol encoding */
    #include "switch.tab.h"
    int yylex();
%}

%option noyywrap

ID [[:alpha:]]+[[:alphanum:]]*
NUMBER [[:digit:]]+

%%
    vartable* ptr;       /* local variable */

[[:space:]]+            /* skip spaces, tabs and new lines */;
break                   return BREAK;
switch                  return SWITCH;
case                    return CASE;
default                 return DEFAULT;
{ID}                    { 
                            if( (ptr = GetVar(yytext)) == NULL )
                                ptr = PutVar(yytext);
                            yylval.tptr = ptr; 
                            return VAR; 
                        };
{NUMBER}                { 
                            yylval.value = atoi(yytext); 
                            return NUM; 
                        };
.                       return yytext[0]; /* any other character */
%%