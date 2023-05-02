yacc -d parser.y  
flex lexer.l
gcc y.tab.c lex.yy.c -ll
./a.out test.c