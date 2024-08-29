/* 1. Regular expression definitions section */
%{
/* Code block inserted for includes and declarations */
#include <stdlib.h>
%}
string         [a-z]+
space          [ ]+

%%
 /* 2. Rules section: action for each regular expression */
{string}       { printf("lexeme: %s, len=%d\n", yytext, yyleng); }
{space}        { /* No action */ }

%%
/* 3. User code section */
int main() {
  while( yylex() != 0 ) {}
  return 0;
}
