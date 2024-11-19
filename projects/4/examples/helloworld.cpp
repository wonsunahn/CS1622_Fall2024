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

static llvm::Function *funcPrintf = nullptr;

static void generatePrintf()
{
  // Add printf declaration.
  funcPrintf = TheModule->getFunction("printf");
  if (!funcPrintf)
  {
    llvm::FunctionType *funcPrintfType = llvm::FunctionType::get(llvm::IntegerType::get(TheContext, 32), true);
    funcPrintf = llvm::Function::Create(funcPrintfType, llvm::Function::ExternalLinkage, "printf", TheModule.get());
    funcPrintf->setCallingConv(llvm::CallingConv::C);
  }
}

void generateMain()
{
  // Create main function prototype.
  llvm::FunctionType *funcType = llvm::FunctionType::get(llvm::Type::getInt32Ty(TheContext), false);
  llvm::Function *func = llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "main", TheModule.get());

  // Create a basic block to start populating the function body.
  llvm::BasicBlock *bb = llvm::BasicBlock::Create(TheContext, "entry", func);
  TheBuilder.SetInsertPoint(bb);

  // Insert printf("Hello world\n");
  llvm::Value *str = TheBuilder.CreateGlobalStringPtr("Hello world !!!\n");
  std::vector<llvm::Value *> callParams;
  callParams.push_back(str);
  llvm::CallInst *callInst = llvm::CallInst::Create(funcPrintf, callParams, "call", bb);

  // Insert return 0;
  llvm::Value* retVal = llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0));
  TheBuilder.CreateRet(retVal);

  // Validate the generated function, checking for consistency.
  verifyFunction(*func);
}

int main()
{
  TheModule = std::make_unique<llvm::Module>("helloworld.codegen.ll", TheContext);

  generatePrintf();
  generateMain();

  TheModule->print(llvm::outs(), nullptr);

  return 0;
}
