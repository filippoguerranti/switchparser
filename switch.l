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
    symbtbl* ptr;       /* local variable */

[[:space:]]+            /* skip spaces, tabs and new lines */;
break                   return BREAK;
switch                  return SWITCH;
case                    return CASE;
default                 return DEFAULT;
{ID}                    { 
                            if( (ptr = GetSymb(yytext)) == NULL )
                                ptr = SetSymb(yytext, VAR);
                            yylval.sptr = ptr; 
                            return ptr->type; 
                        };
{NUMBER}                { 
                            yylval.num = atoi(yytext); 
                            return NUM; 
                        };
.                       return yytext[0]; /* any other character */
%%