/* 1. Regular expression definitions section */
%{
/* Code block inserted for includes and declarations */
#include <stdlib.h>

#define STRING_TOKEN  1
#define SPACE_TOKEN   2
#define UNKOWN_TOKEN  3

%}
string         [a-z]+
space          [ ]+
unknown        [^ \n]+

%%
 /* 2. Rules section: action for each regular expression, in order of precedence. */
{string}       { return STRING_TOKEN; }
{space}        { return SPACE_TOKEN; }
{unknown}      { return UNKOWN_TOKEN; }

%%
/* 3. User code section */
int main() {
  int ret;
  while( 1 ) {
    switch (ret = yylex()) {
      case STRING_TOKEN:
        printf("type=string, lexeme: %s, len=%d\n", yytext, yyleng);
        break;
      case SPACE_TOKEN:
        printf("type=space, lexeme: %s, len=%d\n", yytext, yyleng);
        break;
      case UNKOWN_TOKEN:
        printf("type=unknown, lexeme: %s, len=%d\n", yytext, yyleng);
        break;
      case 0:
        printf("EOF\n");
        return 0;
    }
  }
  return 0;
}