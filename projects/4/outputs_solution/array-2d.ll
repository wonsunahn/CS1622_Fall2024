; ModuleID = 'outputs/array-2d.ll'
source_filename = "outputs/array-2d.ll"

%Array2D = type { [4 x [3 x i32]] }

@Array2D.global = global %Array2D zeroinitializer
@printf.format = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

declare i32 @printf(...)

define i32 @main() {
entry:
  %j = alloca i32
  store i32 0, i32* %j
  %i = alloca i32
  store i32 0, i32* %i
  br label %loopcond

loopcond:                                         ; preds = %loopend3, %entry
  %0 = load i32, i32* %i
  %slt = icmp slt i32 %0, 3
  br i1 %slt, label %loopbody, label %loopend

loopbody:                                         ; preds = %loopcond
  store i32 0, i32* %j
  br label %loopcond1

loopend:                                          ; preds = %loopcond
  ret i32 0

loopcond1:                                        ; preds = %loopbody2, %loopbody
  %1 = load i32, i32* %j
  %slt4 = icmp slt i32 %1, 4
  br i1 %slt4, label %loopbody2, label %loopend3

loopbody2:                                        ; preds = %loopcond1
  %2 = load i32, i32* %i
  %array.element = getelementptr inbounds [4 x [3 x i32]], [4 x [3 x i32]]* getelementptr inbounds (%Array2D, %Array2D* @Array2D.global, i32 0, i32 0), i32 0, i32 %2
  %3 = load i32, i32* %j
  %array.element5 = getelementptr inbounds [3 x i32], [3 x i32]* %array.element, i32 0, i32 %3
  %4 = load i32, i32* %i
  %mul = mul i32 %4, 4
  %5 = load i32, i32* %j
  %add = add i32 %mul, %5
  store i32 %add, i32* %array.element5
  %6 = load i32, i32* %i
  %array.element6 = getelementptr inbounds [4 x [3 x i32]], [4 x [3 x i32]]* getelementptr inbounds (%Array2D, %Array2D* @Array2D.global, i32 0, i32 0), i32 0, i32 %6
  %7 = load i32, i32* %j
  %array.element7 = getelementptr inbounds [3 x i32], [3 x i32]* %array.element6, i32 0, i32 %7
  %8 = load i32, i32* %array.element7
  %9 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %8)
  %10 = load i32, i32* %j
  %add8 = add i32 %10, 1
  store i32 %add8, i32* %j
  br label %loopcond1

loopend3:                                         ; preds = %loopcond1
  %11 = load i32, i32* %i
  %add9 = add i32 %11, 1
  store i32 %add9, i32* %i
  br label %loopcond
}
