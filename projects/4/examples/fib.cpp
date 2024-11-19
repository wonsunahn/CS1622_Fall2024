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

static void generateFib()
{
  // Create main function prototype.
  std::vector<llvm::Type *> params;
  params.push_back(llvm::Type::getInt32Ty(TheContext));
  llvm::FunctionType *funcType = llvm::FunctionType::get(llvm::Type::getInt32Ty(TheContext), params, false);
  funcFib = llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "fib", TheModule.get());

  // Create a basic block to start populating the function body.
  llvm::BasicBlock *bb = llvm::BasicBlock::Create(TheContext, "entry", funcFib);
  TheBuilder.SetInsertPoint(bb);
  // Define int ret;
  llvm::AllocaInst *retVar = TheBuilder.CreateAlloca(llvm::Type::getInt32Ty(TheContext), nullptr, "ret");

  // Insert if (x < 3)
  llvm::Value *three = llvm::ConstantInt::get(TheContext, llvm::APInt(32, 3));
  llvm::Value *arg = funcFib->args().begin();
  llvm::Value *cond = TheBuilder.CreateICmpSLT(arg, three, "cmptmp");
  llvm::BasicBlock *ThenBB = llvm::BasicBlock::Create(TheContext, "then", funcFib);
  llvm::BasicBlock *ElseBB = llvm::BasicBlock::Create(TheContext, "else", funcFib);
  llvm::BasicBlock *MergeBB = llvm::BasicBlock::Create(TheContext, "ifcont", funcFib);
  TheBuilder.CreateCondBr(cond, ThenBB, ElseBB);


  // Populate the then branch
  TheBuilder.SetInsertPoint(ThenBB);
  // Insert ret = 1;
  llvm::Value* retVal = llvm::ConstantInt::get(TheContext, llvm::APInt(32, 1));
  TheBuilder.CreateStore(retVal, retVar);
  TheBuilder.CreateBr(MergeBB);

  // Populate the else branch
  TheBuilder.SetInsertPoint(ElseBB);
  // ret = fib(x-1) + fib(x-2); on the else branch
  // Call fib(x-1);
  std::vector<llvm::Value *> firstFibParams;
  llvm::Value *argMinusOne = TheBuilder.CreateSub(arg, llvm::ConstantInt::get(TheContext, llvm::APInt(32, 1)), "subtmp");
  firstFibParams.push_back(argMinusOne);
  llvm::Value *firstFib = TheBuilder.CreateCall(funcFib, firstFibParams, "firstFib");
  // Call fib(x-2);
  std::vector<llvm::Value *> secondFibParams;
  llvm::Value *argMinusTwo = TheBuilder.CreateSub(arg, llvm::ConstantInt::get(TheContext, llvm::APInt(32, 2)), "subtmp");
  secondFibParams.push_back(argMinusTwo);
  llvm::Value *secondFib = TheBuilder.CreateCall(funcFib, secondFibParams, "secondFib");
  // Add the two fibs
  retVal = TheBuilder.CreateAdd(firstFib, secondFib, "addtmp");
  // Store to ret
  TheBuilder.CreateStore(retVal, retVar);
  TheBuilder.CreateBr(MergeBB);
  
  // Insert return ret;
  TheBuilder.SetInsertPoint(MergeBB);
  retVal = TheBuilder.CreateLoad(retVar->getAllocatedType(), retVar, "loadtmp");
  TheBuilder.CreateRet(retVal);

  // Validate the generated function, checking for consistency.
  verifyFunction(*funcFib);
}

void generateMain()
{
  // Create main function prototype.
  llvm::FunctionType *funcType = llvm::FunctionType::get(llvm::Type::getInt32Ty(TheContext), false);
  llvm::Function *func = llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "main", TheModule.get());

  // Create a basic block to start populating the function body.
  llvm::BasicBlock *bb = llvm::BasicBlock::Create(TheContext, "entry", func);
  TheBuilder.SetInsertPoint(bb);

  // Define int i = 1;
  llvm::AllocaInst *iVar = TheBuilder.CreateAlloca(llvm::Type::getInt32Ty(TheContext), nullptr, "i");
  TheBuilder.CreateStore(llvm::ConstantInt::get(TheContext, llvm::APInt(32, 1)), iVar);

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
  // Insert i++;
  iVal = TheBuilder.CreateLoad(iVar->getAllocatedType(), iVar, "i");
  llvm::Value *iPlusOne = TheBuilder.CreateAdd(iVal, llvm::ConstantInt::get(TheContext, llvm::APInt(32, 1)), "addtmp");
  TheBuilder.CreateStore(iPlusOne, iVar);
  // Call fib(i);
  std::vector<llvm::Value *> fibCallParams;
  iVal = TheBuilder.CreateLoad(iVar->getAllocatedType(), iVar, "i");
  fibCallParams.push_back(iVal);
  llvm::Value *fib = TheBuilder.CreateCall(funcFib, fibCallParams, "fib");
  // Insert printf("%d\n", fib(i));
  llvm::Value *str = TheBuilder.CreateGlobalStringPtr("%d\n");
  std::vector<llvm::Value *> printfCallParams;
  printfCallParams.push_back(str);
  printfCallParams.push_back(fib);
  TheBuilder.CreateCall(funcPrintf, printfCallParams, "");
  // Loop back to condition
  TheBuilder.CreateBr(loopCondBB);

  // Populate basic block after the loop
  TheBuilder.SetInsertPoint(loopEndBB);
  // Insert return 0;
  llvm::Value* retVal = llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0));
  TheBuilder.CreateRet(retVal);

  // Validate the generated function, checking for consistency.
  verifyFunction(*func);
}

int main()
{
  TheModule = std::make_unique<llvm::Module>("fib.codegen.ll", TheContext);

  generatePrintf();
  generateFib();
  generateMain();

  TheModule->print(llvm::outs(), nullptr);

  return 0;
}
