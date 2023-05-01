yacc -d amogh.y  
flex akshat.l
gcc y.tab.c lex.yy.c -ll
./a.out test.c