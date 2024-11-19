#include "LLVMGlobals.h"

// This is an object that owns LLVM core data structures
llvm::LLVMContext TheContext;

// This is a helper object that makes easy to generate LLVM instructions
llvm::IRBuilder<> TheBuilder(TheContext);

// This is an LLVM construct that contains functions and global variables
std::unique_ptr<llvm::Module> TheModule;
