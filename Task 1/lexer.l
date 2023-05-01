%{
	#include <stdio.h>
	#include <string.h>
	

	struct Symbol_Table
	{
		char token_name[100];
		char type[100];
		int length;
	}sym_table[10000];
    
    int global_st_rc = 0;


	

	void insert_into_sym_table(char *str1, char *str2)
	{
		
		strcpy(sym_table[global_st_rc].token_name,str1);
		strcpy(sym_table[global_st_rc].type,str2);
		sym_table[global_st_rc].length = strlen(str1);
		global_st_rc++;
		return;
			
	}



	void print_sym_table()
	{
		for(int i = 0 ; i < 10000 ; i++)
		{
			if(sym_table[i].length == 0)
			{
				continue;
			}

			printf("%s\t%s\n",sym_table[i].token_name, sym_table[i].type);
		}
	}



%}

DE "define"
IN "include"

operator [[>][=]|[<][=]|[=][=]|[!][=]|[>]|[<]|[\|][\|]|[&][&]|[\!]|[=]|[\^]|[\+][=]|[\-][=]|[\*][=]|[\/][=]|[\%][=]|[\+][\+]|[\-][\-]|[\+]|[\-]|[\*]|[\/]|[\%]|[&]|[\|]|[~]|[<][<]|[>][>]]


%%
\n   {yylineno++;}
([#][" "]*({IN})[ ]*([<]?)([A-Za-z]+)[.]?([A-Za-z]*)([>]?))/["\n"|\/|" "|"\t"] {printf("%s \t-Pre Processor directive\n",yytext);}	//Matches #include<stdio.h>
([#][" "]*({DE})[" "]*([A-Za-z]+)(" ")*[0-9]+)/["\n"|\/|" "|"\t"] {printf("%s \t-Macro\n",yytext);} //Matches macro
\/\/(.*) {printf("%s \t- SINGLE LINE COMMENT\n", yytext);}				
\/\*([^*]|[\r\n]|(\*+([^*/]|[\r\n])))*\*+\/  {printf("%s \t- MULTI LINE COMMENT\n", yytext);}
[ \n\t] ;
; {printf("%s \t- SEMICOLON \n", yytext);}
, {printf("%s \t- COMMA \n", yytext);}
\{ {printf("%s \t- OPENING BRACES\n", yytext);}
\} {printf("%s \t- CLOSING BRACES\n", yytext);}
\( {printf("%s \t- OPENING BRACKET\n", yytext);}
\) {printf("%s \t- CLOSING BRACKET\n", yytext);}
\[ {printf("%s \t- SQUARE OPENING BRACKET\n", yytext);}
\] {printf("%s \t- SQUARE CLOSING BRACKET\n", yytext);}
\: {printf("%s \t- COLON \n", yytext);}
\\ {printf("%s \t- FORWARD SLASH\n", yytext);}
\. {printf("%s \t- DOT \n", yytext);}
auto|break|char|case|const|continue|default|do|double|else|enum|extern|float|for|goto|if|int|long|return|short|signed|sizeof|static|struct|switch|typedef|union|unsigned|void|while|printf|scanf|main/[\(|" "|\{|;|:|"\n"|"\t"] {printf("%s \t- KEYWORD\n", yytext); insert_into_sym_table(yytext, "KEYWORD");}
\"[^\n]*\"/[;|,|\)] {printf("%s \t- STRING CONSTANT\n", yytext); }
\'[A-Z|a-z]\'/[;|,|\)|:] {printf("%s \t- CHARACTER CONSTANT\n", yytext); }
[a-z|A-Z]([a-z|A-Z]|[0-9])*/\[ {printf("%s \t- ARRAY IDENTIFIER\n", yytext); insert_into_sym_table(yytext, "IDENTIFIER");}

{operator}/[a-z]|[0-9]|;|" "|[A-Z]|\(|\"|\'|\)|\n|\t {printf("%s \t- OPERATOR\n", yytext);} 

[1-9][0-9]*|0/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\]|\}|:|\n|\t|\^] {printf("%s \t- NUMBER CONSTANT\n", yytext); }
([0-9]*)\.([0-9]+)/[;|,|" "|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\t|\^] {printf("%s \t- Floating CONSTANT\n", yytext); }
[A-Za-z_]([A-Za-z_0-9])*/[" "|;|,|\(|\)|<|>|=|\!|\||&|\+|\-|\*|\/|\%|~|\n|\.|\{|\^|\t|\]] {printf("%s \t- IDENTIFIER\n", yytext); insert_into_sym_table(yytext, "IDENTIFIER");}


(.?) {
		if(yytext[0]=='#')
		{
       		printf("Error in Pre-Processor directive at line no. %d\n",yylineno);
       	}
	    else if(yytext[0]=='/')
	    {
       		printf("Error Unmatched COmment at line no. %d\n",yylineno);
       	}
       	else if(yytext[0]=='"')
       	{
       		printf("Error Incomplete String at line no. %d\n",yylineno);
       	}
       	else
       	{
       		printf("ERROR at line no. %d\n",yylineno);
       	}
       	printf("Error : %s\n", yytext);
       	return 0;
}

%%

int main(int argc , char **argv){

	int i;
	for (i=0;i<10000;i++){
		sym_table[i].length=0;
	}

	yyin = fopen(argv[1],"r");
	yylex();
	
	printf("\n\n-------------SYMBOL-TABLE-------------\n\n");
	print_sym_table();

}

int yywrap(){
    return 1;
}