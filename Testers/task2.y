%{
    #include <stdio.h>
    #include <stdlib.h>
    #include <string.h>
    #include <ctype.h>
    #include"lex.yy.c"
}%

%token PRINTF SCANF INT FLOAT CHAR FOR WHILE IF ELSE SWITCH TRUE FALSE BREAK CONTINUE RETURN INCLUDE LPAREN RPAREN LBRACE RBRACE LBRACKET RBRACKET SEMICOLON COMMA AND OR NOT ASSIN EQUAL NOTEQUAL GREATER GREATEREQUAL LESSER LESSERQUAL PLUS MINUS MULTIPLY DIVIDE MOD BITAND BITOR BITXOR BITNOT BITLSHIFT BITRSHIFT INCREMENT DECREMENT

%%

Start: Program {printf("Hello, I have reached the End of the program\n"); return 1;}

Program: HeaderFiles Main '(' ')' '{' Body return '}'
        ;

HeaderFiles: HeaderFiles HeaderFiles
            | INCLUDE { add('H'); }
            ;

Main: Datatype ID { add('F'); }
    ;

Datatype: INT { insert_type(); }
        | FLOAT { insert_type(); }
        | CHAR { insert_type(); }
        ;

Body: FOR { add('K'); } '(' Statement ';' Condition ';' Statement ')' '{' Body '}'
    | IF { add('K'); } '(' Condition ')' '{' Body '}' else
    | Statement ';'
    | Body Body 
    | PRINTFF { add('K'); } '(' STR ')' ';'
    | SCANFF { add('K'); } '(' STR ',' '&' ID ')' ';'
    ;

else: ELSE { add('K'); } '{' Body '}'
    |
    ;

Condition: Value RelationalOp Value 
    | TRUE { add('K'); }
    | FALSE { add('K'); }
    |
    ;

Statement: Datatype ID { add('V'); } init
        | ID '=' Expression
        | ID relop Expression
        | ID UNARY
        | UNARY ID
        ;

init: '=' Value
|
;

Expression: Expression Arithmetic Expression
| Value
;

Arithmetic: ADD 
        | SUBTRACT 
        | MULTIPLY
        | DIVIDE
        ;

RelationalOp: LESSER
            | GREATER
            | LESSERQUAL
            | GREATEREQUAL
            | EQUAL
            | NOTEQUAL
            ;

BitwiseOp: BITAND
        | BITOR
        | BITXOR
        | BITNOT
        | BITLSHIFT
        | BITRSHIFT
        ;

Value: NUMBER { add('C'); }
    | FLOAT_NUM { add('C'); }
    | CHARACTER { add('C'); }
    | ID
    ;

return: RETURN { add('K'); } Value ';'
    |
    ;

%%

int main()
{
    yyparse();
    return 0;
}