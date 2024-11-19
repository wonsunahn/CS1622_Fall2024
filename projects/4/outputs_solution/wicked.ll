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
  %11 = mul i32 %8, %10
  store i32 %11, i32* %6
  %12 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 1
  store i32 1, i32* %12
  br label %loopcond

loopcond:                                         ; preds = %loopbody, %entry
  %13 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 1
  %14 = load i32, i32* %13
  %15 = icmp slt i32 %14, 12
  br i1 %15, label %loopbody, label %loopend

loopbody:                                         ; preds = %loopcond
  %16 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 0
  %17 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 1
  %18 = load i32, i32* %17
  %array.element = getelementptr inbounds [12 x i32], [12 x i32]* %16, i32 0, i32 %18
  %19 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 0
  %20 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 1
  %21 = load i32, i32* %20
  %22 = sub i32 %21, 1
  %array.element1 = getelementptr inbounds [12 x i32], [12 x i32]* %19, i32 0, i32 %22
  %23 = load i32, i32* %array.element1
  %24 = add i32 %23, 1
  store i32 %24, i32* %array.element
  %25 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 1
  %26 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 1
  %27 = load i32, i32* %26
  %28 = add i32 %27, 1
  store i32 %28, i32* %25
  br label %loopcond

loopend:                                          ; preds = %loopcond
  %29 = call i32 (...) @printf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @string.const.1, i32 0, i32 0))
  %30 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %31 = getelementptr inbounds %Point0, %Point0* %0, i32 0, i32 2
  %32 = load i32, i32* %31
  %33 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %32)
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
  %12 = icmp slt i32 %11, 12
  br i1 %12, label %loopbody, label %loopend

loopbody:                                         ; preds = %loopcond
  %13 = call i32 (...) @printf(i8* getelementptr inbounds ([11 x i8], [11 x i8]* @string.const.5, i32 0, i32 0))
  %14 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %15 = load i32, i32* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 2)
  %array.element = getelementptr inbounds [12 x i32], [12 x i32]* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 1, i32 0), i32 0, i32 %15
  %16 = load i32, i32* %array.element
  %17 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %16)
  %18 = load i32, i32* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 2)
  %19 = add i32 %18, 1
  store i32 %19, i32* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 2)
  br label %loopcond

loopend:                                          ; preds = %loopcond
  call void @f1(%Point1* @Point1.global)
  %20 = call i32 (...) @printf(i8* getelementptr inbounds ([7 x i8], [7 x i8]* @string.const.6, i32 0, i32 0))
  %21 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %22 = load i32, i32* getelementptr inbounds (%Point2, %Point2* @Point2.global, i32 0, i32 1, i32 2)
  %23 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %22)
  ret i32 0
}
