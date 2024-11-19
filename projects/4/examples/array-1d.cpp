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
static llvm::Function *funcFib = nullptr;

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

void generateFirstLoop(llvm::Function *func, llvm::GlobalVariable *arrMemberVar, llvm::AllocaInst *arrLocalVar, llvm::AllocaInst *iVar)
{
  // i = 0;
  TheBuilder.CreateStore(llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0)), iVar);

  // Create loop basic blocks and jump to loop condition evaluation basic block
  llvm::BasicBlock *loopCondBB = llvm::BasicBlock::Create(TheContext, "loopcond", func);
  llvm::BasicBlock *loopBodyBB = llvm::BasicBlock::Create(TheContext, "loopbody", func);
  llvm::BasicBlock *loopEndBB = llvm::BasicBlock::Create(TheContext, "loopend", func);
  TheBuilder.CreateBr(loopCondBB);

  // Populate loop condition
  TheBuilder.SetInsertPoint(loopCondBB);
  // Insert while (i < 10)
  llvm::Value *ten = llvm::ConstantInt::get(TheContext, llvm::APInt(32, 10));
  llvm::Value *iVal = TheBuilder.CreateLoad(iVar->getAllocatedType(), iVar, "i");
  llvm::Value *cond = TheBuilder.CreateICmpSLT(iVal, ten, "cmptmp");
  TheBuilder.CreateCondBr(cond, loopBodyBB, loopEndBB);

  // Populate loop body
  TheBuilder.SetInsertPoint(loopBodyBB);
  // Insert arrLocal[i] = arrMember[i];
  std::vector<llvm::Value *> indices;
  // If you are curious about why we need this extra index 0, please read the below:
  // https://llvm.org/docs/GetElementPtr.html#why-is-the-extra-0-index-required
  indices.push_back(llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0)));
  indices.push_back(iVal);
  llvm::Value *arrMemberElementPtr = TheBuilder.CreateInBoundsGEP(arrMemberVar, indices, "&arrMember[i]");
  llvm::Value *arrMemberElementVal = TheBuilder.CreateLoad(arrMemberElementPtr->getType()->getPointerElementType(), arrMemberElementPtr, "arrMember[i]");
  llvm::Value *arrLocalElementPtr = TheBuilder.CreateInBoundsGEP(arrLocalVar, indices, "&arrLocal[i]");
  TheBuilder.CreateStore(arrMemberElementVal, arrLocalElementPtr);

  // Insert i++;
  iVal = TheBuilder.CreateLoad(iVar->getAllocatedType(), iVar, "i");
  llvm::Value *iPlusOne = TheBuilder.CreateAdd(iVal, llvm::ConstantInt::get(TheContext, llvm::APInt(32, 1)), "addtmp");
  TheBuilder.CreateStore(iPlusOne, iVar);
  // Loop back to condition
  TheBuilder.CreateBr(loopCondBB);

  // Populate basic block after the loop
  TheBuilder.SetInsertPoint(loopEndBB);
}

void generateSecondLoop(llvm::Function *func, llvm::GlobalVariable *arrMemberVar, llvm::AllocaInst *arrLocalVar, llvm::AllocaInst *iVar)
{
  // i = 0;
  TheBuilder.CreateStore(llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0)), iVar);

  // Create loop basic blocks and jump to loop condition evaluation basic block
  llvm::BasicBlock *loopCondBB = llvm::BasicBlock::Create(TheContext, "loopcond", func);
  llvm::BasicBlock *loopBodyBB = llvm::BasicBlock::Create(TheContext, "loopbody", func);
  llvm::BasicBlock *loopEndBB = llvm::BasicBlock::Create(TheContext, "loopend", func);
  TheBuilder.CreateBr(loopCondBB);

  // Populate loop condition
  TheBuilder.SetInsertPoint(loopCondBB);
  // Insert while (i < 10)
  llvm::Value *ten = llvm::ConstantInt::get(TheContext, llvm::APInt(32, 10));
  llvm::Value *iVal = TheBuilder.CreateLoad(iVar->getAllocatedType(), iVar, "i");
  llvm::Value *cond = TheBuilder.CreateICmpSLT(iVal, ten, "cmptmp");
  TheBuilder.CreateCondBr(cond, loopBodyBB, loopEndBB);

  // Populate loop body
  TheBuilder.SetInsertPoint(loopBodyBB);
  // Access arrLocal[i]
  std::vector<llvm::Value *> indices;
  // If you are curious about why we need this extra index 0, please read the below:
  // https://llvm.org/docs/GetElementPtr.html#why-is-the-extra-0-index-required
  indices.push_back(llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0)));
  indices.push_back(iVal);
  llvm::Value *arrLocalElementPtr = TheBuilder.CreateInBoundsGEP(arrLocalVar, indices, "&arrLocal[i]");
  // Insert printf("%d\n", arrLocal[i]);
  llvm::Value *str = TheBuilder.CreateGlobalStringPtr("%d\n");
  std::vector<llvm::Value *> printfCallParams;
  printfCallParams.push_back(str);
  printfCallParams.push_back(TheBuilder.CreateLoad(arrLocalElementPtr->getType()->getPointerElementType(), arrLocalElementPtr, "arrLocal[i]"));
  TheBuilder.CreateCall(funcPrintf, printfCallParams, "");
  // Insert i++;
  iVal = TheBuilder.CreateLoad(iVar->getAllocatedType(), iVar, "i");
  llvm::Value *iPlusOne = TheBuilder.CreateAdd(iVal, llvm::ConstantInt::get(TheContext, llvm::APInt(32, 1)), "addtmp");
  TheBuilder.CreateStore(iPlusOne, iVar);
  // Loop back to condition
  TheBuilder.CreateBr(loopCondBB);

  // Populate basic block after the loop
  TheBuilder.SetInsertPoint(loopEndBB);
}

void generateMain()
{
  // Create main function prototype.
  llvm::FunctionType *funcType = llvm::FunctionType::get(llvm::Type::getInt32Ty(TheContext), false);
  llvm::Function *func = llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "main", TheModule.get());

  // Create a basic block to start populating the function body.
  llvm::BasicBlock *bb = llvm::BasicBlock::Create(TheContext, "entry", func);
  TheBuilder.SetInsertPoint(bb);

  // Define global int arrMember[10];
  llvm::ArrayType *arrMemberType = llvm::ArrayType::get(llvm::Type::getInt32Ty(TheContext), 10);
  TheModule->getOrInsertGlobal("arrMember", arrMemberType);
  llvm::GlobalVariable *arrMemberVar = TheModule->getNamedGlobal("arrMember");

  // Initialize int arrMember[10] = {0, 1, 2, 3, 4, 5, 6, 7, 8, 9}
  std::vector<llvm::Constant*> elements;
  for (int i = 0; i < 10; i++)
  {
    elements.push_back(llvm::ConstantInt::get(TheContext, llvm::APInt(32, i)));
  }
  arrMemberVar->setInitializer(llvm::ConstantArray::get(arrMemberType, elements));

  // Define global int arrLocal[10];
  llvm::ArrayType *arrLocalType = llvm::ArrayType::get(llvm::Type::getInt32Ty(TheContext), 10);
  llvm::AllocaInst *arrLocalVar = TheBuilder.CreateAlloca(arrLocalType, nullptr, "arrLocal");

  // Define int i;
  llvm::AllocaInst *iVar = TheBuilder.CreateAlloca(llvm::Type::getInt32Ty(TheContext), nullptr, "i");

  generateFirstLoop(func, arrMemberVar, arrLocalVar, iVar);
  generateSecondLoop(func, arrMemberVar, arrLocalVar, iVar);
  
  // Insert return 0;
  llvm::Value* retVal = llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0));
  TheBuilder.CreateRet(retVal);

  // Validate the generated function, checking for consistency.
  verifyFunction(*func);
}

int main()
{
  TheModule = std::make_unique<llvm::Module>("array-1d.codegen.ll", TheContext);

  generatePrintf();
  generateMain();

  TheModule->print(llvm::outs(), nullptr);

  return 0;
}