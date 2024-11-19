%{
/** Code by @author Wonsun Ahn, Fall 2024
 * 
 * The lexer implementation file.
 */

#include <stdlib.h>

extern void addStringTable(char* text, int tokenid ); /* install string constants & identifiers into string tbl */

void reportError(int type);

/* TODO: Add additional function declarations as needed. */

%}

/* TODO: Add token declarations as needed using regular expressions. */

%%

 /* TODO: Add rules for actions for each declared token. */

%%

/** Prints out an error message depending on error type.
 *
 * @param errorType - A number designating an error type.
 */
void reportError(int errorType)
{
  /* TODO: Report on 5 types of errors:
     1) Malformed identifier.
     2) A string constant with unmatched quotes.
     3) A comment with no matching end comment.
     4) An undefined token.

     The line and column numbers where the error occurred, as well as the erroneous
     token string as appropriate, should be printed as part of the output.  Refer to
     the error outputs under outputs_solution/code2.out and outputs_solution/string2.out
     and match the formatting exactly.
  */
}         

/* TODO: Add additional function definitions as needed. */