/* 1. Regular expression definitions section */
%{
/* Code block inserted for includes and declarations */
%}
string         [a-z]+
space          [ ]+
unknown        [^ \n]+

%%
 /* 2. Rules section: action for each regular expression, in order of precedence. */
{string}       { yylval.lexeme = yytext; return STRING_TOKEN; }
{space}        { return SPACE_TOKEN; }
{unknown}      { return UNKOWN_TOKEN; }

%%
/* 3. User code section */