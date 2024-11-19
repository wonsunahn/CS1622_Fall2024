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

void generateMain()
{
  // Create main function prototype.
  llvm::FunctionType *funcType = llvm::FunctionType::get(llvm::Type::getInt32Ty(TheContext), false);
  llvm::Function *func = llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "main", TheModule.get());

  // Create a basic block to start populating the function body.
  llvm::BasicBlock *bb = llvm::BasicBlock::Create(TheContext, "entry", func);
  TheBuilder.SetInsertPoint(bb);

  // Define int arr[3][4];
  llvm::ArrayType *arrType = llvm::ArrayType::get(llvm::Type::getInt32Ty(TheContext), 4);
  arrType = llvm::ArrayType::get(arrType, 3);
  // llvm::AllocaInst *arrVar = TheBuilder.CreateAlloca(arrType, nullptr, "arr");

  TheModule->getOrInsertGlobal("arr", arrType);
  llvm::GlobalVariable *arrVar = TheModule->getNamedGlobal("arr");
  arrVar->setInitializer(llvm::ConstantArray::getNullValue(arrType));

  // Define int i = 0, j = 0;
  llvm::AllocaInst *iVar = TheBuilder.CreateAlloca(llvm::Type::getInt32Ty(TheContext), nullptr, "i");
  TheBuilder.CreateStore(llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0)), iVar);
  llvm::AllocaInst *jVar = TheBuilder.CreateAlloca(llvm::Type::getInt32Ty(TheContext), nullptr, "j");
  TheBuilder.CreateStore(llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0)), jVar);

  // Create loop basic blocks for outer loop and jump to loop condition evaluation
  llvm::BasicBlock *outerLoopCondBB = llvm::BasicBlock::Create(TheContext, "loopcond", func);
  llvm::BasicBlock *outerLoopBodyBB = llvm::BasicBlock::Create(TheContext, "loopbody", func);
  llvm::BasicBlock *outerLoopEndBB = llvm::BasicBlock::Create(TheContext, "loopend", func);
  TheBuilder.CreateBr(outerLoopCondBB);

  // Populate loop condition
  TheBuilder.SetInsertPoint(outerLoopCondBB);
  // Insert while (i < 3)
  llvm::Value *three = llvm::ConstantInt::get(TheContext, llvm::APInt(32, 3));
  llvm::Value *iVal = TheBuilder.CreateLoad(iVar->getAllocatedType(), iVar, "i");
  llvm::Value *outerCond = TheBuilder.CreateICmpSLT(iVal, three, "cmptmp");
  TheBuilder.CreateCondBr(outerCond, outerLoopBodyBB, outerLoopEndBB);

  // Populate outer loop body
  TheBuilder.SetInsertPoint(outerLoopBodyBB);

  // Insert j = 0;
  TheBuilder.CreateStore(llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0)), jVar);

  // Create loop basic blocks for inner loop and jump to loop condition evaluation
  llvm::BasicBlock *innerLoopCondBB = llvm::BasicBlock::Create(TheContext, "loopcond", func);
  llvm::BasicBlock *innerLoopBodyBB = llvm::BasicBlock::Create(TheContext, "loopbody", func);
  llvm::BasicBlock *innerLoopEndBB = llvm::BasicBlock::Create(TheContext, "loopend", func);
  TheBuilder.CreateBr(innerLoopCondBB);

  // Populate loop condition
  TheBuilder.SetInsertPoint(innerLoopCondBB);
  // Insert while (j < 4)
  llvm::Value *four = llvm::ConstantInt::get(TheContext, llvm::APInt(32, 4));
  llvm::Value *jVal = TheBuilder.CreateLoad(iVar->getAllocatedType(), jVar, "j");
  llvm::Value *innerCond = TheBuilder.CreateICmpSLT(jVal, four, "cmptmp");
  TheBuilder.CreateCondBr(innerCond, innerLoopBodyBB, innerLoopEndBB);

  // Populate inner loop body
  TheBuilder.SetInsertPoint(innerLoopBodyBB);

  // Get arr[i]
  std::vector<llvm::Value *> iIndices;
  // If you are curious about why we need this extra index 0, please read the below:
  // https://llvm.org/docs/GetElementPtr.html#why-is-the-extra-0-index-required
  iIndices.push_back(llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0)));
  iIndices.push_back(iVal);
  llvm::Value *arrElementPtr = TheBuilder.CreateInBoundsGEP(arrVar, iIndices, "arr[i]");
  // Get arr[i][j]
  std::vector<llvm::Value *> jIndices;
  // If you are curious about why we need this extra index 0, please read the below:
  // https://llvm.org/docs/GetElementPtr.html#why-is-the-extra-0-index-required
  jIndices.push_back(llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0)));
  jIndices.push_back(jVal);
  arrElementPtr = TheBuilder.CreateInBoundsGEP(arrElementPtr, jIndices, "arr[i][j]");
  
  // Insert arr[i][j] = i * 4 + j;
  llvm::Value *multVal = TheBuilder.CreateMul(iVal, llvm::ConstantInt::get(TheContext, llvm::APInt(32, 4)), "multtmp");
  llvm::Value *elementVal = TheBuilder.CreateAdd(multVal, jVal, "addtmp");
  TheBuilder.CreateStore(elementVal, arrElementPtr);
  
  // Insert printf("%d\n", arr[i][j]);
  llvm::Value *str = TheBuilder.CreateGlobalStringPtr("%d\n");
  std::vector<llvm::Value *> printfCallParams;
  printfCallParams.push_back(str);
  printfCallParams.push_back(TheBuilder.CreateLoad(arrElementPtr->getType()->getPointerElementType(), arrElementPtr, "arr.element"));
  TheBuilder.CreateCall(funcPrintf, printfCallParams, "");
  
  // Insert j++;
  jVal = TheBuilder.CreateLoad(jVar->getAllocatedType(), jVar, "j");
  llvm::Value *jPlusOne = TheBuilder.CreateAdd(jVal, llvm::ConstantInt::get(TheContext, llvm::APInt(32, 1)), "addtmp");
  TheBuilder.CreateStore(jPlusOne, jVar);

  // Loop back to inner condition while (j < 4)
  TheBuilder.CreateBr(innerLoopCondBB);

  // Populate basic block after the inner loop
  TheBuilder.SetInsertPoint(innerLoopEndBB);
  // Insert i++;
  iVal = TheBuilder.CreateLoad(iVar->getAllocatedType(), iVar, "i");
  llvm::Value *iPlusOne = TheBuilder.CreateAdd(iVal, llvm::ConstantInt::get(TheContext, llvm::APInt(32, 1)), "addtmp");
  TheBuilder.CreateStore(iPlusOne, iVar);
  // Loop back to outer condition while (i < 3)
  TheBuilder.CreateBr(outerLoopCondBB);

  // Populate basic block after the outer loop
  TheBuilder.SetInsertPoint(outerLoopEndBB);
  // Insert return 0;
  llvm::Value* retVal = llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0));
  TheBuilder.CreateRet(retVal);

  // Validate the generated function, checking for consistency.
  verifyFunction(*func);
}

int main()
{
  TheModule = std::make_unique<llvm::Module>("array-2d.codegen.ll", TheContext);

  generatePrintf();
  generateMain();

  TheModule->print(llvm::outs(), nullptr);

  return 0;
}
