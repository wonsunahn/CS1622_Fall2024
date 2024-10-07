/** Code by @author Wonsun Ahn, Fall 2024
 * 
 * The parser test driver file.
 */

#include <stdio.h>
#include <stdlib.h>
#include "proj2.h"
#include "y.tab.h"

extern FILE *treelst;
extern tree SyntaxTree;

int main()
{
  treelst = stdout;
  yyparse();
  printtree(SyntaxTree, 0);
  return 0;
}
