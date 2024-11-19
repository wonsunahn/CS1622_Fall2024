; ModuleID = 'outputs/helloworld.ll'
source_filename = "outputs/helloworld.ll"

%Helloworld = type {}

@Helloworld.global = global %Helloworld zeroinitializer
@string.const = private unnamed_addr constant [16 x i8] c"Hello World !!!\00", align 1
@printf.newline = private unnamed_addr constant [2 x i8] c"\0A\00", align 1

declare i32 @printf(...)

define i32 @main() {
entry:
  %0 = call i32 (...) @printf(i8* getelementptr inbounds ([16 x i8], [16 x i8]* @string.const, i32 0, i32 0))
  %1 = call i32 (...) @printf(i8* getelementptr inbounds ([2 x i8], [2 x i8]* @printf.newline, i32 0, i32 0))
  ret i32 0
}
