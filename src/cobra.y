/* Parser Generation - Syntax Analysis */
/* cobra.y */

%{
#include <stdio.h>
#include <stdlib.h>
#include <string>

extern int yylex();
extern int yyparse();
extern FILE* yyin;

void yyerror(const char* s);
%}

%union {
  int       number_val;
  char*     ident_val;
}

%start prog_start

%token	<number_val>    NUMBER
%token	<ident_val>     IDENT

%token	FUNCTION DOT COLON DIGIT ARRAY SIZE

%left   BEGIN_PARAMS END_PARAMS
%left   BEGIN_LOCALS END_LOCALS
%left   BEGIN_BODY END_BODY
%left   LEFT_BRACKET RIGHT_BRACKET
%left   ADD SUB
%left   MULT DIV
%left   MOD


%%
prog_start:     functions { printf("prog_start -> functions\n"); }

functions:      %empty { printf("functions -> epsilon\n"); }
                | function functions { printf("functions -> function functions\n"); }
                ;

function:       FUNCTION identifier DOT BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY { printf("function -> FUNCTION identifier DOT BEGIN_PARAMS declarations END_PARAMS BEGIN_LOCALS declarations END_LOCALS BEGIN_BODY statements END_BODY\n"); }
                ;

declarations:   %empty { printf("declarations -> epsilon\n"); }
                | declaration DOT declarations { printf("declarations -> declaration DOT declarations\n"); }
                ;

declaration:    identifier COLON DIGIT { printf("declaration -> identifier COLON DIGIT\n"); }
                | identifier COLON DIGIT ARRAY LEFT_BRACKET RIGHT_BRACKET SIZE number { printf("declaration -> identifier COLON DIGIT ARRAY LEFT_BRACKET RIGHT_BRACKET SIZE number\n"); }
                ;

identifier:     IDENT { printf("identifier -> IDENT %s\n", $1); }
                ;

number:         NUMBER { printf("number -> NUMBER %d\n", $1); }
                ;

statements:     %empty { printf("statements -> epsilon\n"); }
                | statement DOT statements { printf("statements -> statement statements\n"); }
                ;

statement:      number { /* Not correct, continue here */ }
                ;
expression:     multexpr { printf("expression -> multexpr \n"); }
                | multexpr ADD multexpr { printf("expression -> multexpr ADD multexpr \n"); }
                | multexpr ADD multexpr { printf("expression -> multexpr SUB multexpr \n"); }
                ;

multexpr:       term { printf("multexpr -> term\n"); }
                | term MULT term { printf("multexpr -> term MULT term\n"); }
                | term DIV term { printf("multexpr -> term DIV term\n"); }
                | term MOD term { printf("multexpr -> term MOD term\n"); }
                ;

term:           var{ printf("term -> var\n"); }
                | number { printf("term -> number\n"); }
                | LEFT_PARAN expression RIGHT_PARAN { printf("term -> LEFT_PARAN expression RIGHT_PARAN\n"); }
                ;

var:            identifier{ printf("var -> identifier\n"); }
                | identifier LEFT_BRACKET expression RIGHT_BRACKET { printf("var -> identifier LEFT_BRACKET expression RIGHT_BRACKET\n"); }
                ;
%%


int main(int argc, char *argv[]) {
  if (argc != 2) {
    printf("Not correct usage of the command.", argv[0]);
    exit(1);
  }
  FILE *inputFile = fopen(argv[1], "r");
  if (inputFile == NULL) {
    printf("Unable to open input file: %s\n", argv[1]);
    exit(1);
  }
  yyin = inputFile;
  yyparse();

  return 0;
}

void yyerror(const char* s) {
  fprintf(stderr, "ERROR: Parse error %s.\n", s);
  exit(1);
}
