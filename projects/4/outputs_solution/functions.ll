; ModuleID = 'outputs/functions.ll'
source_filename = "outputs/functions.ll"

%Functions = type {}

@Functions.global = global %Functions zeroinitializer
@printf.format = private unnamed_addr constant [4 x i8] c"%d\0A\00", align 1

declare i32 @printf(...)

define i32 @func(%Functions* %0) {
entry:
  ret i32 55
}

define i32 @main() {
entry:
  %0 = call i32 @func(%Functions* @Functions.global)
  %1 = call i32 @func(%Functions* @Functions.global)
  %2 = add i32 %0, %1
  %3 = call i32 (...) @printf(i8* getelementptr inbounds ([4 x i8], [4 x i8]* @printf.format, i32 0, i32 0), i32 %2)
  ret i32 0
}
