yacc -d old.y  
flex old.l
gcc y.tab.c lex.yy.c -ll
./a.out test1.c