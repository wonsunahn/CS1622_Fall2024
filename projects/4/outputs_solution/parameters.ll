; ModuleID = 'outputs/parameters.ll'
source_filename = "outputs/parameters.ll"

%Parameters = type {}

@Parameters.global = global %Parameters zeroinitializer
@printf.format = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

declare i32 @printf(...)

define i32 @product(%Parameters* %0, i32 %1, i32 %2, i32 %3) {
entry:
  %p = alloca i32
  store i32 %1, i32* %p
  %x = alloca i32
  store i32 %2, i32* %x
  %y = alloca i32
  store i32 %3, i32* %y
  %4 = load i32, i32* %x
  %5 = load i32, i32* %y
  %6 = mul i32 %4, %5
  store i32 %6, i32* %p
  %7 = load i32, i32* %p
  %8 = load i32, i32* %p
  %9 = mul i32 %7, %8
  ret i32 %9
}

define i32 @main() {
entry:
  %p = alloca i32
  %x = alloca i32
  store i32 0, i32* %p
  %0 = load i32, i32* %p
  %1 = call i32 @product(%Parameters* @Parameters.global, i32 %0, i32 3, i32 4)
  store i32 %1, i32* %x
  %2 = load i32, i32* %p
  %3 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %2)
  %4 = load i32, i32* %x
  %5 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %4)
  ret i32 0
}
