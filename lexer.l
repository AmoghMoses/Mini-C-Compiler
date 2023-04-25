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
		"BITAND", "BITOR", "BITXOR", "BITNOT", "BITLSHIFT",
		"BITRSHIFT", "COMMA", "SEMI", "HEADER", "MAIN", "PRINTF",
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
#define BITAND 40
#define BITOR 41
#define BITXOR 42
#define BITNOT 43
#define BITLSHIFT 44
#define BITRSHIFT 45

#define COMMA 46
#define SEMI 47
#define HEADER 48
#define MAIN 49
#define PRINTF 50

#define INT_CONST 51
#define FLOAT_CONST 52
#define TYPE_SPEC 53
#define DQ 54
#define OBO 55
#define OBC 56
#define CBO 57
#define CBC 58
#define HASH 59
#define ARR 60
#define FUNC 61
#define NUM_ERR 62
#define UNKNOWN 63
#define CHAR_CONST 64
#define SIGNED_CONST 65
#define STRING_CONST 66

#define DEFINE 67

%}

alpha [A-Za-z]
digit [0-9]
und [_]
space [ ]
tab [	]
line [\n]
char \'.\'
at [@]
string \"(.^([%d]|[%f]|[%s]|[%c]))\"

%%
{space}* {}
{tab}* {}
{string} return STRING_CONST;
{char} return CHAR_CONST;
{line} {line_num++;}
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

{alpha}({alpha}|{digit}|{und})* return IDENTIFIER;

[+-][0-9]{digit}*(\.{digit}+)? return SIGNED_CONST;

"//" return SLC;
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


"&" {return BITAND;}
"|" {return BITOR;}
"^" {return BITXOR;}
"~" {return BITNOT;}
"<<" {return BITLSHIFT;}
">>" {return BITRSHIFT;}

"," return COMMA;
";" return SEMI;

^"#include"[ ]*<.+\.h> {return HEADER;}
"main()" return MAIN;

{digit}+ return INT_CONST;
({digit}+)\.({digit}+) return FLOAT_CONST;

"%d"|"%f"|"%u"|"%s" return TYPE_SPEC;
"\"" return DQ;
"(" return OBO;
")" return OBC;
"{" return CBO;
"}" return CBC;
"#" return HASH;

{alpha}({alpha}|{digit}|{und})*\[{digit}*\] return ARR;
{alpha}({alpha}|{digit}|{und})*\(({alpha}|{digit}|{und}|{space})*\) return FUNC;
({digit}+)\.({digit}+)\.({digit}|\.)* return NUM_ERR;
({digit}|{at})+({alpha}|{digit}|{und}|{at})* return UNKNOWN;
%%

struct node
{
	char token[100];
    	char attr[100];
	struct node *next;
};

struct hash
{
	struct node *head;
	int count;
};

//from ehre
struct dataType {
	char * token;
	char * data_type;
	char * our_type;
	int line_num;
} symbol_table[10000];

int row_ctr = 0;//glowbal table row counter
void insert(char* token, char* data_type, char* our_type){
	
	// strcpy(symbol_table[row_ctr].token, token);
	symbol_table[row_ctr].token = strdup(token);
	symbol_table[row_ctr].data_type = strdup(data_type);
	symbol_table[row_ctr].our_type = strdup(our_type);
	symbol_table[row_ctr].line_num = line_num;
	row_ctr++;
}


//till here

struct hash hashTable[1000];
int eleCount = 1000;

struct node * createNode(char *token, char *attr)
{
	struct node *newnode;
	newnode = (struct node *) malloc(sizeof(struct node));
	strcpy(newnode->token, token);
	strcpy(newnode->attr, attr);
	newnode->next = NULL;
	return newnode;
}

int hashIndex(char *token)
{
	int hi=0;
	int l,i;
	for(i=0;token[i]!='\0';i++)
	{
		hi = hi + (int)token[i];
	}
	hi = hi%eleCount;
	return hi;
}

void insertToHash(char *token, char *attr)
{
	int flag=0;
	int hi;
	hi = hashIndex(token);
	struct node *newnode = createNode(token, attr);
	/* head of list for the bucket with index "hashIndex" */
	if (hashTable[hi].head==NULL)
	{
		hashTable[hi].head = newnode;
	        hashTable[hi].count = 1;
	        return;
	}
	struct node *myNode;
    	myNode = hashTable[hi].head;
	while (myNode != NULL)
    	{
        	if (strcmp(myNode->token, token)==0)
        	{
            		flag = 1;
            		break;
        	}
        	myNode = myNode->next;
    	}
	if(!flag)
	{
		//adding new node to the list
		newnode->next = (hashTable[hi].head);
		//update the head of the list and no of nodes in the current bucket
		hashTable[hi].head = newnode;
		hashTable[hi].count++;
	}
	return;
}

void display()
{
    	struct node *myNode;
    	int i,j, k=1;
    	printf("-------------------------------------------------------------------");
    	printf("\nSNo \t|\tToken \t\t|\tToken Type \t\n");
        printf("-------------------------------------------------------------------\n");
    	for (i = 0; i < eleCount; i++)
    	{
        	if (hashTable[i].count == 0)
            		continue;
        	myNode = hashTable[i].head;
        	if (!myNode)
            		continue;
        	while (myNode != NULL)
        	{
					if(strcmp(myNode->attr,"SPECIAL SYMBOL")==0)
					{
						printf("%d\t\t", k++);
            			printf("T_%s\t\t\t", myNode->token);
            			printf("%d\t\n", *myNode->token);
					}
					else
					{
						printf("%d\t\t", k++);
						printf("T_%s\t\t\t", myNode->token);
						printf("%s\t\n", myNode->attr);
					}
            		myNode = myNode->next;
        	}
	}
   	return;
}

void table_display()
{
	printf("\n\n");
	printf("\t\t\t\t\tPHASE 1: LEXICAL ANALYSIS \n\n");
	printf("\nSYMBOL\t\t\tDATATYPE\t\t\t\tTYPE\t\t\t\tLINE NUMBER \n");
	// printf("%s\t\t\tIDENTIFIER\t\t\tLine %d\n", yytext, line_num);
	printf("_________________________________________________________________________________________________________________\n\n");
	for(int i = 0; i < row_ctr; i++) 
	{
		printf("%s\t\t\t%s\t\t\t\t%s\t\t\t\t %d\t\n", symbol_table[i].token, symbol_table[i].data_type, symbol_table[i].our_type, symbol_table[i].line_num);
	}

	// for(int i = 0; i < row_ctr; i++) 
	// {
	// 	printf("%s\t\n", symbol_table[i].token);
	// }
}


int main()
{
	int scanner, slcline=0, mlc=0, mlcline=0, dq=0, dqline=0;
	yyin = fopen("isPrime.c","r"); //add test case files here
	printf("\n\n");
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

		// checking from here
		
		if((scanner>=1 && scanner<=19) && mlc==0)
		{
			printf("%s\t\t\tKEYWORD\t\t\t\tLine %d\n", yytext, line_num);
			insert(yytext, map[scanner], "KEYWORD");
		}
		if(scanner==20 && mlc==0) 
		{
			printf("%s\t\t\tIDENTIFIER\t\t\tLine %d\n", yytext, line_num);
			insert(yytext, map[scanner], "IDENTIFIER");
		}
		if(scanner==21)
		{
			//printf("%s\t\t\tSingleline Comment\t\tLine %d\n", yytext, line_num);
			slcline = line_num;
		}
		if(scanner==22 && mlc==0)
		{
			//printf("%s\t\t\tMultiline Comment Start\t\tLine %d\n", yytext, line_num);
			mlcline = line_num;
			mlc = 1;
		}
		if(scanner==23 && mlc==0)
		{
			//printf("\n******** ERROR!! UNMATCHED MULTILINE COMMENT END %s at Line %d ********\n\n", yytext, line_num);
		}
		if(scanner==23 && mlc==1)
		{
			mlc = 0;
			//printf("%s\t\t\tMultiline Comment End\t\tLine %d\n", yytext, line_num);
		}
		if((scanner>=24 && scanner<=45) && mlc==0)
		{
			printf("%s\t\t\tOPERATOR\t\t\tLine %d\n", yytext, line_num);
			insert(yytext, map[scanner], "OPERATOR");
		}
		if((scanner==46||scanner==47||scanner==54||(scanner>=55 && scanner<=59)) && mlc==0)
		{
			printf("%s\t\t\tSPECIAL SYMBOL\t\t\tLine %d\n", yytext, line_num);
			if(scanner==54)
			{
				dq++;
				dqline = line_num;
			}
			insert(yytext, map[scanner], "SPECIAL SYMBOL");
		}
		if(scanner==48 && mlc==0)
		{
			printf("%s\tHEADER\t\t\t\tLine %d\n",yytext, line_num);
		}
		if(scanner==49 && mlc==0)
		{
			printf("%s\t\t\tMAIN FUNCTION\t\t\tLine %d\n", yytext, line_num);
			insert(yytext, map[scanner], "IDENTIFIER"); 
			// CHECK THIS CHECK THIS--------------------------------------------------------------
		}
		if(scanner==50 && mlc==0)
		{
			printf("%s\t\t\tPRE DEFINED FUNCTION\t\tLine %d\n", yytext, line_num);
			insert(yytext, map[scanner], "PRE DEFINED FUNCTION");
		}
		if(scanner==67 && mlc==0) // for define
		{
			printf("%s\t\t\tPRE PROCESSOR DIRECTIVE\t\tLine %d\n", yytext, line_num);
		}
		if(scanner==51 && mlc==0)
		{
			printf("%s\t\t\tINTEGER CONSTANT\t\tLine %d\n", yytext, line_num);
			insert(yytext, map[scanner], "INTEGER CONSTANT");
		}
		if(scanner==53 && mlc==0)
		{
			printf("%s\t\t\tTYPE SPECIFIER\t\t\tLine %d\n", yytext, line_num);
		}
		if(scanner==60 && mlc==0)
		{
			printf("%s\t\t\tARRAY\t\t\t\tLine %d\n", yytext, line_num);
			insert(yytext, map[scanner], "ARRAY");
		}
		if(scanner==61 && mlc==0)
		{
			printf("%s\t\t\tUSER DEFINED FUNCTION\t\tLine %d\n", yytext, line_num);
			insert(yytext, map[scanner], "USER DEFINED FUNCTION");
		}
		if(scanner==62 && mlc==0)
		{
			printf("\n******** ERROR!! CONSTANT ERROR %s at Line %d ********\n\n", yytext, line_num);
		}
		if(scanner==63 && mlc==0)
		{
			printf("\n******** ERROR!! UNKNOWN TOKEN T_%s at Line %d ********\n\n", yytext, line_num);
		}
		if(scanner==64 && mlc==0)
		{
			printf("%s\t\t\tCHARACTER CONSTANT\t\t\tLine %d\n", yytext, line_num);
			insert(yytext, map[scanner], "CHARACTER CONSTANT");
		}
		if(scanner==65 && mlc==0)
		{
			printf("%s\t\t\tSIGNED CONSTANT\t\t\tLine %d\n", yytext, line_num);
			insert(yytext, map[scanner], "SIGNED CONSTANT");
		}
		if(scanner==66 && mlc==0)
		{
			printf("%s\t\t\tSTRING CONSTANT\t\t\tLine %d\n", yytext, line_num);
			insert(yytext, map[scanner], "STRING_CONSTANT");
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