%{
	int yylineno;
	char data_type[200];
%}

%expect 19
%nonassoc NO_ELSE
%nonassoc  ELSE 
%left '<' '>' '=' GE_OP LE_OP EQ_OP NE_OP 
%left  '+'  '-'
%left  '*'  '/' '%'
%left  '|'
%left  '&'

%token IDENTIFIER CONSTANT STRING_LITERAL SIZEOF
%token PTR_OP INC_OP DEC_OP LEFT_OP RIGHT_OP LE_OP GE_OP EQ_OP NE_OP
%token AND_OP OR_OP MUL_ASSIGN DIV_ASSIGN MOD_ASSIGN ADD_ASSIGN
%token SUB_ASSIGN LEFT_ASSIGN RIGHT_ASSIGN AND_ASSIGN
%token XOR_ASSIGN OR_ASSIGN DEFINE

%token CHAR INT SIGNED UNSIGNED FLOAT CONST VOID
%token CASE DEFAULT IF ELSE SWITCH WHILE FOR GOTO CONTINUE BREAK RETURN
%start Program

%union{
	char str[1000];
}

%%

Program 
    : Begin { printf("-------------REACHED THE END OF THE PROGRAM----------"); }

Begin
	: OutsideMain
	| Begin OutsideMain
	| Define Begin
	;

PrimaryExpression
	: IDENTIFIER { insertToHash($<str>1, data_type , yylineno); }
	| CONSTANT
	| STRING_LITERAL
	| '(' Expression ')'
	;

Define
	: DEFINE
	;

PostfixExpression
	: PrimaryExpression
	| PostfixExpression '[' Expression ']'
	| PostfixExpression '(' ')'
	| PostfixExpression '(' ArgumentExpressionList ')'
	| PostfixExpression '.' IDENTIFIER
	| PostfixExpression PTR_OP IDENTIFIER
	| PostfixExpression INC_OP
	| PostfixExpression DEC_OP
	;

ArgumentExpressionList
	: AssignmentExpression
	| ArgumentExpressionList ',' AssignmentExpression
	;

UnaryExpression
	: PostfixExpression
	| INC_OP UnaryExpression
	| DEC_OP UnaryExpression
	| UnaryOperator CastExpression
	| SIZEOF UnaryExpression
	| SIZEOF '(' type_name ')'
	;

UnaryOperator
	: '&'
	| '*'
	| '+'
	| '-'
	| '~'
	| '!'
	;

CastExpression
	: UnaryExpression
	| '(' type_name ')' CastExpression
	;

MultiplicativeExpression
	: CastExpression
	| MultiplicativeExpression '*' CastExpression
	| MultiplicativeExpression '/' CastExpression
	| MultiplicativeExpression '%' CastExpression
	;

AdditiveExpression
	: MultiplicativeExpression
	| AdditiveExpression '+' MultiplicativeExpression
	| AdditiveExpression '-' MultiplicativeExpression
	;

ShiftExpression
	: AdditiveExpression
	| ShiftExpression LEFT_OP AdditiveExpression
	| ShiftExpression RIGHT_OP AdditiveExpression
	;

RelationalExpression
	: ShiftExpression
	| RelationalExpression '<' ShiftExpression
	| RelationalExpression '>' ShiftExpression
	| RelationalExpression LE_OP ShiftExpression
	| RelationalExpression GE_OP ShiftExpression
	;

EqualityExpression
	: RelationalExpression
	| EqualityExpression EQ_OP RelationalExpression
	| EqualityExpression NE_OP RelationalExpression
	;

AndExpression
	: EqualityExpression
	| AndExpression '&' EqualityExpression
	;

XorExpression
	: AndExpression
	| XorExpression '^' AndExpression
	;

OrExpression
	: XorExpression
	| OrExpression '|' XorExpression
	;

LogicalAndExpression
	: OrExpression
	| LogicalAndExpression AND_OP OrExpression
	;

LogicalOrExpression
	: LogicalAndExpression
	| LogicalOrExpression OR_OP LogicalAndExpression
	;

ConditionalExpression
	: LogicalOrExpression
	| LogicalOrExpression '?' Expression ':' ConditionalExpression
	;

AssignmentExpression
	: ConditionalExpression
	| UnaryExpression AssignmentOperator AssignmentExpression
	;

AssignmentOperator
	: '='
	| MUL_ASSIGN
	| DIV_ASSIGN
	| MOD_ASSIGN
	| ADD_ASSIGN
	| SUB_ASSIGN
	| LEFT_ASSIGN
	| RIGHT_ASSIGN
	| AND_ASSIGN
	| XOR_ASSIGN
	| OR_ASSIGN
	;

Expression
	: AssignmentExpression
	| Expression ',' AssignmentExpression
	;

ConstantExpression
	: ConditionalExpression
	;

Declaration
	: DeclarationSpecifiers ';'
	| DeclarationSpecifiers init_Declarator_list ';'
	;

DeclarationSpecifiers
	: storage_class_specifier
	| storage_class_specifier DeclarationSpecifiers
	| TypeSpecifier	{ strcpy(data_type, $<str>1); }
	| TypeSpecifier DeclarationSpecifiers
	;

init_Declarator_list
	: init_Declarator
	| init_Declarator_list ',' init_Declarator
	;

init_Declarator
	: Declarator
	| Declarator '=' Initializer
	;

// storage_class_specifier
	// : TYPEDEF
	// | EXTERN
	// | STATIC
	// | AUTO
	// | REGISTER
	// ;

TypeSpecifier
	: VOID
	| CHAR
	// | SHORT
	| INT
	// | LONG
	| FLOAT
	// | DOUBLE
	| SIGNED
	| UNSIGNED
	// | struct_or_union_specifier
	;

SpecifierQualifierList
	: TypeSpecifier SpecifierQualifierList
	| TypeSpecifier
	| CONST SpecifierQualifierList
	| CONST
	;

// struct_or_union_specifier
// 	: struct_or_union IDENTIFIER '{' struct_DeclarationList '}' ';'
// 	| struct_or_union '{' struct_DeclarationList '}' ';'
// 	| struct_or_union IDENTIFIER ';'
// 	;

// struct_or_union
// 	: STRUCT
// 	| UNION
// 	;

// struct_DeclarationList
// 	: struct_Declaration
// 	| struct_DeclarationList struct_Declaration
// 	;

// struct_Declaration
// 	: SpecifierQualifierList struct_Declarator_list ';'
// 	;


// struct_Declarator_list
// 	: Declarator
// 	| struct_Declarator_list ',' Declarator
// 	;

Declarator
	: Pointer DirectDeclarator
	| DirectDeclarator
	;

DirectDeclarator
	: IDENTIFIER
	| '(' Declarator ')'
	| DirectDeclarator '[' ConstantExpression ']'
	| DirectDeclarator '[' ']'
	| DirectDeclarator '(' ParameterList ')'
	| DirectDeclarator '(' IdentifierList ')'
	| DirectDeclarator '(' ')'
	;

Pointer
	: '*'
	| '*' Pointer
	;

ParameterList
	: ParameterDeclaration
	| ParameterList ',' ParameterDeclaration
	;

ParameterDeclaration
	: DeclarationSpecifiers Declarator
	| DeclarationSpecifiers
	;

IdentifierList
	: IDENTIFIER
	| IdentifierList ',' IDENTIFIER
	;

type_name
	: SpecifierQualifierList
	| SpecifierQualifierList Declarator
	;

Initializer
	: AssignmentExpression
	| '{' InitializerList '}'
	| '{' InitializerList ',' '}'
	;

InitializerList
	: Initializer
	| InitializerList ',' Initializer
	;

Statement
	: CompoundStatement
	| ExpressionStatement
	| SelectionStatement
	| IterationStatement
	| JumpStatement
	;

CompoundStatement
	: '{' '}'
	| '{' StatementList '}'
	| '{' DeclarationList '}'
	| '{' DeclarationList StatementList '}'
	;

DeclarationList
	: Declaration
	| DeclarationList Declaration
	;

StatementList
	: Statement
	| StatementList Statement
	;

ExpressionStatement
	: ';'
	| Expression ';'
	;

SelectionStatement
	: IF '(' Expression ')' Statement    %prec NO_ELSE
	| IF '(' Expression ')' Statement ELSE Statement
	;

IterationStatement
	: WHILE '(' Expression ')' Statement
	| DO Statement WHILE '(' Expression ')' ';'
	| FOR '(' ExpressionStatement ExpressionStatement ')' Statement
	| FOR '(' ExpressionStatement ExpressionStatement Expression ')' Statement
	;

JumpStatement
	: CONTINUE ';'
	| BREAK ';'
	| RETURN ';'
	| RETURN Expression ';'
	;

OutsideMain
	: FunctionDefinition
	| Declaration
	;

FunctionDefinition
	: DeclarationSpecifiers Declarator DeclarationList CompoundStatement
	| DeclarationSpecifiers Declarator CompoundStatement
	| Declarator DeclarationList CompoundStatement
	| Declarator CompoundStatement
	;
%%

#include "lex.yy.c"
#include <stdio.h>
#include <string.h>
int main(int argc, char *argv[])
{
	yyin = fopen(argv[1], "r");
	if(!yyparse())
		printf("\nParsing complete\n");
	else
		printf("\nParsing failed\n");

	fclose(yyin);
	display();
	disp();
	return 0;
}
//extern int lineno;
extern char *yytext;
yyerror(char *s) {
	printf("\nLine %d : %s\n", (yylineno), s);
}         
