yacc -d prakhar.y  
flex aditya.l  
gcc y.tab.c lex.yy.c -ll  
./a.out test.c
