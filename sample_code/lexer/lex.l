/* 1. Regular expression definitions section */
%{
/* Code block inserted for includes and declarations */
#include <stdlib.h>
%}
string         [a-z]+
space          [ ]+
unknown        [^ \n]+

%%
 /* 2. Rules section: action for each regular expression */
{string}       { printf("type=string, lexeme: %s, len=%d\n", yytext, yyleng); }
{space}        { printf("type=space, lexeme: %s, len=%d\n", yytext, yyleng); }
{unknown}      { printf("type=unknown, lexeme: %s, len=%d\n", yytext, yyleng); }

%%
/* 3. User code section */
int main() {
  while( yylex() != 0 ) {}
  return 0;
}