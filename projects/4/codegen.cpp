// stdlib headers
#include <algorithm>
#include <cctype>
#include <cstdio>
#include <cstdlib>
#include <map>
#include <memory>
#include <string>
#include <vector>
#include <stdio.h>
#include <string.h>
#include <assert.h>

// Declarations of LLVM global objects like TheContext, TheBuilder, TheModule
#include "llvm/LLVMGlobals.h"

extern "C"
{
#include "proj2.h"
}
#include "proj3.h"

static void emitSymbol(int idx)
{
  // TODO: Emit symbol in index idx in symbol table.
}

void codegen()
{
  for (int i = 1; i < GetSymbolTableSize(); i++)
  {
    emitSymbol(i);
  }
}
