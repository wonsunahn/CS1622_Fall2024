#ifndef PROJ3_H_
#define PROJ3_H_

#include <stdint.h>

/*
 * error type for error reporting routine 
 */
#define REDECLARATION   100
#define UNDECLARED      101
#define NOT_USED        102
#define TYPE_MISMATCH   103
#define ARGUMENTS_NUM   104
#define DIMENSIONS_NUM  105
#define BOUND_NOT_CONST 106
#define NOT_A_FIELD     107
#define NOT_AN_ARRAY    108
#define NOT_A_VARIABLE  109
#define NOT_A_FUNCTION  110
#define NOT_A_TYPE      111

/*
 * Attributes available for each symbol in symbol table. 
 */
#define NAME_ATTR       1   /* id lexeme pointer, set by InsertEntry */
#define KIND_ATTR       2   /* kind of symbol; see below */
#define NEST_ATTR       3   /* nesting level, in terms of lexical scopes */
#define PREDE_ATTR      4   /* is this symbol predefined? */
#define TYPE_ATTR       5   /* pointer to type node of a variable or function*/
#define INIT_ATTR       6   /* pointer to initialization node of a variable or function */
#define OFFSET_ATTR     7   /* offset of variable in a class struct, function arguments, function stack */
#define DIMEN_ATTR      8   /* dimensions of an array (std::vector* type) */
#define ARGNUM_ATTR     9   /* number of arguments in a function */
#define OBJECT_ATTR     10  /* pointer of LLVM object for symbol (llvm::Value* type) */
#define LINENO_ATTR     11  /* source line number where the symbol was defined */
#define IS_USED_ATTR    12  /* has this symbol ever been used? */

/*
 * Possible values for the KIND_ATTR attribute.
 */
#define VAR             1   /* variable name */
#define FUNC            2   /* function name */
#define REF_ARG         3   /* reference function argument name */
#define VALUE_ARG       4   /* value function argument name */
#define CLASS           5   /* class name */
#define PROGRAM         6   /* program name */
#define ARR             7   /* array variable name */

/*
 * Symbol table access functions.
 */

int GetSymbolTableSize();
void STAddPredefined();
int InsertEntry(int, int, int);
int LookUp(int);
int LookUpHere(int);
void OpenBlock();
void CloseBlock();
int IsAttr(int, int);
uintptr_t GetAttr(int, int);
void SetAttr(int, int, uintptr_t);
void STPrint(FILE *, bool);
void ErrorMessage(int, int, int);

extern bool printSemanticErrors;

#endif /* #ifndef PROJ3_H_ */