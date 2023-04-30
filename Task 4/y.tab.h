#ifndef YY_parse_h_included
#define YY_parse_h_included
/*#define YY_USE_CLASS 
*/
#line 1 "/usr/share/bison++/bison.h"
/* before anything */
#ifdef c_plusplus
 #ifndef __cplusplus
  #define __cplusplus
 #endif
#endif


 #line 8 "/usr/share/bison++/bison.h"

#line 21 "/usr/share/bison++/bison.h"
 /* %{ and %header{ and %union, during decl */
#ifndef YY_parse_COMPATIBILITY
 #ifndef YY_USE_CLASS
  #define  YY_parse_COMPATIBILITY 1
 #else
  #define  YY_parse_COMPATIBILITY 0
 #endif
#endif

#if YY_parse_COMPATIBILITY != 0
/* backward compatibility */
 #ifdef YYLTYPE
  #ifndef YY_parse_LTYPE
   #define YY_parse_LTYPE YYLTYPE
/* WARNING obsolete !!! user defined YYLTYPE not reported into generated header */
/* use %define LTYPE */
  #endif
 #endif
/*#ifdef YYSTYPE*/
  #ifndef YY_parse_STYPE
   #define YY_parse_STYPE YYSTYPE
  /* WARNING obsolete !!! user defined YYSTYPE not reported into generated header */
   /* use %define STYPE */
  #endif
/*#endif*/
 #ifdef YYDEBUG
  #ifndef YY_parse_DEBUG
   #define  YY_parse_DEBUG YYDEBUG
   /* WARNING obsolete !!! user defined YYDEBUG not reported into generated header */
   /* use %define DEBUG */
  #endif
 #endif 
 /* use goto to be compatible */
 #ifndef YY_parse_USE_GOTO
  #define YY_parse_USE_GOTO 1
 #endif
#endif

/* use no goto to be clean in C++ */
#ifndef YY_parse_USE_GOTO
 #define YY_parse_USE_GOTO 0
#endif

#ifndef YY_parse_PURE

 #line 65 "/usr/share/bison++/bison.h"

#line 65 "/usr/share/bison++/bison.h"
/* YY_parse_PURE */
#endif


 #line 68 "/usr/share/bison++/bison.h"
#ifndef YY_USE_CLASS
# ifndef YYSTYPE
#  define YYSTYPE int
#  define YYSTYPE_IS_TRIVIAL 1
# endif
#endif

#line 68 "/usr/share/bison++/bison.h"
/* prefix */

#ifndef YY_parse_DEBUG

 #line 71 "/usr/share/bison++/bison.h"

#line 71 "/usr/share/bison++/bison.h"
/* YY_parse_DEBUG */
#endif

#ifndef YY_parse_LSP_NEEDED

 #line 75 "/usr/share/bison++/bison.h"

#line 75 "/usr/share/bison++/bison.h"
 /* YY_parse_LSP_NEEDED*/
#endif

/* DEFAULT LTYPE*/
#ifdef YY_parse_LSP_NEEDED
 #ifndef YY_parse_LTYPE
  #ifndef BISON_YYLTYPE_ISDECLARED
   #define BISON_YYLTYPE_ISDECLARED
typedef
  struct yyltype
    {
      int timestamp;
      int first_line;
      int first_column;
      int last_line;
      int last_column;
      char *text;
   }
  yyltype;
  #endif

  #define YY_parse_LTYPE yyltype
 #endif
#endif

/* DEFAULT STYPE*/
#ifndef YY_parse_STYPE
 #define YY_parse_STYPE int
#endif

/* DEFAULT MISCELANEOUS */
#ifndef YY_parse_PARSE
 #define YY_parse_PARSE yyparse
#endif

#ifndef YY_parse_LEX
 #define YY_parse_LEX yylex
#endif

#ifndef YY_parse_LVAL
 #define YY_parse_LVAL yylval
#endif

#ifndef YY_parse_LLOC
 #define YY_parse_LLOC yylloc
#endif

#ifndef YY_parse_CHAR
 #define YY_parse_CHAR yychar
#endif

#ifndef YY_parse_NERRS
 #define YY_parse_NERRS yynerrs
#endif

#ifndef YY_parse_DEBUG_FLAG
 #define YY_parse_DEBUG_FLAG yydebug
#endif

#ifndef YY_parse_ERROR
 #define YY_parse_ERROR yyerror
#endif

#ifndef YY_parse_PARSE_PARAM
 #ifndef __STDC__
  #ifndef __cplusplus
   #ifndef YY_USE_CLASS
    #define YY_parse_PARSE_PARAM
    #ifndef YY_parse_PARSE_PARAM_DEF
     #define YY_parse_PARSE_PARAM_DEF
    #endif
   #endif
  #endif
 #endif
 #ifndef YY_parse_PARSE_PARAM
  #define YY_parse_PARSE_PARAM void
 #endif
#endif

/* TOKEN C */
#ifndef YY_USE_CLASS

 #ifndef YY_parse_PURE
  #ifndef yylval
   extern YY_parse_STYPE YY_parse_LVAL;
  #else
   #if yylval != YY_parse_LVAL
    extern YY_parse_STYPE YY_parse_LVAL;
   #else
    #warning "Namespace conflict, disabling some functionality (bison++ only)"
   #endif
  #endif
 #endif


 #line 169 "/usr/share/bison++/bison.h"
#define	IF	258
#define	INT	259
#define	CHAR	260
#define	FLOAT	261
#define	DOUBLE	262
#define	LONG	263
#define	SHORT	264
#define	SIGNED	265
#define	UNSIGNED	266
#define	STRUCT	267
#define	RETURN	268
#define	MAIN	269
#define	VOID	270
#define	WHILE	271
#define	FOR	272
#define	DO	273
#define	BREAK	274
#define	ENDIF	275
#define	identifier	276
#define	array_identifier	277
#define	func_identifier	278
#define	integer_constant	279
#define	string_constant	280
#define	float_constant	281
#define	character_constant	282
#define	ELSE	283
#define	leftshift_assignment_operator	284
#define	rightshift_assignment_operator	285
#define	XOR_assignment_operator	286
#define	OR_assignment_operator	287
#define	AND_assignment_operator	288
#define	modulo_assignment_operator	289
#define	multiplication_assignment_operator	290
#define	division_assignment_operator	291
#define	addition_assignment_operator	292
#define	subtraction_assignment_operator	293
#define	assignment_operator	294
#define	OR_operator	295
#define	AND_operator	296
#define	pipe_operator	297
#define	caret_operator	298
#define	amp_operator	299
#define	equality_operator	300
#define	inequality_operator	301
#define	lessthan_assignment_operator	302
#define	lessthan_operator	303
#define	greaterthan_assignment_operator	304
#define	greaterthan_operator	305
#define	leftshift_operator	306
#define	rightshift_operator	307
#define	add_operator	308
#define	subtract_operator	309
#define	multiplication_operator	310
#define	division_operator	311
#define	modulo_operator	312
#define	SIZEOF	313
#define	tilde_operator	314
#define	exclamation_operator	315
#define	increment_operator	316
#define	decrement_operator	317


#line 169 "/usr/share/bison++/bison.h"
 /* #defines token */
/* after #define tokens, before const tokens S5*/
#else
 #ifndef YY_parse_CLASS
  #define YY_parse_CLASS parse
 #endif

 #ifndef YY_parse_INHERIT
  #define YY_parse_INHERIT
 #endif

 #ifndef YY_parse_MEMBERS
  #define YY_parse_MEMBERS 
 #endif

 #ifndef YY_parse_LEX_BODY
  #define YY_parse_LEX_BODY  
 #endif

 #ifndef YY_parse_ERROR_BODY
  #define YY_parse_ERROR_BODY  
 #endif

 #ifndef YY_parse_CONSTRUCTOR_PARAM
  #define YY_parse_CONSTRUCTOR_PARAM
 #endif
 /* choose between enum and const */
 #ifndef YY_parse_USE_CONST_TOKEN
  #define YY_parse_USE_CONST_TOKEN 0
  /* yes enum is more compatible with flex,  */
  /* so by default we use it */ 
 #endif
 #if YY_parse_USE_CONST_TOKEN != 0
  #ifndef YY_parse_ENUM_TOKEN
   #define YY_parse_ENUM_TOKEN yy_parse_enum_token
  #endif
 #endif

class YY_parse_CLASS YY_parse_INHERIT
{
public: 
 #if YY_parse_USE_CONST_TOKEN != 0
  /* static const int token ... */
  
 #line 212 "/usr/share/bison++/bison.h"
static const int IF;
static const int INT;
static const int CHAR;
static const int FLOAT;
static const int DOUBLE;
static const int LONG;
static const int SHORT;
static const int SIGNED;
static const int UNSIGNED;
static const int STRUCT;
static const int RETURN;
static const int MAIN;
static const int VOID;
static const int WHILE;
static const int FOR;
static const int DO;
static const int BREAK;
static const int ENDIF;
static const int identifier;
static const int array_identifier;
static const int func_identifier;
static const int integer_constant;
static const int string_constant;
static const int float_constant;
static const int character_constant;
static const int ELSE;
static const int leftshift_assignment_operator;
static const int rightshift_assignment_operator;
static const int XOR_assignment_operator;
static const int OR_assignment_operator;
static const int AND_assignment_operator;
static const int modulo_assignment_operator;
static const int multiplication_assignment_operator;
static const int division_assignment_operator;
static const int addition_assignment_operator;
static const int subtraction_assignment_operator;
static const int assignment_operator;
static const int OR_operator;
static const int AND_operator;
static const int pipe_operator;
static const int caret_operator;
static const int amp_operator;
static const int equality_operator;
static const int inequality_operator;
static const int lessthan_assignment_operator;
static const int lessthan_operator;
static const int greaterthan_assignment_operator;
static const int greaterthan_operator;
static const int leftshift_operator;
static const int rightshift_operator;
static const int add_operator;
static const int subtract_operator;
static const int multiplication_operator;
static const int division_operator;
static const int modulo_operator;
static const int SIZEOF;
static const int tilde_operator;
static const int exclamation_operator;
static const int increment_operator;
static const int decrement_operator;


#line 212 "/usr/share/bison++/bison.h"
 /* decl const */
 #else
  enum YY_parse_ENUM_TOKEN { YY_parse_NULL_TOKEN=0
  
 #line 215 "/usr/share/bison++/bison.h"
	,IF=258
	,INT=259
	,CHAR=260
	,FLOAT=261
	,DOUBLE=262
	,LONG=263
	,SHORT=264
	,SIGNED=265
	,UNSIGNED=266
	,STRUCT=267
	,RETURN=268
	,MAIN=269
	,VOID=270
	,WHILE=271
	,FOR=272
	,DO=273
	,BREAK=274
	,ENDIF=275
	,identifier=276
	,array_identifier=277
	,func_identifier=278
	,integer_constant=279
	,string_constant=280
	,float_constant=281
	,character_constant=282
	,ELSE=283
	,leftshift_assignment_operator=284
	,rightshift_assignment_operator=285
	,XOR_assignment_operator=286
	,OR_assignment_operator=287
	,AND_assignment_operator=288
	,modulo_assignment_operator=289
	,multiplication_assignment_operator=290
	,division_assignment_operator=291
	,addition_assignment_operator=292
	,subtraction_assignment_operator=293
	,assignment_operator=294
	,OR_operator=295
	,AND_operator=296
	,pipe_operator=297
	,caret_operator=298
	,amp_operator=299
	,equality_operator=300
	,inequality_operator=301
	,lessthan_assignment_operator=302
	,lessthan_operator=303
	,greaterthan_assignment_operator=304
	,greaterthan_operator=305
	,leftshift_operator=306
	,rightshift_operator=307
	,add_operator=308
	,subtract_operator=309
	,multiplication_operator=310
	,division_operator=311
	,modulo_operator=312
	,SIZEOF=313
	,tilde_operator=314
	,exclamation_operator=315
	,increment_operator=316
	,decrement_operator=317


#line 215 "/usr/share/bison++/bison.h"
 /* enum token */
     }; /* end of enum declaration */
 #endif
public:
 int YY_parse_PARSE(YY_parse_PARSE_PARAM);
 virtual void YY_parse_ERROR(char *msg) YY_parse_ERROR_BODY;
 #ifdef YY_parse_PURE
  #ifdef YY_parse_LSP_NEEDED
   virtual int  YY_parse_LEX(YY_parse_STYPE *YY_parse_LVAL,YY_parse_LTYPE *YY_parse_LLOC) YY_parse_LEX_BODY;
  #else
   virtual int  YY_parse_LEX(YY_parse_STYPE *YY_parse_LVAL) YY_parse_LEX_BODY;
  #endif
 #else
  virtual int YY_parse_LEX() YY_parse_LEX_BODY;
  YY_parse_STYPE YY_parse_LVAL;
  #ifdef YY_parse_LSP_NEEDED
   YY_parse_LTYPE YY_parse_LLOC;
  #endif
  int YY_parse_NERRS;
  int YY_parse_CHAR;
 #endif
 #if YY_parse_DEBUG != 0
  public:
   int YY_parse_DEBUG_FLAG;	/*  nonzero means print parse trace	*/
 #endif
public:
 YY_parse_CLASS(YY_parse_CONSTRUCTOR_PARAM);
public:
 YY_parse_MEMBERS 
};
/* other declare folow */
#endif


#if YY_parse_COMPATIBILITY != 0
 /* backward compatibility */
 /* Removed due to bison problems
 /#ifndef YYSTYPE
 / #define YYSTYPE YY_parse_STYPE
 /#endif*/

 #ifndef YYLTYPE
  #define YYLTYPE YY_parse_LTYPE
 #endif
 #ifndef YYDEBUG
  #ifdef YY_parse_DEBUG 
   #define YYDEBUG YY_parse_DEBUG
  #endif
 #endif

#endif
/* END */

 #line 267 "/usr/share/bison++/bison.h"
#endif
