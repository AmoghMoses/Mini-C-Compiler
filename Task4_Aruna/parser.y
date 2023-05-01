%{
  #include <stdio.h>
  #include <stdlib.h>
  extern int yylex();
  extern int yyparse();
  extern FILE* yyin;
  int yyerror(char *);
  int label = 0;
  int tempVariable = 0;
  char* genTempVariable(int id){
      char* temp = (char*)malloc(10*sizeof(char));
      temp[0] = 'T';
      snprintf(temp, 10, "T%d", id);
      return temp;
  }
  int gencode(char* lhs, char* op, char* rhs){
      printf("\nT%d = %s %s %s \n", tempVariable, lhs, op, rhs);
      return tempVariable;
  }
  void assignment(char* lhs, char* rhs){
      printf("\n%s = %s \n", lhs, rhs);
  }

%}

%union{
    char* lexeme;
}
%token <lexeme> id value bool LOW_BOOL_OP EQUALS LOW_OP HIGH_OP HIGH_BOOL_OP IF 
%token <lexeme> ELSE l_b r_b l_c r_c X TYPE WHILE COMMA
%type <lexeme> BOOLEAN_EXP ARITH_EXP DECLARATION ASSIGNMENT CONDITIONAL LOOP LINE
%type <lexeme> ARITH_TERM BOOLEAN_TERM ARITH_FACTOR BOOLEAN_FACTOR PROGRAM
%type <lexeme> ARGS ARG FUNCTION_CALL FUNCTION LINES
%%
PROGRAM: FUNCTION PROGRAM
    | FUNCTION
    ;
FUNCTION: {printf("\nfunction BEGIN:\n");} TYPE id l_b ARGUMENTS r_b l_c LINES r_c {$$=""; printf("\n%s FUNCTION END\n", $3);}
    ;
ARGUMENTS: ARGUMENTS COMMA ARGUMENT
    | ARGUMENT
    ;
ARGUMENT: TYPE id
    ;
LINES: LINE LINES
    | LINE {$$ = $1;}
    ;
LINE: DECLARATION {$$ = $1;}
    | ASSIGNMENT {$$ = $1;}
    | CONDITIONAL {$$ = ""; printf("\nL%d: \n", label);}
    | {printf("\nL%d: ", ++label);} LOOP {$$ = "";}
    | FUNCTION_CALL {$$ = "";}
    | {printf("\nBLOCK L%d BEGIN\n", ++label);}BLOCK{$$ = ""; printf("\nL%d BLOCKEND\n", label);}
    ;
BLOCK: l_c LINES r_c
    ;
FUNCTION_CALL : id l_b ARGS r_b {printf("\ncall %s \n", $1);}
    ;
ARGS : ARGS COMMA ARG
    | ARG
    ;
ARG : id {printf("\nrefparam:%s\n", $1);}
    | value {printf("\nrefparam:%s\n", $1);}
    ;
DECLARATION: TYPE id {$$ = "";}
    | TYPE id EQUALS ARITH_EXP {assignment($2, $4); $$ = $1; }
    | TYPE id EQUALS BOOLEAN_EXP {assignment($2, $4); $$ = $1;}
    ;
ARITH_EXP: ARITH_EXP LOW_OP ARITH_TERM
            {
                int a = gencode($1, $2, $3);
                char* tempVar = genTempVariable(a);
                $$ = tempVar;
                tempVariable++;
            }
    | ARITH_TERM {$$ = $1;}
    ;
ARITH_TERM: ARITH_TERM HIGH_OP ARITH_FACTOR
            {
                int a = gencode($1, $2, $3);
                char* tempVar = genTempVariable(a);
                $$ = tempVar;
                tempVariable++;
            }
    | ARITH_FACTOR {$$ = $1;}
    ;
ARITH_FACTOR: id {$$ = $1;}
    | value {$$ = $1;}
    ;
BOOLEAN_EXP: BOOLEAN_EXP LOW_OP BOOLEAN_TERM
            {
                int a = gencode($1, $2, $3);
                char* tempVar = genTempVariable(a);
                $$ = tempVar;
                tempVariable++;
            }
    | BOOLEAN_TERM {$$ = $1;}
    ;
BOOLEAN_TERM: BOOLEAN_TERM HIGH_OP BOOLEAN_FACTOR
            {
                int a = gencode($1, $2, $3);
                char* tempVar = genTempVariable(a);
                $$ = tempVar;
                tempVariable++;
            }
    | BOOLEAN_FACTOR {$$ = $1;}
    ;
BOOLEAN_FACTOR: id {$$ = $1;}
    | bool {$$ = $1;}
    ;
ASSIGNMENT: id EQUALS ARITH_EXP
            {
                assignment($1, $3);
                $$ = $1;
            }
    | id EQUALS BOOLEAN_EXP
            {
                assignment($1, $3);
                $$ = $1;
            }
    ;
CONDITIONAL : IF l_b BOOLEAN_EXP r_b l_c {printf("\niffalse '%s' goto L%d\n", $3, ++label);} LINES r_c
    ;
LOOP : WHILE l_b BOOLEAN_EXP r_b l_c LINES {printf("\niftrue '%s' goto L%d\n", $3, label);} r_c
    ;
%%
int yyError(char *s){
    printf("invalid string");
}
int main(){
    FILE* fp = fopen("sample.txt", "r");
    yyin = fp;
    if(yyparse() == 0){
        printf("\nSUCCESFULLY PARSED\n");
    }
}
