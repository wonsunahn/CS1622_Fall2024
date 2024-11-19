; ModuleID = 'outputs/variables.ll'
source_filename = "outputs/variables.ll"

%Variables = type { i32 }

@Variables.global = global %Variables { i32 -1 }
@string.const = private unnamed_addr constant [5 x i8] c"x = \00", align 1
@printf.newline = private unnamed_addr constant [2 x i8] c"\0A\00", align 1
@printf.format = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1
@string.const.1 = private unnamed_addr constant [5 x i8] c"y = \00", align 1

declare i32 @printf(...)

define i32 @main() {
entry:
  %y = alloca i32
  store i32 4, i32* %y
  %0 = call i32 (...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @string.const, i32 0, i32 0))
  %1 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %2 = load i32, i32* getelementptr inbounds (%Variables, %Variables* @Variables.global, i32 0, i32 0)
  %3 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %2)
  %4 = call i32 (...) @printf(i8* getelementptr inbounds ([5 x i8], [5 x i8]* @string.const.1, i32 0, i32 0))
  %5 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  %6 = load i32, i32* %y
  %7 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %6)
  ret i32 0
}
