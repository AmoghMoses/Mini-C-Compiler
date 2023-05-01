%{
    #include<stdio.h>
    #include<stdlib.h>
    #include<string.h>
    #include"y.tab.h"

%}

LETTER  [_A-Za-z]
DIGIT   [0-9]

%%

"true"      {yylval.lexeme = strdup(yytext) ;return bool;}
"false"     {yylval.lexeme = strdup(yytext) ;return bool;}
"while"     {yylval.lexeme = strdup(yytext) ;return WHILE;}
"if"        {yylval.lexeme = strdup(yytext) ;return IF;}
"else"      {yylval.lexeme = strdup(yytext) ;return ELSE;}
"int"|"float"|"char"|"void"|"boolean"   {{yylval.lexeme = strdup(yytext) ;return TYPE;}}

","     {yylval.lexeme = strdup(yytext); return COMMA;}
"&&"    {yylval.lexeme = strdup(yytext) ;return LOW_BOOL_OP;}
"||"    {yylval.lexeme = strdup(yytext) ;return LOW_BOOL_OP;}
"("     {yylval.lexeme = strdup(yytext) ;return l_b;}
")"     {yylval.lexeme = strdup(yytext) ;return r_b;}
"{"     {yylval.lexeme = strdup(yytext) ;return l_c;}
"}"     {yylval.lexeme = strdup(yytext) ;return r_c;}
"="     {yylval.lexeme = strdup(yytext) ;return EQUALS;}

("+"|"-")      {yylval.lexeme = strdup(yytext) ;return LOW_OP;}
("*"|"/")      {yylval.lexeme = strdup(yytext) ;return HIGH_OP;}
(">"|"<"|"==") {yylval.lexeme = strdup(yytext) ;return HIGH_BOOL_OP;}

{LETTER}+({LETTER}|{DIGIT})*   {yylval.lexeme = strdup(yytext) ;return id;}
{DIGIT}*                       {yylval.lexeme = strdup(yytext) ;return value;}

[.]     {yylval.lexeme = strdup(yytext) ;return X;}
[\n]
" "
"\t"

%%