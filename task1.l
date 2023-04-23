/*** Definition section ***/
%{
    #include "y.tab.h"
    #include <stdio.h>
    #include <string.h>

    int lineNum = 1;
    /*** Symbol Table structure ***/
    struct Table
    {
        char *symbol;
        char *classtype;
        char *datatype;
        int lineNum;

    } symbolTable[1000];
%}

alphabet [A-Za-z]
digit [0-9]
space [ ]
tab [	]
line [\n]


%%
 /*** Rules section ***/

{space}* {}
{tab}* {}
{line} {lineNum++;} 


printf {return PRINTF;}
scanf {return SCANF;}

int {return INT;}
float {return FLOAT;}
char {return CHAR;}

for {return FOR;}
while {return WHILE;}
if {return IF;}
else {return ELSE;}
switch {return SWITCH;}

true {return TRUE;}
false {return FALSE;}

break {return BREAK;}
continue {return CONTINUE;} 
return {return RETURN;}

^"#include"[ ]*<.+\.h> {return INCLUDE;}

"(" {return LPAREN;}
")" {return RPAREN;}
"{" {return LBRACE;}
"}" {return RBRACE;}
"[" {return LBRACKET;}
"]" {return RBRACKET;}
";" {return SEMICOLON;}
"," {return COMMA;}


"&&" {return AND;}
"||" {return OR;}

"!" {return NOT;}
"=" {return ASSIGN;}

"==" {return EQUAL;}
"!=" {return NOTEQUAL;}
">" {return GREATER;}
">=" {return GREATEREQUAL;}
"<" {return LESSER;}
"<=" {return LESSERQUAL;}

"+" {return PLUS;}
"-" {return MINUS;}
"*" {return MULTIPLY;}
"/" {return DIVIDE;}
"%" {return MOD;}

"&" {return BITAND;}
"|" {return BITOR;}
"^" {return BITXOR;}
"~" {return BITNOT;}
"<<" {return BITLSHIFT;}
">>" {return BITRSHIFT;}

"++" {return INCREMENT;}
"--" {return DECREMENT;}

[-]?{digit}+                { return INTEGER_NUM; }
[-]?{digit}+\.{digit}{1,6}  { return FLOAT_NUM; }
{alphabet}({alphabet}|{digit})*   { return ID; }

%%

/*** C Code section ***/
int yywrap()
{
    return 1;
}