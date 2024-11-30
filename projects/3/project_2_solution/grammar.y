%{
/* DO NOT GRADE */

/** Code by @author Wonsun Ahn, Fall 2024
 * 
 * The parser implementation file.
 */

#include <stdlib.h>
#include <stdio.h>
#include "proj2.h"

extern int yylex();
static void yyerror(char *str);

tree SyntaxTree;

/* TODO: Add variable definitons as needed. */

%}

%union {
  int intg;
  tree tptr;
}

/* Terminal (token) declarations */
%token <intg>  PROGRAMnum IDnum SEMInum CLASSnum  DECLARATIONSnum  ENDDECLARATIONSnum
%token <intg>  COMMAnum EQUALnum LBRACEnum RBRACEnum LBRACnum RBRACnum LPARENnum RPARENnum VOIDnum
%token <intg>  INTnum METHODnum VALnum DOTnum ASSGNnum RETURNnum IFnum ELSEnum WHILEnum
%token <intg>  LTnum LEnum EQnum NEnum GEnum GTnum PLUSnum MINUSnum ORnum TIMESnum DIVIDEnum ANDnum
%token <intg>  NOTnum ICONSTnum SCONSTnum

/* Non-terminal (tree node) declarations */
%type  <tptr>  Program

/* TODO: Add more non-terminal definitons as needed. */

%%

/* TODO: Fix this production rule so that it matches language specification. */
Program          :      PROGRAMnum IDnum SEMInum
                        { 
                          $$ = MakeTree(ProgramOp, NullExp(), MakeLeaf(IDNode, $2));
                          SyntaxTree = $$;
                        }

/* TODO: Add grammar rules and semantic actions for each non-terminal. */

%%

int yycolumn = 1, yyline = 1;

void yyerror(char *str)
{
  printf("yyerror: %s at line %d\n", str, yyline);
  exit(0);
}

#include "lex.yy.c"


