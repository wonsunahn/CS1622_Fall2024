; ModuleID = 'outputs/if-else-while-statements.ll'
source_filename = "outputs/if-else-while-statements.ll"

%IfElseWhile = type {}

@IfElseWhile.global = global %IfElseWhile zeroinitializer
@string.const = private unnamed_addr constant [4 x i8] c"x=?\00", align 1
@printf.newline = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@scanf.format = private unnamed_addr constant [3 x i8] c"%d\00", align 1
@string.const.1 = private unnamed_addr constant [4 x i8] c">10\00", align 1
@string.const.2 = private unnamed_addr constant [3 x i8] c">5\00", align 1
@string.const.3 = private unnamed_addr constant [4 x i8] c"<=5\00", align 1
@string.const.4 = private unnamed_addr constant [3 x i8] c"y=\00", align 1
@printf.format = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

declare i32 @scanf(...)

declare i32 @printf(...)

define i32 @main() {
entry:
  %x = alloca i32
  %y = alloca i32
  %0 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @string.const, i32 0, i32 0))
  %1 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %2 = call i32 (...) @scanf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @scanf.format, i32 0, i32 0), i32* %x)
  %3 = load i32, i32* %x
  %4 = icmp sgt i32 %3, 10
  br i1 %4, label %then, label %else

then:                                             ; preds = %entry
  %5 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @string.const.1, i32 0, i32 0))
  %6 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  ret i32 0

else:                                             ; preds = %entry
  %7 = load i32, i32* %x
  %8 = icmp sgt i32 %7, 5
  br i1 %8, label %then1, label %else2

then1:                                            ; preds = %else
  %9 = call i32 (...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @string.const.2, i32 0, i32 0))
  %10 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  br label %ifcont

else2:                                            ; preds = %else
  %11 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @string.const.3, i32 0, i32 0))
  %12 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  br label %ifcont

ifcont:                                           ; preds = %else2, %then1
  store i32 1, i32* %x
  store i32 0, i32* %y
  br label %loopcond

loopcond:                                         ; preds = %loopbody, %ifcont
  %13 = load i32, i32* %x
  %14 = icmp sle i32 %13, 10
  br i1 %14, label %loopbody, label %loopend

loopbody:                                         ; preds = %loopcond
  %15 = load i32, i32* %y
  %16 = load i32, i32* %x
  %17 = add i32 %15, %16
  store i32 %17, i32* %y
  %18 = load i32, i32* %x
  %19 = add i32 %18, 1
  store i32 %19, i32* %x
  br label %loopcond

loopend:                                          ; preds = %loopcond
  %20 = call i32 (...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @string.const.4, i32 0, i32 0))
  %21 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %22 = load i32, i32* %y
  %23 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %22)
  ret i32 0
}
