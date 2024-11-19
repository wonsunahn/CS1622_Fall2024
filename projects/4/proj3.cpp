/*
 * PLEASE INSERT ADEQUATE CODE FOR: STAddPredefined()
 */

/*
The symbolTable is a list of all symbols in the program.  A symbol table entry is a map from attribute IDs to attribule values.  In addition to symbolTable, there is scopeStack that keeps track of current active scopes.  A scope is defined by the "bottom" index where the scope begins in the symbol table and the "top" index where the scope ends.
*/

// LLVM headers
#include <llvm/IR/Value.h>
#include <llvm/ADT/StringRef.h>

#include <vector>
#include <deque>
#include <unordered_map>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>
#include <assert.h>
extern "C"
{
#include "proj2.h"
}
#include "proj3.h"

/*
 * string table access functions defined in table.cpp.
 */
int getIndex(const char *string);
const char *getString(int i);

/// @brief Symbol table entry.
typedef struct
{
  /// @brief List of attributes in (attr_num, attr_val) key value pairs.
  std::unordered_map<int, uintptr_t> attrs;
} SymbolTableEntry;

/// @brief The symbol table.
static std::vector<SymbolTableEntry> symbolTable;

/// @brief Activation stack item.
typedef struct
{
  /// @brief The bottom symbol table index for this scope.
  int bottom;
  /// @brief The top symbol table index for this scope.
  int top;
} Scope;

/// @brief Activation stack where each stack item is a "scope" pointing to an offset in the symbol table where the scope begins.
static std::deque<Scope> scopeStack;

/// @brief Current nesting level in terms of scopes.
static int nesting = 0;

/// @brief Whether to print out semantic errors.
bool printSemanticErrors = false;

/// @brief Returns the number of entries in the symbol table.
/// @return Number of entries in symbol table.
int GetSymbolTableSize()
{
  return symbolTable.size();
}

/// @brief Adds predefined names into symbol table: "system", "readln", and "println", if they are used in the MINI-JAVA source code.
void STAddPredefined()
{
  /* TODO: Implement function as described in above comment. */
}

/// @brief Adds a symbol table entry to the end of the symbol table.
/// @param idx String table index of the name you are adding.
/// @param kind Kind of symbol this is (VAR, FUNC, CLASS, ...).
/// @param lineno Line number where the symbol is defined.
/// @return The index of the new symbol table entry.
int InsertEntry(int idx, int kind, int lineno)
{
  /* id is already declared in the current block */
  if (LookUpHere(idx) != -1)
  {
    return (-1);
  }
  SymbolTableEntry entry;
  entry.attrs[NAME_ATTR] = idx;
  entry.attrs[KIND_ATTR] = kind;
  entry.attrs[LINENO_ATTR] = lineno;
  entry.attrs[NEST_ATTR] = nesting;
  entry.attrs[IS_USED_ATTR] = false;
  symbolTable.push_back(entry);

  assert(!scopeStack.empty());
  if (scopeStack.back().bottom == -1)
  {
    // If the current scope is empty, initialize both bottom and top.
    scopeStack.back().bottom = symbolTable.size() - 1;
    scopeStack.back().top = symbolTable.size() - 1;
  }
  else
  {
    // Otherwise, just add entry to current scope.
    scopeStack.back().top = symbolTable.size() - 1;
  }
  return symbolTable.size() - 1;
}

/// @brief Looks up a name in the symbol table in all active scopes, starting from innermost.
/// @param idx String table index of the name you are looking for.
/// @return The index of the found symbol table entry (-1 if not found).
int LookUp(int idx)
{
  for (auto it = scopeStack.rbegin(); it != scopeStack.rend(); ++it)
  {
    // If this scope is empty, continue to next scope.
    if (it->bottom == -1)
      continue;
    for (int curIdx = it->bottom; curIdx <= it->top; curIdx++)
      if (GetAttr(curIdx, NAME_ATTR) == idx)
        return curIdx;
  }
  return -1;
}

/// @brief Looks up a name in the symbol table only in the current scope (block).
/// @param idx String table index of the name you are looking for.
/// @return The index of the found symbol table entry (-1 if not found).
int LookUpHere(int idx)
{
  // Check if the current scope is empty.
  if (scopeStack.empty() || scopeStack.back().bottom == -1)
    return -1;

  for (int curIdx = scopeStack.back().bottom; curIdx <= scopeStack.back().top; curIdx++)
  {
    if (GetAttr(curIdx, NAME_ATTR) == idx)
      return curIdx;
  }

  return -1;
}

/// @brief Push a new scope into the scope stack and increment nesting level.
void OpenBlock()
{
  Scope scope = {-1, -1};
  scopeStack.push_back(scope);
  nesting++;
}

/// @brief Pops this scope from the scope stack and decrement nesting level.
void CloseBlock()
{
  scopeStack.pop_back();
  nesting--;
}

/// @brief Checks whether the given attribute number exists for the given symbol.
/// @param st_idx Symbol table index for the queried symbol.
/// @param attr_num The target attribute number.
/// @return 1 if attribute exists, 0 if it does not exist.
int IsAttr(int st_idx, int attr_num)
{
  if (st_idx >= symbolTable.size())
  {
    printf("DEBUG--Symbol table entry %d does not exist.\n", st_idx);
    assert(0);
  }
  if (symbolTable[st_idx].attrs.find(attr_num) != symbolTable[st_idx].attrs.end())
    return 1;
  else
    return 0;
}

/// @brief Returns the value of the given attribute number for the given symbol.
/// @param st_idx Symbol table index for the queried symbol.
/// @param attr_num The target attribute number.
/// @return Value of the attribute (if not found, prints a debug error message and returns 0).
uintptr_t GetAttr(int st_idx, int attr_num)
{
  if (st_idx >= symbolTable.size())
  {
    printf("DEBUG--Symbol table entry %d does not exist.\n", st_idx);
    assert(0);
  }
  if (symbolTable[st_idx].attrs.find(attr_num) == symbolTable[st_idx].attrs.end())
  {
    printf("DEBUG--The wanted attribute number %d does not exist\n", attr_num);
    return 0;
  }
  return symbolTable[st_idx].attrs[attr_num];
}

/// @brief Sets the value of the given attribute number for the given symbol.
/// @param st_idx Symbol table index for the target symbol.
/// @param attr_num The target attribute number.
void SetAttr(int st_idx, int attr_num, uintptr_t attr_val)
{
  if (st_idx >= symbolTable.size())
  {
    printf("DEBUG--Symbol table entry %d does not exist.\n", st_idx);
    assert(0);
  }
  if (symbolTable[st_idx].attrs.find(attr_num) != symbolTable[st_idx].attrs.end() && attr_num != IS_USED_ATTR)
  {
    printf("DEBUG--The attribute number %d to be added already exists\n", attr_num);
    return;
  }
  symbolTable[st_idx].attrs[attr_num] = attr_val;
}

const char *kind_name[] = {"variable", "function", "ref_arg", "val_arg", "class", "program", "array"};

std::string getNodeString(tree nd)
{
  switch (NodeKind(nd))
  {
  case EXPRNode:
    return getNodeOpString(nd);
  case NUMNode:
    return "NUMNode(" + std::to_string(IntVal(nd)) + ")";
  default:
    printf("DEBUG--Unprintable node kind %s\n", kind_name[NodeKind(nd)]);
    assert(0);
  }
}

std::string getTypeString(tree nd)
{
  switch (NodeKind(nd))
  {
  case INTEGERTNode:
    return "int";
  case EXPRNode:
  {
    assert(NodeOp(nd) == TypeIdOp);
    std::string type;
    if (NodeKind(LeftChild(nd)) == INTEGERTNode)
      type = "int";
    else
    {
      assert(NodeKind(LeftChild(nd)) == STNode);
      int idx = IntVal(LeftChild(nd));
      assert(idx > 0);
      type = getString(GetAttr(idx, NAME_ATTR));
    }
    for (tree indexOp = RightChild(nd); NodeOp(indexOp) == IndexOp; indexOp = RightChild(indexOp))
      type += "[]";
    return type;
  }
  case DUMMYNode:
    return "void";
  default:
    printf("DEBUG--Unprintable node kind %s\n", kind_name[NodeKind(nd)]);
    assert(0);
  }
}

std::string getDimensionsString(std::vector<int> *dims)
{
  std::string str;

  assert(dims != NULL);
  for (int dim : *dims)
    str += std::to_string(dim) + " ";
  if (str.length() > 0)
    str.erase(str.length() - 1, 1);
  return str;
}

/// @brief Prints out all the symbols in the symbol table.
/// @param table The FILE pointer where the printing should be directed.
/// @param printLineNo Whether to print out the line number attribute of each symbol.
void STPrint(FILE *table, bool printLineNo)
{
  int i, attr_num, attr_ptr, type_attr;
  uintptr_t attr_val;
  int treeval = 0;
  tree ptrTree;

  table = stdout;
  fprintf(table, "**************** SYMBOL TABLE ****************\n\n");
  if (printLineNo)
    fprintf(table, "%3s%11s%11s%11s%11s%11s%14s%11s%11s%11s%11s%11s\n\n", "", "Name", "Kind", "Nest-Level", "Predefined", "Type", "Init-Node", "Offset", "Dimensions", "Arguments", "LLVMObject", "LineNo");
  else
    fprintf(table, "%3s%11s%11s%11s%11s%11s%14s%11s%11s%11s%11s\n\n", "", "Name", "Kind", "Nest-Level", "Predefined", "Type", "Init-Node", "Offset", "Dimensions", "Arguments", "LLVMObject");

  for (i = 0; i < symbolTable.size(); i++)
  {
    fprintf(table, "%3d", i);
    for (attr_num = NAME_ATTR; attr_num <= LINENO_ATTR; attr_num++)
    {
      if ((attr_ptr = IsAttr(i, attr_num)))
      {
        attr_val = GetAttr(i, attr_num);
        switch (attr_num)
        {
        case NAME_ATTR:
          fprintf(table, "%11s", getString(attr_val));
          break;
        case OFFSET_ATTR:
        case NEST_ATTR:
          fprintf(table, "%11lu", attr_val);
          break;
        case INIT_ATTR:
        {
          std::string node_str = attr_val ? getNodeString((tree)attr_val) : "";
          fprintf(table, "%14s", node_str.c_str());
        }
        break;
        case TYPE_ATTR:
        {
          std::string type_str = attr_val ? getTypeString((tree)attr_val) : "";
          fprintf(table, "%11s", type_str.c_str());
        }
        break;
        case PREDE_ATTR:
          if (attr_val == true)
            fprintf(table, "%11s", "yes");
          else
            fprintf(table, "%11s", "no");
          break;
        case KIND_ATTR:
          fprintf(table, "%11s", kind_name[attr_val - 1]);
          break;
        case DIMEN_ATTR:
          fprintf(table, "%11s", getDimensionsString((std::vector<int> *)attr_val).c_str());
          break;
        case ARGNUM_ATTR:
          fprintf(table, "%11lu", attr_val);
          break;
        case OBJECT_ATTR:
          if (attr_val)
          {
            fprintf(table, "%11s", ((llvm::Value *)attr_val)->getName().str().c_str());
          }
          else
            fprintf(table, "%11s", "null");
          break;
        case LINENO_ATTR:
          if (printLineNo)
            fprintf(table, "%11lu", attr_val);
          break;
        case IS_USED_ATTR:
          fprintf(table, "%11s", attr_val ? "Yes" : "No");
          break;
        }
      }
      else
      {
        if (attr_num == INIT_ATTR)
        {
          fprintf(table, "%14s", " ");
        }
        else
        {
          fprintf(table, "%11s", " ");
        }
      }
    }
    fprintf(table, "\n");
  }
}

/// @brief Prints out a semantic error message.
/// @param type The type of error.
/// @param lineno The line number where the error occurred.
/// @param idx The string table index of the relevant symbol with the error.
void ErrorMessage(int type, int lineno, int idx)
{
  if (!printSemanticErrors)
    return;

  printf("[Semantic Error] line %d: ", lineno);
  switch (type)
  {
  case REDECLARATION:
    printf("symbol %s is previously redeclared.\n", getString(idx));
    break;
  case UNDECLARED:
    printf("symbol %s is undeclared.\n", getString(idx));
    break;
  case NOT_USED:
    printf("variable %s is not used anywhere.\n", getString(idx));
    break;
  case TYPE_MISMATCH:
    printf("symbol %s the type does not allow this operation.\n", getString(idx));
    break;
  case ARGUMENTS_NUM:
    printf("function %s argument number is different from declared parameter number.\n", getString(idx));
    break;
  case DIMENSIONS_NUM:
    printf("array %s accessed with an inappropriate number of dimensions.\n", getString(idx));
    break;
  case BOUND_NOT_CONST:
    printf("symbol %s is not a constant so can't be used as an array bound.\n", getString(idx));
    break;
  case NOT_A_FIELD:
    printf("symbol %s is not a field in the class.\n", getString(idx));
    break;
  case NOT_AN_ARRAY:
    printf("symbol %s not an array so can't be indexed.\n", getString(idx));
    break;
  case NOT_A_VARIABLE:
    printf("symbol %s not a variable so has no value.\n", getString(idx));
    break;
  case NOT_A_FUNCTION:
    printf("symbol %s not a function so can't be called.\n", getString(idx));
    break;
  case NOT_A_TYPE:
    printf("symbol %s is not a type.\n", getString(idx));
    break;
  default:
    printf("error type: %d.\n", type);
  }
}
