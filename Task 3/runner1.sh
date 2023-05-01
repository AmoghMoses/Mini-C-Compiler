yacc -d syntaxtree.y  
flex akshat.l
gcc y.tab.c lex.yy.c -ll
./a.out test1.c