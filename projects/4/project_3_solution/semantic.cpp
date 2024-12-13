/* DO NOT GRADE */

#include <vector>
#include <stdio.h>
#include <stdlib.h>
#include <assert.h>
extern "C"
{
#include "proj2.h"
}
#include "proj3.h"

extern tree SyntaxTree;

/* TODO: Add additional variable definitions as needed. */

/// @brief While recursively traversing the tree, add symbol declarations to the symbol table and replace IDNodes, that are uses of symbols in the source code, with STNodes, or symbol table nodes.  IDNodes contain an index into the string table where the name is and STNodes contain an index into the symbol table where symbol attributes (including the name) are.
/// @param treenode Tree node to recursively traverse.
void MkST(tree treenode)
{
	/* TODO: Complete function as described in above comment. */

	if (treenode == SyntaxTree)
	{
		/* Open global scope for the entire source file. */
		OpenBlock();

		/* TODO: Change the right child of treenode (the program name) from an IDNode to an STNode. */

        /* Open the scope for program. */
		OpenBlock();
		/* Add the predefined classes and methods to symbol table, within program scope. */
		STAddPredefined();
		/* Traverse the body of the program and add rest of the symbols to symbol table. */
		MkST(LeftChild(treenode));
		CloseBlock();

		/* Close global scope for the entire source file. */
		CloseBlock();

		return;
	}
	if (!IsNull(treenode))
	{
		/* Recursively traverse the tree. */
		MkST(LeftChild(treenode));
		MkST(RightChild(treenode));
	}
}
