lex switch.l
bison -d switch.y
gcc -o switch switch.tab.c lex.yy.c switch.c -ll