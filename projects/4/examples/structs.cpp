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
  assert (funcPrintf != nullptr);
}

static llvm::GlobalVariable* generatePointGlobal()
{
  // Add pointGlobal global variable declaration of type struct Point.
  llvm::StructType *pointType = llvm::StructType::create(TheContext, { llvm::Type::getInt32Ty(TheContext), llvm::Type::getInt32Ty(TheContext) }, "Point");
  TheModule->getOrInsertGlobal("pointGlobal", pointType);
  llvm::GlobalVariable *pointVar = TheModule->getNamedGlobal("pointGlobal");

  // All LLVM global variables must be initialized, or they won't be instantiated:
  // https://llvm.org/docs/LangRef.html#global-variables
  
  // pointGlobal.x = 10, pointGlobal.y = 20;
  pointVar->setInitializer(llvm::ConstantStruct::get(pointType, { llvm::ConstantInt::get(TheContext, llvm::APInt(32, 10)), llvm::ConstantInt::get(TheContext, llvm::APInt(32, 20)) }));
  return pointVar;
}

static llvm::AllocaInst* generatePointLocal()
{
  // Add pointLocal local variable declaration of type struct Point.
  llvm::StructType *pointType = llvm::StructType::create(TheContext, { llvm::Type::getInt32Ty(TheContext), llvm::Type::getInt32Ty(TheContext) }, "Point");
  llvm::AllocaInst *pointVar = TheBuilder.CreateAlloca(pointType, nullptr, "pointLocal");
  return pointVar;
}

static void generatePrintPoint(llvm::Value *pointVar)
{
  // Insert printf("point = (%d, %d)\n", point.x, point.y);
  // Read point struct x, y fields
  llvm::Value *pointXField = TheBuilder.CreateStructGEP(pointVar, 0, "point.x");
  llvm::Value *pointYField = TheBuilder.CreateStructGEP(pointVar, 1, "point.y");
  llvm::Value *pointXVal = TheBuilder.CreateLoad(pointXField->getType()->getPointerElementType(), pointXField, "point.x.val");
  llvm::Value *pointYVal = TheBuilder.CreateLoad(pointYField->getType()->getPointerElementType(), pointYField, "point.y.val");
  // Call printf using above arguments
  llvm::Value *str = TheBuilder.CreateGlobalStringPtr("%d\n", "format");
  std::vector<llvm::Value *> printfCallParams;
  printfCallParams.push_back(str);
  printfCallParams.push_back(pointXVal);
  TheBuilder.CreateCall(funcPrintf, printfCallParams, "");
  printfCallParams.clear();
  printfCallParams.push_back(str);
  printfCallParams.push_back(pointYVal);
  TheBuilder.CreateCall(funcPrintf, printfCallParams, "");
}

static void generateMain()
{
  // Create main function prototype.
  llvm::FunctionType *funcType = llvm::FunctionType::get(llvm::Type::getInt32Ty(TheContext), false);
  llvm::Function *func = llvm::Function::Create(funcType, llvm::Function::ExternalLinkage, "main", TheModule.get());

  // Create a basic block to start populating the function body.
  llvm::BasicBlock *bb = llvm::BasicBlock::Create(TheContext, "entry", func);
  TheBuilder.SetInsertPoint(bb);

  // Instantiate pointGlobal struct
  llvm::GlobalVariable *pointGlobalVar = generatePointGlobal();
  // Instantiate pointLocal struct
  llvm::AllocaInst *pointLocalVar = generatePointLocal();

  // Copy pointGlobal into pointLocal
  llvm::Value *pointGlobalXField = TheBuilder.CreateStructGEP(pointGlobalVar, 0, "pointGlobal.x");
  llvm::Value *pointGlobalYField = TheBuilder.CreateStructGEP(pointGlobalVar, 1, "pointGlobal.y");
  llvm::Value *pointLocalXField = TheBuilder.CreateStructGEP(pointLocalVar, 0, "pointLocal.x");
  llvm::Value *pointLocalYField = TheBuilder.CreateStructGEP(pointLocalVar, 1, "pointLocal.y");
  llvm::Value *pointGlobalXVal = TheBuilder.CreateLoad(pointGlobalXField->getType()->getPointerElementType(), pointGlobalXField, "pointGlobal.x.val");
  llvm::Value *pointGlobalYVal = TheBuilder.CreateLoad(pointGlobalYField->getType()->getPointerElementType(), pointGlobalYField, "pointGlobal.y.val");
  TheBuilder.CreateStore(pointGlobalXVal, pointLocalXField);
  TheBuilder.CreateStore(pointGlobalYVal, pointLocalYField);

  // Print pointGlobal.
  generatePrintPoint(pointGlobalVar);
  // Print pointLocal.
  generatePrintPoint(pointLocalVar);

  // Insert return 0;
  llvm::Value *retVal = llvm::ConstantInt::get(TheContext, llvm::APInt(32, 0));
  TheBuilder.CreateRet(retVal);

  // Validate the generated function, checking for consistency.
  verifyFunction(*func);
}

int main()
{
  TheModule = std::make_unique<llvm::Module>("structs.codegen.ll", TheContext);

  generatePrintf();
  generateMain();

  TheModule->print(llvm::outs(), nullptr);

  return 0;
}
