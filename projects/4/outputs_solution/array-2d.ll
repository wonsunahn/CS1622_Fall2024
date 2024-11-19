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
  %1 = icmp slt i32 %0, 3
  br i1 %1, label %loopbody, label %loopend

loopbody:                                         ; preds = %loopcond
  store i32 0, i32* %j
  br label %loopcond1

loopend:                                          ; preds = %loopcond
  ret i32 0

loopcond1:                                        ; preds = %loopbody2, %loopbody
  %2 = load i32, i32* %j
  %3 = icmp slt i32 %2, 4
  br i1 %3, label %loopbody2, label %loopend3

loopbody2:                                        ; preds = %loopcond1
  %4 = load i32, i32* %i
  %array.element = getelementptr inbounds [4 x [3 x i32]], [4 x [3 x i32]]* getelementptr inbounds (%Array2D, %Array2D* @Array2D.global, i32 0, i32 0), i32 0, i32 %4
  %5 = load i32, i32* %j
  %array.element4 = getelementptr inbounds [3 x i32], [3 x i32]* %array.element, i32 0, i32 %5
  %6 = load i32, i32* %i
  %7 = mul i32 %6, 4
  %8 = load i32, i32* %j
  %9 = add i32 %7, %8
  store i32 %9, i32* %array.element4
  %10 = load i32, i32* %i
  %array.element5 = getelementptr inbounds [4 x [3 x i32]], [4 x [3 x i32]]* getelementptr inbounds (%Array2D, %Array2D* @Array2D.global, i32 0, i32 0), i32 0, i32 %10
  %11 = load i32, i32* %j
  %array.element6 = getelementptr inbounds [3 x i32], [3 x i32]* %array.element5, i32 0, i32 %11
  %12 = load i32, i32* %array.element6
  %13 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %12)
  %14 = load i32, i32* %j
  %15 = add i32 %14, 1
  store i32 %15, i32* %j
  br label %loopcond1

loopend3:                                         ; preds = %loopcond1
  %16 = load i32, i32* %i
  %17 = add i32 %16, 1
  store i32 %17, i32* %i
  br label %loopcond
}
