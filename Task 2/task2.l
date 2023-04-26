%{
//int yylineno = 1;
char datatype[100] = "dummy";
int tl;
char next;
#include <stdio.h>
#include <string.h> 
%}

alpha 		[A-Za-z_]
fl			(f|F|l|L)
ul			(u|U|l|L)* //NOT REQ
digit 		[0-9]
space 		[ ]
hex			[a-fA-F0-9]
exp			[Ee][+-]?{digit}+

%%	
\n   { yylineno++; }
"/*"					{ multicomment(); }
"//"[^\n]*\n					{ singlecomment(); }

"#include<"({alpha})*".h>" {}

"#define"({space})""({alpha})""({alpha}|{digit})*""({space})""({digit})+"" 			{ return DEFINE;}
"#define"({space})""({alpha}({alpha}|{digit})*)""({space})""(({digit}+)\.({digit}+))"" 		{ return DEFINE;}
"#define"({space})""({alpha}({alpha}|{digit})*)""({space})""({alpha}({alpha}|{digit})*)"" 	{ return DEFINE;}

{digit}+    				{  insertToConstTable(yytext, yylineno, "INT"); return CONSTANT; }
({digit}+)\.({digit}+) 			{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
0[xX]{hex}+{ul}?			{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
{digit}+{ul}?				{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
'(\\.|[^\\'])+'				{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
{digit}+{exp}{fl}?			{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
{digit}*"."{digit}+({exp})?{fl}?	{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }
{digit}+"."{digit}*({exp})?{fl}?	{  insertToConstTable(yytext, yylineno, "FLOAT"); return CONSTANT; }

{alpha}?\"(\\.|[^\\"])*\"		{  insertToConstTable(yytext, yylineno, "STRING"); return STRING_LITERAL; } 


"++"			{  return INC_OP; }
"--"			{  return DEC_OP; }

"<="			{  return LE_OP; }
">="			{  return GE_OP; }
"=="			{  return EQ_OP; }
"!="			{  return NE_OP; }
"&&"			{  return AND_OP; }
"||"			{  return OR_OP; }
"*="			{  return MUL_ASSIGN; } 
"/="			{  return DIV_ASSIGN; } 
"%="			{  return MOD_ASSIGN; } 
"+="			{  return ADD_ASSIGN; } 
"-="			{  return SUB_ASSIGN; } 


"auto"			{ return AUTO; }
"break"			{ return BREAK; }
"case"			{ return CASE; }
"char"			{ return CHAR; }
"const"			{ return CONST; }
"continue"		{ return CONTINUE; }
"default"		{ return DEFAULT; }
"do"			{ return DO; }
"double"		{ return DOUBLE; }
"else"			{ return ELSE; }
"enum"			{ return ENUM; }
"extern"		{ return EXTERN; }
"float"			{ strcpy(datatype, "FLOAT"); tl = yylineno; return FLOAT; }
"for"			{ return FOR; }
"goto"			{ return GOTO; }
"if"			{ return IF; }
"int"			{ strcpy(datatype, "INT"); tl = yylineno; return INT; }
"long"			{ return LONG; }
"register"		{ return REGISTER; }
"return"		{ return RETURN; }
"short"			{ return SHORT; }
"signed"		{ return SIGNED; }
"sizeof" 		{ return SIZEOF; }
"static"		{ return STATIC; }
"struct"		{ return STRUCT; }
"switch"		{ return SWITCH; }
"typedef"		{ return TYPEDEF; }
"union"			{ return UNION; }
"unsigned"		{ return UNSIGNED; }
"void"			{ return VOID; }
"volatile"		{ return VOLATILE; }
"while"			{ return WHILE; }


";"			{  strcpy(datatype, "dummy"); return(';'); }
("{"|"<%")		{  return('{'); }
("}"|"%>")		{  return('}'); }
","			{  return(','); }
":"			{  return(':'); }
"="			{  return('='); }
"("			{  return('('); }
")"			{  return(')'); }
("["|"<:")		{  return('['); }
("]"|":>")		{  return(']'); }
"."			{  return('.'); }
"&"			{  return('&'); }
"!"			{  return('!'); }
"~"			{  return('~'); }
"-"			{  return('-'); }
"+"			{  return('+'); }
"*"			{  return('*'); }
"/"			{  return('/'); }
"%"			{  return('%'); }
"<"			{  return('<'); }
">"			{  return('>'); }
"^"			{  return('^'); }
"|"			{  return('|'); }
"?"			{  return('?'); }
"printf"|"scanf"	{ insertToHash(yytext,"PROCEDURE",yylineno); return IDENTIFIER; }
"main" 			{ insertToHash(yytext,"PROCEDURE",yylineno); return IDENTIFIER; }
{alpha}({alpha}|{digit})*    		{  
						if(strcmp(datatype, "dummy")==0)
							return IDENTIFIER;
						else 
						{
							insertToHash(yytext,datatype,yylineno);
							return IDENTIFIER; 
						}
					}
[ \t\v\n\f]		{  }
.			{ /* ignore bad characters */ }
%%

struct dataType 
{
    char * token;
	char * data_type;
	char * our_type;
	int line_num;

} symbol_table[10000];

int row_ctr = 0; // global table row counter

void insert(char* token, char* data_type, char* our_type)
{
	symbol_table[row_ctr].token = strdup(token);
	symbol_table[row_ctr].data_type = strdup(data_type);
	symbol_table[row_ctr].our_type = strdup(our_type);
	symbol_table[row_ctr].line_num = line_num;
	row_ctr++;
}

struct cnode
{
	char num[50];
	//int lno;
	char type[20];
};
struct cnode ctable[100];
int ccount = 0;

void insertToConstTable(char *num, int l, char *type)
{
	strcpy(ctable[ccount].num, num);
	strcpy(ctable[ccount].type, type);
	//ctable[ccount].lno = l;
	ccount++;
}

void disp()
{
	int i;
	printf("\n\n------------------------------CONSTANT TABLE------------------------------\n");
	printf("--------------------------------------------------------------------------\n");
	printf("Value \t\t|\tData Type\t\t\n");
	printf("--------------------------------------------------------------------------\n");
	for(i=0;i<ccount;i++)
	{
		printf("%s\t\t\t", ctable[i].num);
		printf("%s\t\t\t\n", ctable[i].type);
		//printf("\t%d\t\n", ctable[i].lno);
	}
	printf("\n\n");
}



void display()
{
    	struct node *myNode;
    	int i,j, k=1;
    	printf("\n-----------------------------------------Symbol Table---------------------------------------------\n");
    	printf("--------------------------------------------------------------------------------------------------");
    	printf("\nToken \t\t|\tToken Type \t\t\t\t\t \n");
        printf("--------------------------------------------------------------------------------------------------\n");
    	for (i = 0; i < eleCount; i++)
    	{
        	if (hashTable[i].hash_count == 0)
            		continue;
        	myNode = hashTable[i].head;
        	if (!myNode)
            		continue;
        	while (myNode != NULL)
        	{
            		//printf("%d\t\t", k++);
            		printf("%s\t\t\t", myNode->token);
            		printf("%s\t\t\t", myNode->attr);
            		/*for(j=0;j<(myNode->line_count);j++)
            			printf("%d  ",myNode->line[j]);*/
            		printf("\n");
            		myNode = myNode->next;
        	}
	}
	printf("--------------------------------------------------------------------------------------------------\n");
   	return;
}

yywrap()
{
	return(1);
}
multicomment()
{
	char c, c1;
	while ((c = input()) != '*' && c != 0);
	c1=input();
	if(c=='*' && c1=='/')
	{
		c=0;
	}
	if (c != 0)
		putchar(c1);
}
singlecomment()
{
	char c;
	while(c=input()!='\n');
	if(c=='\n')
		c=0;
	if(c!=0)
		putchar(c);
}