%{
#include  <stdio.h>
static int yylex(void);
static void yyerror(char *str);
%}

%union {
  char* lexeme;
}

%token <lexeme> STRING_TOKEN SPACE_TOKEN UNKOWN_TOKEN

%%

Sentence  : STRING_TOKEN {
              printf("Sentence -> STRING_TOKEN (%s)\n", $1);
            };
          | Sentence SPACE_TOKEN Sentence {
              printf("Sentence -> Sentence SPACE_TOKEN Sentence\n");
            };

%%

/* 3. User code section */
int main()
{
  yyparse();
  return 0;
}

void yyerror(char *str)
{
  printf("yyerror: %s\n", str);
}

#include "lex.yy.c"