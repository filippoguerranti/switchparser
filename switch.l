%{
    #include "switch.tab.h"
%}
%option noyywrap

%%
[ \t\n]+                /* skip spaces, tabs and new lines */;
break                   return BREAK;
switch                  return SWITCH;
case                    return CASE;
default                 return DEFAULT;
[a-zA-Z][a-zA-Z0-9]*    { yylval.str = strdup(yytext); return VAR; };
[0-9]+                  { yylval.num = atoi(yytext); return NUM; };
.                       return yytext[0];
%%