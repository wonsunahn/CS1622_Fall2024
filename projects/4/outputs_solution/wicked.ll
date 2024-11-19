; ModuleID = 'outputs/wicked.ll'
source_filename = "outputs/wicked.ll"

%Point0 = type { [12 x i32], i32, i32 }
%Point1 = type { i32, %Point0 }
%Point2 = type { %Point1, %Point0, i32 }

@Point0.global = global %Point0 { [12 x i32] zeroinitializer, i32 0, i32 5 }
@string.const = private unnamed_addr constant [10 x i8] c"Before x=\00", align 1
@printf.newline = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@printf.format = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@string.const.1 = private unnamed_addr constant [9 x i8] c"After x=\00", align 1
@Point1.global = global %Point1 { i32 12, %Point0 { [12 x i32] zeroinitializer, i32 0, i32 5 } }
@string.const.2 = private unnamed_addr constant [11 x i8] c"Before t1=\00", align 1
@string.const.3 = private unnamed_addr constant [10 x i8] c"After t1=\00", align 1
@Point2.global = global %Point2 { %Point1 { i32 12, %Point0 { [12 x i32] zeroinitializer, i32 0, i32 5 } }, %Point0 { [12 x i32] zeroinitializer, i32 0, i32 5 }, i32 0 }
@string.const.4 = private unnamed_addr constant [10 x i8] c"p21.p1.x=\00", align 1
@string.const.5 = private unnamed_addr constant [11 x i8] c"p20.parr0:\00", align 1
@string.const.6 = private unnamed_addr constant [7 x i8] c"p20.x=\00", align 1

declare i32 @printf(...)

define void @f0(%Point0* %0) {
entry:
  %1 = call i32 (...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @string.const, i32 0, i32 0))
  %2 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %3 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 2
  %4 = load i32, i32* %3
  %5 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %4)
  %6 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 2
  %7 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 2
  %8 = load i32, i32* %7
  %9 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 2
  %10 = load i32, i32* %9
  %mul = mul i32 %8, %10
  store i32 %mul, i32* %6
  %11 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 1
  store i32 1, i32* %11
  br label %loopcond

loopcond:                                         ; preds = %loopbody, %entry
  %12 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 1
  %13 = load i32, i32* %12
  %slt = icmp slt i32 %13, 12
  br i1 %slt, label %loopbody, label %loopend

loopbody:                                         ; preds = %loopcond
  %14 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 0
  %15 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 1
  %16 = load i32, i32* %15
  %array.element = getelementptr inbounds [12 x i32], [12 x i32]* %14, i32 0, i32 %16
  %17 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 0
  %18 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 1
  %19 = load i32, i32* %18
  %sub = sub i32 %19, 1
  %array.element1 = getelementptr inbounds [12 x i32], [12 x i32]* %17, i32 0, i32 %sub
  %20 = load i32, i32* %array.element1
  %add = add i32 %20, 1
  store i32 %add, i32* %array.element
  %21 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 1
  %22 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 1
  %23 = load i32, i32* %22
  %add2 = add i32 %23, 1
  store i32 %add2, i32* %21
  br label %loopcond

loopend:                                          ; preds = %loopcond
  %24 = call i32 (...) @printf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @string.const.1, i32 0, i32 0))
  %25 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %26 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 2
  %27 = load i32, i32* %26
  %28 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %27)
  ret void
}

define void @f1(%Point1* %0) {
entry:
  %1 = call i32 (...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @string.const.2, i32 0, i32 0))
  %2 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %3 = getelementptr inbounds %Point1, %Point1* %0, i32 0, i32 0
  %4 = load i32, i32* %3
  %5 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %4)
  %6 = getelementptr inbounds %Point1, %Point1* %0, i32 0, i32 0
  store i32 1024, i32* %6
  %7 = getelementptr inbounds %Point1, %Point1* %0, i32 0, i32 1
  call void @f0(%Point0* %7)
  %8 = call i32 (...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @string.const.3, i32 0, i32 0))
  %9 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %10 = getelementptr inbounds %Point1, %Point1* %0, i32 0, i32 0
  %11 = load i32, i32* %10
  %12 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %11)
  ret void
}

define i32 @main() {
entry:
  %xx = alloca i32
  store i32 133, i32* %xx
  %px = alloca %Point1
  %0 = getelementptr inbounds %Point1, %Point1* %px, i32 0, i32 0
  store i32 12, i32* %0
  %1 = getelementptr inbounds %Point1, %Point1* %px, i32 0, i32 1
  %2 = getelementptr inbounds %Point0, %Point0* %1, i32 0, i32 0
  store [12 x i32] zeroinitializer, [12 x i32]* %2
  %3 = getelementptr inbounds %Point0, %Point0* %1, i32 0, i32 1
  %4 = getelementptr inbounds %Point0, %Point0* %1, i32 0, i32 2
  store i32 5, i32* %4
  call void @f0(%Point0* @Point0.global)
  call void @f0(%Point0* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 1))
  call void @f1(%Point1* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 0))
  %5 = getelementptr inbounds %Point1, %Point1* %px, i32 0, i32 1
  call void @f0(%Point0* %5)
  %6 = load i32, i32* %xx
  store i32 %6, i32* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 0, i32 0)
  call void @f1(%Point1* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 0))
  %7 = call i32 (...) @printf(i8* getelementptr inbounds ([10 x i8], [10 x i8]* @string.const.4, i32 0, i32 0))
  %8 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %9 = load i32, i32* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 0, i32 1, i32 2)
  %10 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %9)
  call void @f0(%Point0* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 1))
  store i32 0, i32* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 2)
  br label %loopcond

loopcond:                                         ; preds = %loopbody, %entry
  %11 = load i32, i32* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 2)
  %slt = icmp slt i32 %11, 12
  br i1 %slt, label %loopbody, label %loopend

loopbody:                                         ; preds = %loopcond
  %12 = call i32 (...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @string.const.5, i32 0, i32 0))
  %13 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %14 = load i32, i32* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 2)
  %array.element = getelementptr inbounds [12 x i32], [12 x i32]* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 1, i32 0), i32 0, i32 %14
  %15 = load i32, i32* %array.element
  %16 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %15)
  %17 = load i32, i32* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 2)
  %add = add i32 %17, 1
  store i32 %add, i32* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 2)
  br label %loopcond

loopend:                                          ; preds = %loopcond
  call void @f1(%Point1* @Point1.global)
  %18 = call i32 (...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @string.const.6, i32 0, i32 0))
  %19 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %20 = load i32, i32* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 1, i32 2)
  %21 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %20)
  ret i32 0
}
