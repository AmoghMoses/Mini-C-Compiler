%{

int line_num = 1;
#include<stdio.h>
#include<stdlib.h>
#include<string.h>

char map[100][100]
	= {
		"DUMMY", "BREAK", "CASE", "CHAR", "CONST", "CONTINUE",
		"DEFAULT", "IF", "ELSE", "FLOAT", "FOR", "GOTO", "INT",
		"RETURN", "SIGNED", "SIZEOF", "SWITCH", "UNSIGNED", "VOID",
		"WHILE", "IDENTIFIER", "SLC", "MLCS", "MLCE", "LEQ", "GEQ",
		"EQEQ", "NEQ", "LOR", "LAND", "ASSIGN", "PLUS", "SUB",
		"MULT", "DIV", "MOD", "LESSER", "GREATER", "INCR", "DECR",
		"COMMA", "SEMI", "HEADER", "MAIN", "PRINTF",
		"INT_CONST", "FLOAT_CONST", "TYPE_SPEC", "DQ", "OBO", "OBC",
		"CBO", "CBC", "HASH", "ARR", "FUNC", "NUM_ERR", "UNKNOWN",
		"CHAR_CONST", "SIGNED_CONST", "STRING_CONST","DEFINE" 
	};

#define BREAK 1
#define CASE 2
#define CHAR 3
#define CONST 4
#define CONTINUE 5
#define DEFAULT 6
#define IF 7
#define ELSE 8
#define FLOAT 9
#define FOR 10
#define GOTO 11

#define INT 12
#define RETURN 13
#define SIGNED 14
#define SIZEOF 15
#define SWITCH 16
#define UNSIGNED 17
#define VOID 18
#define WHILE 19

#define IDENTIFIER 20
#define SLC 21
#define MLCS 22
#define MLCE 23

#define LEQ 24
#define GEQ 25
#define EQEQ 26
#define NEQ 27
#define LOR 28
#define LAND 29
#define ASSIGN 30
#define PLUS 31
#define SUB 32
#define MULT 33
#define DIV 34
#define MOD 35
#define LESSER 36
#define GREATER 37
#define INCR 38
#define DECR 39

#define COMMA 40
#define SEMI 41

#define HEADER 42
#define MAIN 43
#define PRINTF 44

#define INT_CONST 45
#define FLOAT_CONST 46
#define TYPE_SPEC 47
#define DQ 48
#define OBO 49
#define OBC 50
#define CBO 51
#define CBC 52
#define HASH 53
#define ARR 54
#define FUNC 55
#define NUM_ERR 56
#define UNKNOWN 57
#define CHAR_CONST 58
#define SIGNED_CONST 59
#define STRING_CONST 60

#define DEFINE 61

struct dataType 
{
	char * token;
	char * data_type;
	char * our_type;
	int line_num;

}symbol_table[10000];

int row_ctr = 0; // global table row counter

void insert(char* token, char* data_type, char* our_type)
{
	symbol_table[row_ctr].token = strdup(token);
	symbol_table[row_ctr].data_type = strdup(data_type);
	symbol_table[row_ctr].our_type = strdup(our_type);
	symbol_table[row_ctr].line_num = line_num;
	row_ctr++;
}

%}

newLine [\n]
alphabet [A-Za-z]
digit [0-9]
space [ ]
underscore [_]
tab [	]
char \'.\'
at [@]
string \"(.^([%d]|[%f]|[%s]|[%c]))\"

%%

{space}* {}
{tab}* {}
{string} return STRING_CONST;
{char} return CHAR_CONST;
{newLine} {line_num++;}

break return BREAK;
case return CASE;
char return CHAR;
const return CONST;
continue return CONTINUE;
default return DEFAULT;
else return ELSE;
float return FLOAT;
for return FOR;
goto return GOTO;
if return IF;
int return INT;
return return RETURN;
signed return SIGNED;
sizeof return SIZEOF;
switch return SWITCH;
unsigned return UNSIGNED;
void return VOID;
while return WHILE;

printf return PRINTF;

{alphabet}({alphabet}|{digit}|{underscore})* return IDENTIFIER;

[+-][0-9]{digit}*(\.{digit}+)? return SIGNED_CONST;

"//"[^\n]* {return SLC;} // CHECK THIS
"/*" { return MLCS;}
"*/" return MLCE;

"<=" return LEQ;
">=" return GEQ;
"==" return EQEQ;
"!=" return NEQ;
"||" return LOR;
"&&" return LAND;
"=" return ASSIGN;
"+" return PLUS;
"-" return SUB;
"*" return MULT;
"/" return DIV;
"%" return MOD;
"<" return LESSER;
">" return GREATER;
"++" return INCR;
"--" return DECR;


"," return COMMA;
";" return SEMI;

^"#include"[ ]*<.+\.h> {return HEADER;}
"main()" return MAIN;

{digit}+ { return INT_CONST;}
([0-9]*)\.([0-9]*) {return FLOAT_CONST;} // NOT WORKING CHECK THIS 

"%d"|"%f"|"%u"|"%s" return TYPE_SPEC;
"\"" return DQ;
"(" return OBO;
")" return OBC;
"{" return CBO;
"}" return CBC;
"#" return HASH;

{alphabet}({alphabet}|{digit}|{underscore})*\[{digit}*\] return ARR;
{alphabet}({alphabet}|{digit}|{underscore})*\(({alphabet}|{digit}|{underscore}|{space})*\) return FUNC;
({digit}+)\.({digit}+)\.({digit}|\.)* return NUM_ERR;
({digit}|{at})+({alphabet}|{digit}|{underscore}|{at})* return UNKNOWN;

%%

// User Code Section

void table_display()
{
	printf("\n\n");
	// printf("\t\t\t\t\tPHASE 1: LEXICAL ANALYSIS \n\n");
	printf("\nSYMBOL\t\t\tDATATYPE\t\t\t\tTYPE\t\t \n");
	printf("_________________________________________________________________________\n\n");
	
	for(int i = 0; i < row_ctr; i++) 
	{
		printf("%s\t\t\t%s\t\t\t\t%s\t\t\t\t\n", symbol_table[i].token, symbol_table[i].data_type, symbol_table[i].our_type);
	}
}

int main()
{
	int scanner, slcline=0, mlc=0, mlcline=0, dq=0, dqline=0;
	yyin = fopen("isPrime.c","r"); //add test case files here

	// printf("HI PRAKHAR\n\n");
	// printf("\n");

	scanner = yylex();

	while(scanner)
	{
		if(line_num == slcline)
		{
			scanner = yylex();
			continue;
		}

		if(line_num!=dqline && dqline!=0)
		{
			if(dq%2!=0)
				printf("\n******** ERROR!! INCOMPLETE STRING at Line %d ********\n\n", dqline);
			dq=0;
		}

		if (mlc == 0)
		{
			switch(scanner)
			{
				case 1:
				case 2:
				case 3:
				case 4:
				case 5:
				case 6:
				case 7:
				case 8:
				case 9:
				case 10:
				case 11:
				case 12:
				case 13:
				case 14:
				case 15:
				case 16:
				case 17:
				case 18:
				case 19:
					// printf("%s\t\t\tKEYWORD\t\t\t\tLine %d\n", yytext, line_num);
					insert(yytext, map[scanner], "KEYWORD");
					break;

				case 20:
					// printf("%s\t\t\tIDENTIFIER\t\t\tLine %d\n", yytext, line_num);
					insert(yytext, map[scanner], "IDENTIFIER");
					break;
					
				case 21:
					// printf("%s\t\t\tSingleline Comment\t\tLine %d\n", yytext, line_num);
					slcline = line_num;
					break;

				case 22:
					//printf("%s\t\t\tMultiline Comment Start\t\tLine %d\n", yytext, line_num);
					mlcline = line_num;
					mlc = 1;
					break;

				case 23:
					//printf("\n******** ERROR!! UNMATCHED MULTILINE COMMENT END %s at Line %d ********\n\n", yytext, line_num);
					break;

				case 24:
				case 25:
				case 26:
				case 27:
				case 28:
				case 29:
				case 30:
				case 31:
				case 32:
				case 33:
				case 34:
				case 35:
				case 36:
				case 37:
				case 38:
				case 39:
					// printf("%s\t\t\tOPERATOR\t\t\tLine %d\n", yytext, line_num);
					insert(yytext, map[scanner], "OPERATOR");
					break;

				case 40:
				case 41:
				case 42:
					// printf("%s\t\t\tSPECIAL SYMBOL\t\t\tLine %d\n", yytext, line_num);
					if(scanner==48)
					{
						dq++;
						dqline = line_num;
					}
					insert(yytext, map[scanner], "SPECIAL SYMBOL");

					if(scanner == 42)
						// printf("%s\tHEADER\t\t\t\tLine %d\n",yytext, line_num);
					break;

				case 43:
					// printf("%s\t\t\tMAIN FUNCTION\t\t\tLine %d\n", yytext, line_num);
					insert(yytext, map[scanner], "IDENTIFIER"); 
					break;
					// CHECK THIS CHECK THIS--------------------------------------------------------------

				case 44:
					// printf("%s\t\t\tPRE DEFINED FUNCTION\t\tLine %d\n", yytext, line_num);
					insert(yytext, map[scanner], "PRE DEFINED FUNCTION");
					break;

				case 45:
					// printf("%s\t\t\tINTEGER CONSTANT\t\tLine %d\n", yytext, line_num);
					insert(yytext, map[scanner], "INTEGER CONSTANT");
					break;
				
				case 46:
					// printf("%s\t\t\t FLOAT CONSTANT\t\tLine %d\n", yytext, line_num);
					insert(yytext, map[scanner], "FLOAT CONSTANT");
					break;

				case 47:
					// printf("%s\t\t\tTYPE SPECIFIER\t\t\tLine %d\n", yytext, line_num);
					break;
				 
				case 49:
				case 50:
				case 51:
				case 52:
				case 53:
					// printf("%s\t\t\tSPECIAL SYMBOL\t\t\tLine %d\n", yytext, line_num);
					if(scanner==48)
					{
						dq++;
						dqline = line_num;
					}
					insert(yytext, map[scanner], "SPECIAL SYMBOL");
	 				break;

				case 54:
					// printf("%s\t\t\tARRAY\t\t\t\tLine %d\n", yytext, line_num);
					insert(yytext, map[scanner], "ARRAY");
					break;
					
				case 55:
					// printf("%s\t\t\tUSER DEFINED FUNCTION\t\tLine %d\n", yytext, line_num);
					insert(yytext, map[scanner], "USER DEFINED FUNCTION");
					break;

				case 56:
					printf("\n******** ERROR!! CONSTANT ERROR %s at Line %d ********\n\n", yytext, line_num);
					break;
				
				case 57:
					printf("\n******** ERROR!! UNKNOWN TOKEN T_%s at Line %d ********\n\n", yytext, line_num);
					break;

				case 58:
					// printf("%s\t\t\tCHARACTER CONSTANT\t\t\tLine %d\n", yytext, line_num);
					insert(yytext, map[scanner], "CHARACTER CONSTANT");
					break;
				
				case 59:
					// printf("%s\t\t\tSIGNED CONSTANT\t\t\tLine %d\n", yytext, line_num);
					insert(yytext, map[scanner], "SIGNED CONSTANT");
					break;

				case 60:
					// printf("%s\t\t\tSTRING CONSTANT\t\t\tLine %d\n", yytext, line_num);
					insert(yytext, map[scanner], "STRING_CONSTANT");
					break;
				
				default:
					break;
			}
		}

		else if(mlc == 1)
		{
			switch(scanner)
			{
				case 21:
					// printf("%s\t\t\tSingleline Comment\t\tLine %d\n", yytext, line_num);
					slcline = line_num;
					break;
					
				case 23:
					mlc = 0;
					//printf("%s\t\t\tMultiline Comment End\t\tLine %d\n", yytext, line_num);
			}
		}
		scanner = yylex();
	}

	if(mlc==1)
		printf("\n******** ERROR!! UNMATCHED COMMENT STARTING at Line %d ********\n\n",mlcline);
	
	printf("\n");

	printf("\n\t******** SYMBOL TABLE ********\t\t\n");
	table_display();
        printf("-------------------------------------------------------------------\n\n");
}

int yywrap()
{
	return 1;
}