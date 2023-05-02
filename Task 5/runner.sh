yacc -d parser.y
lex lexer.l
gcc y.tab.c lex.yy.c -o a.out
./a.out test.c
gcc test.c -o a.out
./a.out