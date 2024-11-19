; ModuleID = 'outputs/fib.ll'
source_filename = "outputs/fib.ll"

%Fib = type {}

@Fib.global = global %Fib zeroinitializer
@printf.format = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

declare i32 @printf(...)

define i32 @fib(%Fib* %0, i32 %1) {
entry:
  %i = alloca i32
  store i32 %1, i32* %i
  %ret = alloca i32
  %2 = load i32, i32* %i
  %3 = icmp slt i32 %2, 3
  br i1 %3, label %then, label %else

then:                                             ; preds = %entry
  store i32 1, i32* %ret
  br label %ifcont

else:                                             ; preds = %entry
  %4 = load i32, i32* %i
  %5 = sub i32 %4, 1
  %6 = call i32 @fib(%Fib* %0, i32 %5)
  %7 = load i32, i32* %i
  %8 = sub i32 %7, 2
  %9 = call i32 @fib(%Fib* %0, i32 %8)
  %10 = add i32 %6, %9
  store i32 %10, i32* %ret
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %11 = load i32, i32* %ret
  ret i32 %11
}

define i32 @main() {
entry:
  %i = alloca i32
  store i32 1, i32* %i
  br label %loopcond

loopcond:                                         ; preds = %loopbody, %entry
  %0 = load i32, i32* %i
  %1 = icmp slt i32 %0, 10
  br i1 %1, label %loopbody, label %loopend

loopbody:                                         ; preds = %loopcond
  %2 = load i32, i32* %i
  %3 = add i32 %2, 1
  store i32 %3, i32* %i
  %4 = load i32, i32* %i
  %5 = call i32 @fib(%Fib* @Fib.global, i32 %4)
  %6 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %5)
  br label %loopcond

loopend:                                          ; preds = %loopcond
  ret i32 0
}
