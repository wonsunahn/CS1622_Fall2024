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
  %slt = icmp slt i32 %2, 3
  br i1 %slt, label %then, label %else

then:                                             ; preds = %entry
  store i32 1, i32* %ret
  br label %ifcont

else:                                             ; preds = %entry
  %3 = load i32, i32* %i
  %sub = sub i32 %3, 1
  %4 = call i32 @fib(%Fib* %0, i32 %sub)
  %5 = load i32, i32* %i
  %sub1 = sub i32 %5, 2
  %6 = call i32 @fib(%Fib* %0, i32 %sub1)
  %add = add i32 %4, %6
  store i32 %add, i32* %ret
  br label %ifcont

ifcont:                                           ; preds = %else, %then
  %7 = load i32, i32* %ret
  ret i32 %7
}

define i32 @main() {
entry:
  %i = alloca i32
  store i32 1, i32* %i
  br label %loopcond

loopcond:                                         ; preds = %loopbody, %entry
  %0 = load i32, i32* %i
  %slt = icmp slt i32 %0, 10
  br i1 %slt, label %loopbody, label %loopend

loopbody:                                         ; preds = %loopcond
  %1 = load i32, i32* %i
  %add = add i32 %1, 1
  store i32 %add, i32* %i
  %2 = load i32, i32* %i
  %3 = call i32 @fib(%Fib* @Fib.global, i32 %2)
  %4 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %3)
  br label %loopcond

loopend:                                          ; preds = %loopcond
  ret i32 0
}
