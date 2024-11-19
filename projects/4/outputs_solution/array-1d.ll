; ModuleID = 'outputs/array-1d.ll'
source_filename = "outputs/array-1d.ll"

%Array1D = type { [10 x i32] }

@Array1D.global = global %Array1D { [10 x i32] [i32 0, i32 1, i32 2, i32 3, i32 4, i32 5, i32 6, i32 7, i32 8, i32 9] }
@printf.format = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

declare i32 @printf(...)

define i32 @main() {
entry:
  %arrLocal = alloca [10 x i32]
  %i = alloca i32
  store i32 0, i32* %i
  br label %loopcond

loopcond:                                         ; preds = %loopbody, %entry
  %0 = load i32, i32* %i
  %slt = icmp slt i32 %0, 10
  br i1 %slt, label %loopbody, label %loopend

loopbody:                                         ; preds = %loopcond
  %1 = load i32, i32* %i
  %array.element = getelementptr inbounds [10 x i32], [10 x i32]* %arrLocal, i32 0, i32 %1
  %2 = load i32, i32* %i
  %array.element1 = getelementptr inbounds [10 x i32], [10 x i32]* getelementptr inbounds (%Array1D, %Array1D* @Array1D.global, i32 0, i32 0), i32 0, i32 %2
  %3 = load i32, i32* %array.element1
  store i32 %3, i32* %array.element
  %4 = load i32, i32* %i
  %add = add i32 %4, 1
  store i32 %add, i32* %i
  br label %loopcond

loopend:                                          ; preds = %loopcond
  store i32 0, i32* %i
  br label %loopcond2

loopcond2:                                        ; preds = %loopbody3, %loopend
  %5 = load i32, i32* %i
  %slt5 = icmp slt i32 %5, 10
  br i1 %slt5, label %loopbody3, label %loopend4

loopbody3:                                        ; preds = %loopcond2
  %6 = load i32, i32* %i
  %array.element6 = getelementptr inbounds [10 x i32], [10 x i32]* %arrLocal, i32 0, i32 %6
  %7 = load i32, i32* %array.element6
  %8 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %7)
  %9 = load i32, i32* %i
  %add7 = add i32 %9, 1
  store i32 %add7, i32* %i
  br label %loopcond2

loopend4:                                         ; preds = %loopcond2
  ret i32 0
}
