#ifndef __LLVMGLOBALS_H__
#define __LLVMGLOBALS_H__

#include "llvm/ADT/APFloat.h"
#include "llvm/ADT/STLExtras.h"
#include "llvm/IR/BasicBlock.h"
#include "llvm/IR/Constants.h"
#include "llvm/IR/DerivedTypes.h"
#include "llvm/IR/Function.h"
#include "llvm/IR/IRBuilder.h"
#include "llvm/IR/LLVMContext.h"
#include "llvm/IR/Module.h"
#include "llvm/IR/Type.h"
#include "llvm/IR/Verifier.h"
#include "llvm/IR/Instructions.h"

// This is an object that owns LLVM core data structures
extern llvm::LLVMContext TheContext;

// This is a helper object that makes easy to generate LLVM instructions
extern llvm::IRBuilder<> TheBuilder;

// This is an LLVM construct that contains functions and global variables
extern std::unique_ptr<llvm::Module> TheModule;

#endif
