; ModuleID = 'outputs/objects.ll'
source_filename = "outputs/objects.ll"

%Point = type { i32, i32 }
%Main = type { %Point }

@Point.global = global %Point { i32 10, i32 20 }
@string.const = private unnamed_addr constant [3 x i8] c"x=\00", align 1
@printf.newline = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@printf.format = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@string.const.1 = private unnamed_addr constant [3 x i8] c"y=\00", align 1
@Main.global = global %Main { %Point { i32 10, i32 20 } }
@string.const.2 = private unnamed_addr constant [9 x i8] c"Point.x=\00", align 1
@string.const.3 = private unnamed_addr constant [6 x i8] c"p1.x=\00", align 1

declare i32 @printf(...)

define void @f1(%Point* %0) {
entry:
  %1 = call i32 (...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @string.const, i32 0, i32 0))
  %2 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %3 = getelementptr inbounds %Point, %Point* %0, i32 0, i32 0
  %4 = load i32, i32* %3
  %5 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %4)
  %6 = call i32 (...) @printf(i8* getelementptr inbounds ([3 x i8], [3 x i8]* @string.const.1, i32 0, i32 0))
  %7 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %8 = getelementptr inbounds %Point, %Point* %0, i32 0, i32 1
  %9 = load i32, i32* %8
  %10 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %9)
  %11 = getelementptr inbounds %Point, %Point* %0, i32 0, i32 0
  %12 = getelementptr inbounds %Point, %Point* %0, i32 0, i32 0
  %13 = load i32, i32* %12
  %14 = add i32 %13, 1
  store i32 %14, i32* %11
  %15 = getelementptr inbounds %Point, %Point* %0, i32 0, i32 1
  %16 = getelementptr inbounds %Point, %Point* %0, i32 0, i32 1
  %17 = load i32, i32* %16
  %18 = add i32 %17, 2
  store i32 %18, i32* %15
  ret void
}

define i32 @main() {
entry:
  call void @f1(%Point* @Point.global)
  call void @f1(%Point* @Point.global)
  store i32 5, i32* getelementptr inbounds (%Main, %Main* @Main.global, i32 0, i32 0, i32 0)
  call void @f1(%Point* getelementptr inbounds (%Main, %Main* @Main.global, i32 0, i32 0))
  call void @f1(%Point* getelementptr inbounds (%Main, %Main* @Main.global, i32 0, i32 0))
  %0 = call i32 (...) @printf(i8* getelementptr inbounds ([9 x i8], [9 x i8]* @string.const.2, i32 0, i32 0))
  %1 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %2 = load i32, i32* getelementptr inbounds (%Point, %Point* @Point.global, i32 0, i32 0)
  %3 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %2)
  %4 = call i32 (...) @printf(i8* getelementptr inbounds ([6 x i8], [6 x i8]* @string.const.3, i32 0, i32 0))
  %5 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %6 = load i32, i32* getelementptr inbounds (%Main, %Main* @Main.global, i32 0, i32 0, i32 0)
  %7 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %6)
  ret i32 0
}
