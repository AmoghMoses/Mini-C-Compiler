%{
	void yyerror(char* s);
	int yylex();
	#include "stdio.h"
	#include "stdlib.h"
	#include "ctype.h"
	#include "string.h"
	#include "stdarg.h"
	void ins();
	void insV();
	int flag=0;


	#define ANSI_COLOR_RED		"\x1b[31m"
	#define ANSI_COLOR_GREEN	"\x1b[32m"
	#define ANSI_COLOR_CYAN		"\x1b[36m"
	#define ANSI_COLOR_RESET	"\x1b[0m"
	extern char curid[20];
	extern char curtype[20];
	extern char curval[20];
	extern int currnest;
	void deletedata (int );
	int checkscope(char*);
	int check_id_is_func(char *);
	void insertST(char*, char*);
	void insertSTnest(char*, int);
	void insertSTparamscount(char*, int);
	int getSTparamscount(char*);
	int check_duplicate(char*);
	int check_declaration(char*, char *);
	int check_params(char*);
	int duplicate(char *s);
	int checkarray(char*);
	char currfunctype[100];
	char currfunc[100];
	char currfunccall[100];
	void insertSTF(char*);
	char gettype(char*,int);
	char getfirst(char*);
	extern int params_count;
	int call_params_count;

	struct ast_node {
		char* type;       // type of the node (e.g. operator, literal, variable)
		char* value;    // value of the node (e.g. "+", "42", "x")
		int num_children;   // number of children of the node
		struct ast_node** children; // array of pointers to the node's children

	};
    struct ast_node* root_node;

	struct ast_node* create_ast_node(char* type, char* value, int num_children, ...) {
		struct ast_node* node = malloc(sizeof(struct ast_node));
		node->type = type;
		node->value = value;
		node->num_children = num_children;
		node->children = malloc(sizeof(struct ast_node*) * num_children);
		va_list args;
		va_start(args, num_children);
		for (int i = 0; i < num_children; i++) {
			node->children[i] = va_arg(args, struct ast_node*);
		}
		va_end(args);
		return node;
	}

	void add_child_node(struct ast_node* parent, struct ast_node* child) {
        if (parent == NULL || child == NULL) {
            return;
        }
        int num_children = parent->num_children;
        parent->children = realloc(parent->children, sizeof(struct ast_node*) * (num_children + 1));
        parent->children[num_children] = child;
        parent->num_children++;
    }

	void print_ast(struct ast_node* node, int depth) {
    if (node == NULL) {
        return;
    }
    for (int i = 0; i < depth; i++) {
        printf("  "); // print two spaces for each level of depth
    }
    printf("%s", node->type);
    if (node->value != NULL) {
        printf(" (%s)", node->value);
    }
    printf("\n");
    for (int i = 0; i < node->num_children; i++) {
        print_ast(node->children[i], depth + 1);
    }
}

%}

%nonassoc IF
%token INT CHAR FLOAT DOUBLE LONG SHORT SIGNED UNSIGNED STRUCT
%token RETURN MAIN
%token VOID
%token WHILE FOR DO 
%token BREAK PRINTF CONTINUE


%token ENDIF
%expect 1 

%token identifier array_identifier
%token integer_constant string_constant float_constant character_constant

%nonassoc ELSE

%right leftshift_assignment_operator rightshift_assignment_operator
%right XOR_assignment_operator OR_assignment_operator
%right AND_assignment_operator modulo_assignment_operator
%right multiplication_assignment_operator division_assignment_operator
%right addition_assignment_operator subtraction_assignment_operator
%right assignment_operator

%left OR_operator
%left AND_operator
%left pipe_operator
%left caret_operator
%left amp_operator
%left equality_operator inequality_operator
%left lessthan_assignment_operator lessthan_operator greaterthan_assignment_operator greaterthan_operator
%left leftshift_operator rightshift_operator 
%left add_operator subtract_operator
%left multiplication_operator division_operator modulo_operator

%right SIZEOF
%right tilde_operator exclamation_operator
%left increment_operator decrement_operator 


%start program 

%%
program
			: declaration_list {
				root_node = create_ast_node("program", NULL, 1, $1);
			    }
			;

declaration_list
			: declaration D {
                $$ = create_ast_node("declaration_list", NULL, 2, $1, $2);
            };

D
			: declaration_list { $$ = create_ast_node("D", NULL, 1, $1); }
			| { $$ = create_ast_node("", NULL, 0); };

declaration
			: variable_declaration { $$ = create_ast_node("declaration", NULL, 1, $1); }
			| function_declaration { $$ = create_ast_node("declaration", NULL, 1, $1); };

variable_declaration
			: type_specifier variable_declaration_list ';' { $$ = create_ast_node("variable_declaration", NULL, 3, $1, $2, $3); };

variable_declaration_list
			: variable_declaration_identifier V { $$ = create_ast_node("variable_declaration_list", NULL, 2, $1, $2); };
 
V
			: ',' variable_declaration_list { $$ = create_ast_node("V", NULL, 2, $1, $2); }
			| { $$ = create_ast_node("", NULL, 0); };

variable_declaration_identifier 
			: identifier {if(duplicate(curid)){printf("Duplicate\n");exit(0);}insertSTnest(curid,currnest); ins();  } vdi { $$ = create_ast_node("variable_declaration_identifier", NULL, 2, $1, $2); }
			| array_identifier {if(duplicate(curid)){printf("Duplicate\n");exit(0);}insertSTnest(curid,currnest); ins();  } vdi { $$ = create_ast_node("variable_declaration_identifier", NULL, 2, $1, $2); };
			
			
//Handle
vdi 
    : identifier_array_type { $$ = create_ast_node("vdi", NULL, 1, $1); }
	| identifier_twod_array_type   { $$ = create_ast_node("vdi", NULL, 1, $1); }
	| assignment_operator expression {  $$ = create_ast_node("vdi", NULL, 2, $1, $2); }
    | { $$ = create_ast_node("", NULL, 0); };

//Handle

array_random_access
	: array_identifier '[' array_random_access_breakup ']' { $$ = create_ast_node("array_random_access", NULL, 4, $1, $2, $3, $4); }
	| array_identifier '[' array_random_access_breakup ']' '[' array_random_access_breakup ']'{ $$ = create_ast_node("array_random_access", NULL, 7, $1, $2, $3, $4, $5, $6, $7);};

array_random_access_breakup
	: integer_constant { $$ = create_ast_node("array_random_access_breakup", NULL, 1, $1); }
	| identifier { $$ = create_ast_node("array_random_access_breakup", NULL, 1, $1); }
	| array_random_access { $$ = create_ast_node("array_random_access_breakup", NULL, 1, $1); };
	| expression; { $$ = create_ast_node("array_random_access_breakup", NULL, 1, $1); };

identifier_array_type
			: '[' initialization_params { $$ = create_ast_node("identifier_array_type", NULL, 2, $1, $2); };

identifier_twod_array_type
			: '[' integer_constant ']' '[' initialization_params_new { $$ = create_ast_node("identifier_twod_array_type", NULL, 5, $1, $2, $3, $4, $5); };
			| '[' identifier ']' '[' initialization_params_new { $$ = create_ast_node("identifier_twod_array_type", NULL, 5, $1, $2, $3, $4, $5); };
			| '[' ']' '[' initialization_params_new { $$ = create_ast_node("identifier_twod_array_type", NULL, 4, $1, $2, $3, $4); }; 

//Handle
initialization_params_new
			: initialization_params_2d ']' initialization_2d { $$ = create_ast_node("initialization_params_new", NULL, 3, $1, $2, $3); }
			| initialization_params_2d ']' { $$ = create_ast_node("initialization_params_new", NULL, 2, $1, $2); };
 
initialization_params_2d
			: integer_constant { $$ = create_ast_node("initialization_params_2d", NULL, 1, $1); }
			| identifier { $$ = create_ast_node("initialization_params_2d", NULL, 1, $1); };

initialization_params
			: integer_constant ']' initialization { $$ = create_ast_node("initialization_params", NULL, 3, $1, $2, $3); }
			| ']' initialization { $$ = create_ast_node("initialization_params", NULL, 2, $1, $2); }
			| ']' string_initialization; { $$ = create_ast_node("initialization_params", NULL, 2, $1, $2); };

initialization
			: string_initialization { $$ = create_ast_node("initialization", NULL, 1, $1); }
			| array_initialization { $$ = create_ast_node("initialization", NULL, 1, $1); }
			| { $$ = create_ast_node("", NULL, 0); };

initialization_2d 
			: assignment_operator '{' array_init_int_2d '}' { $$ = create_ast_node("initialization_2d", NULL, 4, $1, $2, $3, $4); }
			| assignment_operator '{' array_init_float_2d '}' { $$ = create_ast_node("initialization_2d", NULL, 4, $1, $2, $3, $4); }
			| assignment_operator '{' array_init_string_2d '}'{ $$ = create_ast_node("initialization_2d", NULL, 4, $1, $2, $3, $4); };

array_init_int_2d
			: '{' array_int_declarations '}' ',' array_init_int_2d { $$ = create_ast_node("array_init_int_2d", NULL, 4, $1, $2, $3, $4); }
			| '{' array_int_declarations '}' { $$ = create_ast_node("array_init_int_2d", NULL, 2, $1, $2); }
			| integer_constant { $$ = create_ast_node("array_init_int_2d", NULL, 1, $1); }};

array_init_float_2d
			: '{' array_float_declarations '}' ',' array_init_float_2d { $$ = create_ast_node("array_init_float_2d", NULL, 5, $1, $2, $3, $4, $5); }
			| '{' array_float_declarations '}' { $$ = create_ast_node("array_init_float_2d", NULL, 3, $1, $2, $3); }
			| integer_constant { $$ = create_ast_node("array_init_float_2d", NULL, 1, $1); }
			| float_constant { $$ = create_ast_node("array_init_float_2d", NULL, 1, $1); };

array_init_string_2d 
			: string_constant ',' array_init_string_2d { $$ = create_ast_node("array_init_string_2d", NULL, 3, $1, $2, $3); }
			| string_constant { $$ = create_ast_node("array_init_string_2d", NULL, 1, $1); };

type_specifier 
			: INT { $$ = create_ast_node("type_specifier", NULL, 1, $1); }
            | CHAR { $$ = create_ast_node("type_specifier", NULL, 1, $1); }
            | FLOAT  { $$ = create_ast_node("type_specifier", NULL, 1, $1); }
            | DOUBLE { $$ = create_ast_node("type_specifier", NULL, 1, $1); }
			| LONG long_grammar { $$ = create_ast_node("type_specifier", NULL, 2, $1, $2); }
			| SHORT short_grammar { $$ = create_ast_node("type_specifier", NULL, 2, $1, $2); }
			| UNSIGNED unsigned_grammar { $$ = create_ast_node("type_specifier", NULL, 2, $1, $2); }
			| SIGNED signed_grammar { $$ = create_ast_node("type_specifier", NULL, 2, $1, $2);}
			| VOID  { $$ = create_ast_node("type_specifier", NULL, 1, $1); };

unsigned_grammar 
			: INT { $$ = create_ast_node("unsigned_grammar", NULL, 1, $1); }
            | LONG long_grammar { $$ = create_ast_node("unsigned_grammar", NULL, 2, $1, $2); }
            | SHORT short_grammar { $$ = create_ast_node("unsigned_grammar", NULL, 2, $1, $2); }
            | { $$ = create_ast_node("", NULL, 0);};

signed_grammar 
			: INT { $$ = create_ast_node("signed_grammar", NULL, 1, $1); }
            | LONG long_grammar { $$ = create_ast_node("signed_grammar", NULL, 2, $1, $2); }
            | SHORT short_grammar { $$ = create_ast_node("signed_grammar", NULL, 2, $1, $2); }
            | { $$ = create_ast_node("", NULL, 0);};

long_grammar 
			: INT  { $$ = create_ast_node("long_grammar", NULL, 1, $1); }
            | { $$ = create_ast_node("", NULL, 0);};

short_grammar 
			: INT { $$ = create_ast_node("short_grammar", NULL, 1, $1); }
            | { $$ = create_ast_node("", NULL, 0);};

function_declaration
			: function_declaration_type function_declaration_param_statement { $$ = create_ast_node("function_declaration", NULL, 2, $1, $2); }};

function_declaration_type
			: type_specifier identifier '('  { strcpy(currfunctype, curtype); strcpy(currfunc, curid); check_duplicate(curid); insertSTF(curid); ins(); $$ = create_ast_node("function_declaration_type", NULL, 3, $1, $2, $3);};

function_declaration_param_statement
			: params ')' statement { $$ = create_ast_node("function_declaration_param_statement", NULL, 3, $1, $2, $3); }};

params 
			: parameters_list { $$ = create_ast_node("params", NULL, 1, $1); }
            | { $$ = create_ast_node("", NULL, 0);};

parameters_list 
			: type_specifier { check_params(curtype); } parameters_identifier_list { insertSTparamscount(currfunc, params_count); };

parameters_identifier_list 
			: param_identifier parameters_identifier_list_breakup { $$ = create_ast_node("parameters_identifier_list", NULL, 2, $1, $2); };

parameters_identifier_list_breakup
			: ',' parameters_list { $$ = create_ast_node("parameters_identifier_list_breakup", NULL, 1, $1); }}
			| { $$ = create_ast_node("", NULL, 0); };

param_identifier 
			: identifier { ins();insertSTnest(curid,1); params_count++; } param_identifier_breakup { $$ = create_ast_node("param_identifier", NULL, 2, $1, $2); };

param_identifier_breakup
			: '[' ']' { $$ = create_ast_node("param_identifier_breakup", NULL, 2, $1, $2); }
			| { $$ = create_ast_node("", NULL, 0); };

statement 
			: expression_statment { $$ = create_ast_node("statement", NULL, 1, $1);}
			| compound_statement { $$ = create_ast_node("statement", NULL, 1, $1);}
			| conditional_statements { $$ = create_ast_node("statement", NULL, 1, $1);}
			| iterative_statements { $$ = create_ast_node("statement", NULL, 1, $1);}
			| return_statement { $$ = create_ast_node("statement", NULL, 1, $1);}
			| break_statement { $$ = create_ast_node("statement", NULL, 1, $1);}
			| continue_statement { $$ = create_ast_node("statement", NULL, 1, $1);}
			| variable_declaration { $$ = create_ast_node("statement", NULL, 1, $1);}
			| printf_statement; { $$ = create_ast_node("statement", NULL, 1, $1);}

compound_statement 
			: {currnest++;} '{'  statment_list  '}' {deletedata(currnest);currnest--;} { $$ = create_ast_node("compound_statement", NULL, 3, $1, $2, $3);} ;

statment_list 
			: statement statment_list { $$ = create_ast_node("statment_list", NULL, 2, $1, $2); }
			| { $$ = create_ast_node("", NULL, 0); };

expression_statment 
			: expression ';' { $$ = create_ast_node("expression_statment", NULL, 2, $1, $2);}
			| ';' { $$ = create_ast_node("expression_statment", NULL, 1, $1);};

conditional_statements 
			: IF '(' simple_expression ')' {if($3!=1){printf("Condition checking is not of type int\n");exit(0);}} statement conditional_statements_breakup { $$ = create_ast_node("conditional_statements", NULL, 6, $1, $2, $3, $4, $5, $6); };

conditional_statements_breakup
			: ELSE statement { $$ = create_ast_node("conditional_statements_breakup", NULL, 2, $1, $2); }
			| { $$ = create_ast_node("", NULL, 0);} ;

iterative_statements 
			: WHILE '(' simple_expression ')' {if($3!=1){printf("Condition checking is not of type int\n");exit(0);}} statement { $$ = create_ast_node("iterative_statements", NULL, 5, $1, $2, $3, $4, $5);}
			| FOR '(' expression ';' simple_expression ';' {if($5!=1){printf("Condition checking is not of type int\n");exit(0);}} expression ')' { $$ = create_ast_node("iterative_statements", NULL, 8, $1, $2, $3, $4, $5, $6, $7, $8);}
			| DO statement WHILE '(' simple_expression ')'{if($5!=1){printf("Condition checking is not of type int\n");exit(0);}} ';' { $$ = create_ast_node("iterative_statements", NULL, 7, $1, $2, $3, $4, $5, $6, $7);};

return_statement 
			: RETURN ';' {if(strcmp(currfunctype,"void")) {printf("Returning void of a non-void function\n"); exit(0);} $$ = create_ast_node("return_statement", NULL, 2, $1, $2);}
			| RETURN expression ';' { 	if(!strcmp(currfunctype, "void"))
										{ 
											yyerror("Function is void");
										}

										if((currfunctype[0]=='i' || currfunctype[0]=='c') && $2!=1)
										{
											printf("Expression doesn't match return type of function\n"); exit(0);
										}
			              
			                     	$$ = create_ast_node("return_statement", NULL, 3, $1, $2, $3);
                                    };
//Handle Semantics
printf_statement
			: PRINTF '(' string_constant printf_identifier_list ')' ';'{ $$ = create_ast_node("printf_statement", NULL, 6, $1, $2, $3, $4, $5, $6); };

printf_identifier_list
			: ',' identifier printf_identifier_list { $$ = create_ast_node("printf_identifier_list", NULL, 3, $1, $2, $3); }
			| ',' array_random_access printf_identifier_list { $$ = create_ast_node("printf_identifier_list", NULL, 3, $1, $2, $3); }
			| { $$ = create_ast_node("", NULL, 0); };

continue_statement
			: CONTINUE ';' { $$ = create_ast_node("continue_statement", NULL, 2, $1, $2); }};

break_statement 
			: BREAK ';' { $$ = create_ast_node("break_statement", NULL, 2, $1, $2); };

string_initialization
			: assignment_operator string_constant {insV(); $$ = create_ast_node("string_initialization", NULL, 2, $1, $2); };

array_initialization
			: assignment_operator '{' array_int_declarations '}' { $$ = create_ast_node("array_initialization", NULL, 4, $1, $2, $3, $4); }
			| assignment_operator '{' array_float_declarations '}' { $$ = create_ast_node("array_initialization", NULL, 4, $1, $2, $3, $4); };

array_int_declarations
			: integer_constant array_int_declarations_breakup; { $$ = create_ast_node("array_int_declarations", NULL, 2, $1, $2); }

array_float_declarations
			: float_constant array_float_declarations_breakup { $$ = create_ast_node("array_float_declarations", NULL, 2, $1, $2); };
			| integer_constant array_float_declarations_breakup { $$ = create_ast_node("array_float_declarations", NULL, 2, $1, $2);};

array_int_declarations_breakup
			: ',' array_int_declarations { $$ = create_ast_node("array_int_declarations_breakup", NULL, 2, $1, $2);}
			| { $$ = create_ast_node("", NULL, 0);};

array_float_declarations_breakup
			: ',' array_float_declarations { $$ = create_ast_node("array_float_declarations_breakup", NULL, 2, $1, $2);}
			| { $$ = create_ast_node("", NULL, 0);};

expression 
			: mutable assignment_operator expression              {
																	  if($1==1 && $3==1) 
																	  {
			                                                          $$=1;
			                                                          } 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);} 
			                                                        $$ = create_ast_node("expression", NULL, 3, $1, $2, $3); }

			| mutable addition_assignment_operator expression     {
																	  if($1==1 && $3==1) 
			                                                          $$=1; 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);} 
			                                                        $$ = create_ast_node("expression", NULL, 3, $1, $2, $3); }
			| mutable subtraction_assignment_operator expression  {
																	  if($1==1 && $3==1) 
			                                                          $$=1; 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);} 
			                                                        $$ = create_ast_node("expression", NULL, 3, $1, $2, $3);}
			| mutable multiplication_assignment_operator expression {
																	  if($1==1 && $3==1) 
			                                                          $$=1; 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);} 
			                                                        $$ = create_ast_node("expression", NULL, 3, $1, $2, $3);}
			| mutable division_assignment_operator expression 		{
																	  if($1==1 && $3==1) 
			                                                          $$=1; 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);} 
			                                                        $$ = create_ast_node("expression", NULL, 3, $1, $2, $3);}
			| mutable modulo_assignment_operator expression 		{
																	  if($1==1 && $3==1) 
			                                                          $$=1; 
			                                                          else 
			                                                          {$$=-1; printf("Type mismatch\n"); exit(0);} 
			                                                        $$ = create_ast_node("expression", NULL, 3, $1, $2, $3);}
			| mutable increment_operator 							{if($1 == 1) $$=1; else $$=-1; $$ = create_ast_node("expression", NULL, 2, $1, $2); }
			| mutable decrement_operator 							{if($1 == 1) $$=1; else $$=-1; $$ = create_ast_node("expression", NULL, 2, $1, $2); }
			| simple_expression {if($1 == 1) $$=1; else $$=-1; $$ = create_ast_node("expression", NULL, 1, $1); };


simple_expression 
			: simple_expression OR_operator and_expression {if($1 == 1 && $3==1) $$=1; else $$=-1; $$ = create_ast_node("simple_expression", NULL, 3, $1, $2, $3);}
			| and_expression {if($1 == 1) $$=1; else $$=-1; $$ = create_ast_node("simple_expression", NULL, 1, $1); }};

and_expression 
			: and_expression AND_operator unary_relation_expression {if($1 == 1 && $3==1) $$=1; else $$=-1; $$ = create_ast_node("and_expression", NULL, 3, $1, $2, $3);}
			| unary_relation_expression {if($1 == 1) $$=1; else $$=-1; $$ = create_ast_node("and_expression", NULL, 1, $1);};


unary_relation_expression 
			: exclamation_operator unary_relation_expression {if($2==1) $$=1; else $$=-1; $$ = create_ast_node("unary_relation_expression", NULL, 2, $1, $2); }
			| regular_expression {if($1 == 1) $$=1; else $$=-1; $$ = create_ast_node("unary_relation_expression", NULL, 1, $1);};

regular_expression 
			: regular_expression relational_operators sum_expression {if($1 == 1 && $3==1) $$=1; else $$=-1; $$ = create_ast_node("regular_expression", NULL, 3, $1, $2, $3);}
			| sum_expression {if($1 == 1) $$=1; else $$=-1; $$ = create_ast_node("regular_expression", NULL, 1, $1);} ;
			
relational_operators 
			: greaterthan_assignment_operator { $$ = create_ast_node("relational_operators", NULL, 1, $1); }
            | lessthan_assignment_operator { $$ = create_ast_node("relational_operators", NULL, 1, $1); }
            | greaterthan_operator { $$ = create_ast_node("relational_operators", NULL, 1, $1); }
			| lessthan_operator { $$ = create_ast_node("relational_operators", NULL, 1, $1);}
            | equality_operator { $$ = create_ast_node("relational_operators", NULL, 1, $1); }
            | inequality_operator { $$ = create_ast_node("relational_operators", NULL, 1, $1); };

sum_expression 
			: sum_expression sum_operators term  {if($1 == 1 && $3==1) $$=1; else $$=-1; $$ = create_ast_node("sum_expression", NULL, 3, $1, $2, $3);}
			| term {if($1 == 1) $$=1; else $$=-1; $$ = create_ast_node("sum_expression", NULL, 1, $1); }};

sum_operators 
			: add_operator { $$ = create_ast_node("sum_operators", NULL, 1, $1); }
			| subtract_operator { $$ = create_ast_node("sum_operators", NULL, 1, $1); };

term
			: term MULOP factor {if($1 == 1 && $3==1) $$=1; else $$=-1; $$ = create_ast_node("term", NULL, 3, $1, $2, $3);}
			| factor {if($1 == 1) $$=1; else $$=-1; $$ = create_ast_node("term", NULL, 1, $1);};

MULOP 
			: multiplication_operator { $$ = create_ast_node("MULOP", NULL, 1, $1);}
            | division_operator { $$ = create_ast_node("MULOP", NULL, 1, $1);}
            | modulo_operator { $$ = create_ast_node("MULOP", NULL, 1, $1);};

factor 
			: immutable {if($1 == 1) $$=1; else $$=-1; $$ = create_ast_node("factor", NULL, 1, $1); }
			| mutable {if($1 == 1) $$=1; else $$=-1; $$ = create_ast_node("factor", NULL, 1, $1); };

mutable 
			: identifier {
						  if(check_id_is_func(curid))
						  {printf("Function name used as Identifier\n"); exit(8);}
			              if(!checkscope(curid))
			              {printf("%s\n",curid);printf("Undeclared\n");exit(0);} 
			              if(!checkarray(curid))
			              {printf("%s\n",curid);printf("Array ID has no subscript\n");exit(0);}
			              if(gettype(curid,0)=='i' || gettype(curid,1)== 'c')
			              $$ = 1;
			              else
			              $$ = -1;
			              $$ = create_ast_node("mutable", NULL, 1, $1); }

			| array_random_access {$$ = create_ast_node("mutable", NULL, 1, $1); };
			// | mutable mutable_breakup;

// mutable_breakup
// 			: '[' expression ']' 
// 			| '.' identifier;

immutable 
			: '(' expression ')' {if($2==1) $$=1; else $$=-1; $$ = create_ast_node("immutable", NULL, 1, $1); }
			| call {if($1==1) $$=1; else $$=-1; $$ = create_ast_node("immutable", NULL, 1, $1);}
			| constant {if($1==1) $$=1; else $$=-1; $$ = create_ast_node("immutable", NULL, 1, $1); };

call
			: identifier '('{
			             if(!check_declaration(curid, "Function"))
			             { printf("Function not declared"); exit(0);} 
			             insertSTF(curid); 
						 strcpy(currfunccall,curid);
			             } arguments ')' 
						 { if(strcmp(currfunccall,"printf"))
							{ 
								if(getSTparamscount(currfunccall)!=call_params_count)
								{	
									yyerror("Number of arguments in function call doesn't match number of parameters");
									//printf("Number of arguments in function call %s doesn't match number of parameters\n", currfunccall);
									exit(8);
								}
							} 
						 };

arguments 
			: arguments_list | ;

arguments_list 
			: expression { call_params_count++; } A ;

A
			: ',' expression { call_params_count++; } A 
			| ;

constant 
			: integer_constant 	{  insV(); $$=1; } 
			| string_constant	{  insV(); $$=-1;} 
			| float_constant	{  insV(); } 
			| character_constant{  insV();$$=1; };

%%

extern FILE *yyin;
extern int yylineno;
extern char *yytext;
void insertSTtype(char *,char *);
void insertSTvalue(char *, char *);
void incertCT(char *, char *);
void printST();
void printCT();



int main(int argc , char **argv)
{
	yyin = fopen(argv[1], "r");
	yyparse();

	if(flag == 0)
	{
		printf(ANSI_COLOR_GREEN "Status: Parsing Complete - Valid" ANSI_COLOR_RESET "\n");
		printf("%30s" ANSI_COLOR_CYAN "SYMBOL TABLE" ANSI_COLOR_RESET "\n", " ");
		printf("%30s %s\n", " ", "------------");
		printST();

		printf("\n\n%30s" ANSI_COLOR_CYAN "CONSTANT TABLE" ANSI_COLOR_RESET "\n", " ");
		printf("%30s %s\n", " ", "--------------");
		printCT();
	}

printf("\n........................Prakhar doing task 4...................\n");

}

void yyerror(char *s)
{
	printf(ANSI_COLOR_RED "%d %s %s\n", yylineno, s, yytext);
	flag=1;
	printf(ANSI_COLOR_RED "Status: Parsing Failed - Invalid\n" ANSI_COLOR_RESET);
	exit(7);
}

void ins()
{
	insertSTtype(curid,curtype);
}

void insV()
{
	insertSTvalue(curid,curval);
}

int yywrap()
{
	return 1;
}